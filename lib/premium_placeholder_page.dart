import 'package:flutter/material.dart';
import 'training_content.dart'; // Importando a página de treinamento premium

class PremiumPlaceholderPage extends StatefulWidget {
  @override
  _PremiumPlaceholderPageState createState() => _PremiumPlaceholderPageState();
}

class _PremiumPlaceholderPageState extends State<PremiumPlaceholderPage> {
  bool isProcessing = false; // Para evitar múltiplos cliques durante a compra

  Future<void> processPurchase() async {
    setState(() {
      isProcessing = true;
    });

    // Simula um processo de pagamento
    await Future.delayed(const Duration(seconds: 2));

    // Após a compra, redireciona para a página de treinamento
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TrainingContentScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade para Premium")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Acesse conteúdos exclusivos de treinamento ao se tornar Premium!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Benefícios do Premium:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "- Acesso ilimitado a treinamentos\n"
              "- Atualizações exclusivas\n"
              "- Suporte prioritário",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isProcessing ? null : processPurchase,
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upgrade para Premium"),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToTraining(BuildContext context, bool isPremiumUser) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => isPremiumUser ? TrainingContentScreen() : PremiumPlaceholderPage(),
    ),
  );
}
