import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class RepeaterListScreen extends StatefulWidget {
  const RepeaterListScreen({super.key});

  @override
  _RepeaterListScreenState createState() => _RepeaterListScreenState();
}

class _RepeaterListScreenState extends State<RepeaterListScreen> {
  List<Map<String, String>> repeaters = [];
  List<Map<String, String>> filteredRepeaters = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _showRegulationPopup();
    fetchRepeaters();
  }

  Future<void> _showRegulationPopup() async {
    await Future.delayed(Duration(milliseconds: 500)); // Pequeno delay para exibir após a abertura da tela
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Aviso Importante"),
        content: Text("O Serviço de Radioamador é regulado pela legislação de telecomunicações e por normas específicas. A Agência Nacional de Telecomunicações (ANATEL) é responsável por regular o Serviço de Radioamador."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Entendi"),
          ),
        ],
      ),
    );
  }

  Future<void> fetchRepeaters() async {
    const url = 'https://antenaativa.com.br/lista-de-repetidoras-analogicas-brasileiras/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final rows = document.querySelectorAll('table tbody tr');
        
        List<Map<String, String>> tempRepeaters = [];
        for (var row in rows) {
          final cells = row.querySelectorAll('td');
          if (cells.length >= 4) {
            tempRepeaters.add({
              'cidade': cells[0].text.trim(),
              'estado': cells[1].text.trim(),
              'frequencia': cells[2].text.trim(),
              'tom': cells[3].text.trim(),
            });
          }
        }
        
        setState(() {
          repeaters = tempRepeaters;
          filteredRepeaters = repeaters;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao carregar os dados (Código: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao buscar dados: $e';
        isLoading = false;
      });
    }
  }

  void filterRepeaters(String query) {
    setState(() {
      filteredRepeaters = repeaters
          .where((repeater) =>
              repeater['cidade']!.toLowerCase().contains(query.toLowerCase()) ||
              repeater['estado']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repetidoras de Radioamador')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por cidade ou estado...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: filterRepeaters,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredRepeaters.length,
                        itemBuilder: (context, index) {
                          final repeater = filteredRepeaters[index];
                          return Card(
                            child: ListTile(
                              title: Text('${repeater['cidade']} - ${repeater['estado']}'),
                              subtitle: Text('Frequência: ${repeater['frequencia']} MHz | Tom: ${repeater['tom']}'),
                              leading: const Icon(Icons.radio),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
