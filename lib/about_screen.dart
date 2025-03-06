import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sobre o PrepApp'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Aumentei o espaço com a borda
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Somos o primeiro App de Sobrevivência e Preparação focado no público brasileiro.',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), // Fonte um pouco menor
              ),
              const SizedBox(height: 10),
              const Text(
                'O celular é indispensável hoje em dia, e por quê não usarmos ele para benefício das nossas preparações e sobrevivência?',
                style: TextStyle(color: Colors.white, fontSize: 14), // Fonte um pouco menor
              ),
              const SizedBox(height: 20),
              const Text(
                'O PrepApp tem as seguintes funcionalidades:',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '- Mapa interativo da localização atual do usuário, com a opção de salvá-lo offline para uso sem internet disponível.\n'
                '- Pontos de interesse próximos da localização do usuário, tais como: pontos de coleta de água, parques nacionais, postos de combustível, lojas de ferramentas, hospitais, dentre outros.\n'
                '- Ficha de Saúde\n'
                '- Guia interativo de Primeiros-Socorros para situações de emergência\n'
                '- "Botão de emergência" com opção de ligar com apenas um clique para os principais serviços de emergência do Brasil.\n'
                '- Previsão do clima baseada na localização, com opção de buscar por outra localidade.\n'
                '- Informações sobre Marés\n'
                '- Lista das principais Repetidoras de Radioamador do Brasil\n'
                '- Guia de Sobrevivência completo, com conteúdos exclusivos sobre água, fogo, abrigo, alimentos, defesa, equipamentos, preparação, técnicas de sobrevivência, mochila de evasão e etc.\n'
                '- Dicas de OPSEC digital\n'
                '- Calculadora de preparação, com a função de montar kits de alimentos para armazenamento baseado em dietas calóricas diárias\n'
                '- e muito mais.',
                style: TextStyle(color: Colors.white, fontSize: 14), // Fonte um pouco menor
              ),
              const SizedBox(height: 20),
              const Text(
                'Para os nossos usuários Premium, o PrepApp tem uma área exclusiva de cursos e treinamentos nos diversos temas de Sobrevivencialismo e Preparação, com conteúdos exclusivos e interativos (vídeo aulas, Lives e etc).',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Esteja preparado!',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/bunqr_logo.png', // Certifique-se que o arquivo está no caminho correto
                      width: 100,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'www.bunqrstudios.com',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}