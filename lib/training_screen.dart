import 'package:flutter/material.dart';

class TrainingScreen extends StatelessWidget {
  final bool isPremiumUser;

  const TrainingScreen({super.key, required this.isPremiumUser});

  @override
  Widget build(BuildContext context) {
    return isPremiumUser
        ? const TrainingContent()
        : const TrainingPlaceholder();
  }
}

class TrainingContent extends StatelessWidget {
  const TrainingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Treinamentos")),
      body: const Center(
        child: Text("Conteúdo exclusivo para usuários Premium!"),
      ),
    );
  }
}

class TrainingPlaceholder extends StatelessWidget {
  const TrainingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acesso Restrito")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Treinamentos estão disponíveis apenas para usuários Premium.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione aqui a navegação para a página de compra
              },
              child: const Text("Atualizar para Premium"),
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
      builder: (context) => TrainingScreen(isPremiumUser: isPremiumUser),
    ),
  );
}
