import 'package:flutter/material.dart';

class TrainingContentScreen extends StatelessWidget {
  const TrainingContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treinamentos"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTrainingCard(
            title: "Noções Básicas de Sobrevivência",
            description: "Aprenda técnicas essenciais para sobrevivência em situações extremas.",
          ),
          _buildTrainingCard(
            title: "Primeiros Socorros em Emergências",
            description: "Guia prático para lidar com ferimentos, fraturas e outras emergências médicas.",
          ),
          _buildTrainingCard(
            title: "Orientação e Navegação",
            description: "Saiba como usar mapas, bússolas e técnicas de navegação para se localizar em qualquer terreno.",
          ),
          _buildTrainingCard(
            title: "Técnicas de Obtenção de Água Potável",
            description: "Métodos eficazes para encontrar e purificar água na natureza.",
          ),
          _buildTrainingCard(
            title: "Construção de Abrigos de Emergência",
            description: "Aprenda a montar diferentes tipos de abrigos para proteção contra intempéries.",
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard({required String title, required String description}) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          // Aqui você pode adicionar a navegação para os detalhes do treinamento
        },
      ),
    );
  }
}