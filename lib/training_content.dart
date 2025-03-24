import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class TrainingContentScreen extends StatelessWidget {
  final List<Map<String, String>> pdfFiles = [
    {"title": "Comece pelo começo", "asset": "assets/Comece_pelo_Comeco.pdf"},
    {"title": "Treinando a Mente e o Corpo", "asset": "assets/Treinando_a_Mente_e_o_Corpo.pdf"},
    {"title": "Lâminas e Armas de Fogo", "asset": "assets/Laminas_e_Armas_de_Fogo.pdf"},
    {"title": "Mochila de Sobrevivência B.O.B", "asset": "assets/Mochila_de_Sobrevivencia_BOB.pdf"},
    {"title": "Técnicas de Evasão Urbana", "asset": "assets/Tecnicas_de_Evasao_Urbana.pdf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treinamentos"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: pdfFiles.map((pdf) => _buildTrainingCard(context, pdf['title']!, pdf['asset']!)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: () {
                print("Abrindo comunidade no Telegram...");
              },
              icon: Icon(Icons.telegram, size: 24),
              label: Text("Faça parte da nossa comunidade exclusiva para membros no Telegram", style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(BuildContext context, String title, String asset) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                pdfAsset: asset,
                title: title,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfAsset;
  final String title;

  PdfViewerScreen({required this.pdfAsset, required this.title});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File("${tempDir.path}/${widget.pdfAsset.split('/').last}");

      if (!tempFile.existsSync()) {
        final data = await rootBundle.load(widget.pdfAsset);
        await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      }

      if (await tempFile.exists()) {
        setState(() {
          _localPath = tempFile.path;
        });
      } else {
        throw Exception("Falha ao copiar PDF.");
      }
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _error
          ? Center(child: Text("Erro ao carregar PDF", style: TextStyle(color: Colors.red, fontSize: 18)))
          : _localPath == null
              ? Center(child: CircularProgressIndicator())
              : PDFView(
                  filePath: _localPath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                ),
    );
  }
}
