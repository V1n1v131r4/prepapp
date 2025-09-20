// lib/weather_alert_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../location_shim.dart';

class AlertasClimaticosScreen extends StatefulWidget {
  const AlertasClimaticosScreen({super.key});

  @override
  State<AlertasClimaticosScreen> createState() => _AlertasClimaticosScreenState();
}

class _AlertasClimaticosScreenState extends State<AlertasClimaticosScreen> {
  final TextEditingController _cityController = TextEditingController();
  final AppLocation _appLoc = AppLocation();

  List<Map<String, String>> _alerts = [];
  List<Map<String, String>> _filteredAlerts = [];
  String _statusMessage = "Carregando alertas...";
  double? _lat;
  double? _lon;

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  Future<void> _initLocationAndFetch() async {
    try {
      final data = await _appLoc.getCurrentLocation();
      _lat = data?.latitude;
      _lon = data?.longitude;
    } catch (_) {
      // segue sem localização
    } finally {
      await _fetchAlerts(_lat, _lon);
    }
  }

  Future<void> _fetchAlerts([double? lat, double? lon]) async {
    const url = "https://apiprevmet3.inmet.gov.br/avisos/rss/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        setState(() => _statusMessage = "Erro ao carregar alertas.");
        return;
      }

      final document = xml.XmlDocument.parse(utf8.decode(response.bodyBytes));
      final items = document.findAllElements('item');
      final alerts = <Map<String, String>>[];

      for (final item in items) {
        final title = item.getElement('title')?.innerText ?? "Sem título";
        final descriptionRaw = item.getElement('description')?.innerText ?? "Sem descrição";
        final description = _parseDescription(descriptionRaw);
        final pubDate = item.getElement('pubDate')?.innerText ?? "Data desconhecida";

        // Heurística simples; podemos evoluir depois por UF/cidade
        final isNearby = (lat != null && lon != null) && title.toLowerCase().contains("região");

        alerts.add({
          "title": title,
          "description": description,
          "date": _formatDate(pubDate),
          "isNearby": isNearby.toString(),
        });
      }

      alerts.sort((a, b) {
        final ai = a["isNearby"] == "true" ? 1 : 0;
        final bi = b["isNearby"] == "true" ? 1 : 0;
        return bi.compareTo(ai);
      });

      setState(() {
        _alerts = alerts;
        _filteredAlerts = alerts;
        _statusMessage = alerts.isEmpty ? "Nenhum alerta disponível." : "";
      });
    } catch (e) {
      setState(() => _statusMessage = "Erro ao processar os alertas.");
    }
  }

  String _parseDescription(String text) {
    // remove tags HTML
    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    final regex = RegExp(
      r'Status\s*(.*?)(?=Evento|$)|'
      r'Evento\s*(.*?)(?=Severidade|$)|'
      r'Severidade\s*(.*?)(?=Início|$)|'
      r'Início\s*(.*?)(?=Fim|$)|'
      r'Fim\s*(.*?)(?=Descrição|$)|'
      r'Descrição\s*(.*)',
    );

    String status = "Desconhecido";
    String evento = "Desconhecido";
    String severidade = "Desconhecido";
    String inicio = "Não informado";
    String fim = "Não informado";
    String descricao = "Sem detalhes";

    for (final match in regex.allMatches(text)) {
      if (match.group(1) != null) status = match.group(1)!.trim();
      if (match.group(2) != null) evento = match.group(2)!.trim();
      if (match.group(3) != null) severidade = match.group(3)!.trim();
      if (match.group(4) != null) inicio = match.group(4)!.trim();
      if (match.group(5) != null) fim = match.group(5)!.trim();
      if (match.group(6) != null) descricao = match.group(6)!.trim();
    }

    return "Status: $status\n"
        "Evento: $evento\n"
        "Severidade: $severidade\n"
        "Início: $inicio\n"
        "Fim: $fim\n"
        "Descrição: $descricao";
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return "${parsed.day.toString().padLeft(2, '0')}/"
          "${parsed.month.toString().padLeft(2, '0')}/"
          "${parsed.year} "
          "${parsed.hour.toString().padLeft(2, '0')}:"
          "${parsed.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return date;
    }
  }

  void _filterAlerts(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filteredAlerts = _alerts.where((a) {
        final t = a["title"]?.toLowerCase() ?? "";
        final d = a["description"]?.toLowerCase() ?? "";
        return t.contains(q) || d.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alertas Climáticos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Buscar por cidade ou palavra-chave",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _filterAlerts(_cityController.text),
                ),
              ),
              onSubmitted: _filterAlerts,
            ),
            const SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Text(_statusMessage, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = _filteredAlerts[index];
                  final highlight = alert["isNearby"] == "true";
                  return Card(
                    color: highlight ? Colors.amber[50] : null,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert["title"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(alert["description"]!, style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Text("Data: ${alert["date"]!}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
