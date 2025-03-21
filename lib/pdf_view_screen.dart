import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class PdfViewerScreen extends StatefulWidget {
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath; // Caminho temporário do PDF
  bool _error = false; // Para mostrar erro na tela

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      print("📂 Obtendo diretório temporário...");
      final tempDir = await getTemporaryDirectory();
      final tempFile = File("${tempDir.path}/meu_arquivo.pdf");

      print("📂 Diretório temporário: ${tempDir.path}");
      print("📂 Arquivo de destino: ${tempFile.path}");

      // Verifica se já existe para evitar cópias desnecessárias
      if (!tempFile.existsSync()) {
        print("📄 Copiando PDF dos assets...");
        final data = await rootBundle.load("assets/meu_arquivo.pdf");
        await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      } else {
        print("✅ PDF já existe no diretório temporário.");
      }

      // Verifica se o arquivo foi copiado corretamente
      if (await tempFile.exists()) {
        setState(() {
          _localPath = tempFile.path;
        });
        print("✅ PDF carregado com sucesso: ${tempFile.path}");
      } else {
        throw Exception("Falha ao copiar PDF.");
      }
    } catch (e) {
      print("❌ Erro ao carregar PDF: $e");
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visualizador de PDF")),
      body: _error
          ? Center(child: Text("Erro ao carregar PDF", style: TextStyle(color: Colors.red, fontSize: 18)))
          : _localPath == null
              ? Center(child: CircularProgressIndicator()) // Mostra loading enquanto carrega
              : PDFView(
                  filePath: _localPath, // Caminho do PDF carregado
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                  onError: (error) {
                    print("❌ Erro no PDFView: $error");
                    setState(() {
                      _error = true;
                    });
                  },
                  onRender: (pages) {
                    print("📄 PDF renderizado com $pages páginas.");
                  },
                ),
    );
  }
}
