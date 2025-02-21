import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'map_screen.dart';
import 'checklist_screen.dart';
import 'tide_info_screen.dart';
import 'first_aid_screen.dart';
import 'weather_info_screen.dart';
import 'repeater_list_screen.dart';
import 'emergency_screen.dart';
import 'survival_guide_screen.dart';
import 'news_screen.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';
import 'nearby_locations_screen.dart';
import 'opsec_digital_screen.dart';
import 'premium_placeholder_page.dart';

void main() {
  runApp(const PrepApp());
}

class PrepApp extends StatelessWidget {
  const PrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrepApp',
      theme: ThemeData.dark(),
      home: const SplashScreen(), // Inicia com a tela de carregamento
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141424),
      appBar: AppBar(
        title: const Text('Esteja preparado!'),
        backgroundColor: const Color(0xFF24212F),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 60, 10, 0),
                items: [
                  menuItem(context, '📰 Notícias', NewsScreen()),
                  menuItem(context, '🎓 Treinamentos', PremiumPlaceholderPage()),
                  menuItem(context, 'ℹ️ Sobre o PrepApp', AboutScreen()),
                  menuItem(context, '🔏 Política de Privacidade', PrivacyPolicyScreen()),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/banner.png', width: 360),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              padding: const EdgeInsets.all(20),
              children: [
                squareButton(context, 'Mapa Interativo', Icons.map, const Color(0xFF316472), MapScreen()),
                squareButton(context, 'Locais Próximos', Icons.location_on, const Color(0xFF4F9297), NearbyLocationsScreen()),
                squareButton(context, 'Primeiros Socorros', Icons.health_and_safety, const Color(0xFFF38E0C), FirstAidScreen()),
                squareButton(context, 'Emergência', Icons.warning, const Color(0xFFBFC9A3), EmergencyScreen()),
                squareButton(context, 'Previsão Climática', Icons.cloud, const Color(0xFF282631), WeatherInfoScreen()),
                squareButton(context, 'Informações sobre Marés', Icons.waves, const Color(0xFF90E5D5), TideInfoScreen()),
                squareButton(context, 'Guia de Sobrevivência', Icons.book, const Color(0xFF354048), SurvivalGuideScreen()),
                squareButton(context, 'Repetidoras de Rádio', Icons.radio, const Color(0xFF2D333D), RepeaterListScreen()),
                squareButton(context, 'Checklists', Icons.checklist, const Color(0xFF4F9297), ChecklistScreen()),
                squareButton(context, 'OPSEC Digital', Icons.shield, const Color(0xFF5555AA), OPSECDigitalScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget squareButton(BuildContext context, String text, IconData icon, Color color, Widget screen) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
    ),
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.white),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

PopupMenuItem<int> menuItem(BuildContext context, String text, Widget screen) {
  return PopupMenuItem<int>(
    child: ListTile(
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    ),
  );
}
