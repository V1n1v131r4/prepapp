import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class AlertasClimaticosScreen extends StatefulWidget {
  @override
  _AlertasClimaticosScreenState createState() => _AlertasClimaticosScreenState();
}

class _AlertasClimaticosScreenState extends State<AlertasClimaticosScreen> {
  final TextEditingController _cityController = TextEditingController();
  List<Map<String, String>> _alerts = [];
  List<Map<String, String>> _filteredAlerts = [];
  String _statusMessage = "Carregando alertas...";
  String? _userLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _fetchAlerts(position.latitude, position.longitude);
    } catch (e) {
      setState(() => _statusMessage = "Erro ao obter localização.");
      _fetchAlerts();
    }
  }

  Future<void> _fetchAlerts([double? lat, double? lon]) async {
    final url = "https://apiprevmet3.inmet.gov.br/avisos/rss/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        setState(() => _statusMessage = "Erro ao carregar alertas.");
        return;
      }

      final document = xml.XmlDocument.parse(utf8.decode(response.bodyBytes));
      final items = document.findAllElements('item');
      List<Map<String, String>> alerts = [];

      for (var item in items) {
        String title = item.findElements('title').isNotEmpty
            ? item.findElements('title').single.text
            : "Sem título";
        String description = item.findElements('description').isNotEmpty
            ? _parseDescription(item.findElements('description').single.text)
            : "Sem descrição";
        String pubDate = item.findElements('pubDate').isNotEmpty
            ? item.findElements('pubDate').single.text
            : "Data desconhecida";

        bool isNearby = lat != null && lon != null && title.toLowerCase().contains("${lat.toInt()}");
        
        alerts.add({
          "title": title,
          "description": description,
          "date": _formatDate(pubDate),
          "isNearby": isNearby.toString(),
        });
      }

      alerts.sort((a, b) => (b["isNearby"] == "true" ? 1 : 0).compareTo(a["isNearby"] == "true" ? 1 : 0));

      setState(() {
        _alerts = alerts;
        _filteredAlerts = alerts;
        _statusMessage = alerts.isEmpty ? "Nenhum alerta disponível." : "";
      });
    } catch (e) {
      print("Erro ao obter alertas: $e");
      setState(() => _statusMessage = "Erro ao processar os alertas.");
    }
  }

  String _parseDescription(String text) {
    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    final RegExp regex = RegExp(
        r'Status\s*(.*?)(?=Evento|$)|'
        r'Evento\s*(.*?)(?=Severidade|$)|'
        r'Severidade\s*(.*?)(?=Início|$)|'
        r'Início\s*(.*?)(?=Fim|$)|'
        r'Fim\s*(.*?)(?=Descrição|$)|'
        r'Descrição\s*(.*)');

    final matches = regex.allMatches(text);

    String status = "Desconhecido";
    String evento = "Desconhecido";
    String severidade = "Desconhecido";
    String inicio = "Não informado";
    String fim = "Não informado";
    String descricao = "Sem detalhes";

    for (var match in matches) {
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
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day.toString().padLeft(2, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.year} "
          "${parsedDate.hour.toString().padLeft(2, '0')}:"
          "${parsedDate.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return date;
    }
  }

  void _filterAlerts(String query) {
    setState(() {
      _filteredAlerts = _alerts
          .where((alert) => alert["title"]!.toLowerCase().contains(query.toLowerCase()) ||
              alert["description"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alertas Climáticos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Buscar por cidade ou palavra-chave",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _filterAlerts(_cityController.text),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Text(_statusMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = _filteredAlerts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert["title"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(alert["description"]!, style: TextStyle(fontSize: 14)),
                          SizedBox(height: 8),
                          Text("Data: ${alert["date"]!}", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
