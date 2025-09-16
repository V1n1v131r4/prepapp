import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Gate e vendors (stub F-Droid)
import 'feature_gate.dart';
import 'vendors/vendors.dart';
import 'vendors/vendors_fdroid.dart';

import 'pdf_view_screen.dart';
import 'map_screen.dart';
import 'checklist_screen.dart';
import 'tide_info_screen.dart';
import 'first_aid_screen.dart';
import 'weather_info_screen.dart';
import 'repeater_list_screen.dart';
import 'emergency_screen.dart';
import 'survival_guide_screen.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';
import 'nearby_locations_screen.dart';
import 'opsec_digital_screen.dart';
import 'calculator_screen.dart';
import 'weather_alert_screen.dart';

late final Vendors vendors;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  vendors = const VendorsFdroid();
  await vendors.init();
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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ---- helpers para abrir email/site ----
  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'contact@bunqrlabs.com',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o app de e-mail.')),
      );
    }
  }

  Future<void> _launchSite() async {
    final uri = Uri.parse('https://bunqrlabs.com');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o site.')),
      );
    }
  }

  Widget menuItem(BuildContext context, String title, Widget destination) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  Widget squareButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget destination,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    vendors.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF141424),
      appBar: AppBar(
        title: const Text('Esteja preparado!'),
        backgroundColor: const Color(0xFF24212F),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color.fromRGBO(36, 33, 47, 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('PrepApp', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Esteja preparado!', style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),
            menuItem(context, 'ℹ️ Sobre o PrepApp', const AboutScreen()),
            menuItem(context, '🔏 Política de Privacidade', const PrivacyPolicyScreen()),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Contato: contact@bunqrlabs.com'),
              onTap: _launchEmail,
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Site: bunqrlabs.com'),
              onTap: _launchSite,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset('assets/banner.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              padding: const EdgeInsets.all(20),
              children: [
                squareButton(context, 'Guia de Sobrevivência', Icons.book, const Color(0xFF354048), const SurvivalGuideScreen()),
                squareButton(context, 'Primeiros Socorros', Icons.health_and_safety, const Color(0xFFF38E0C), const FirstAidScreen()),
                squareButton(context, 'Emergência', Icons.warning, const Color(0xFFBFC9A3), const EmergencyScreen()),
                squareButton(context, 'Locais Próximos', Icons.location_on, const Color(0xFF4F9297), NearbyLocationsScreen()),
                squareButton(context, 'Calculadora de Alimentos', Icons.calculate, const Color.fromARGB(255, 2, 43, 0), FoodCalculatorScreen()),
                squareButton(context, 'Alertas Climáticos', Icons.campaign, const Color.fromARGB(255, 124, 46, 26), AlertasClimaticosScreen()),
                squareButton(context, 'Mapa Interativo', Icons.map, const Color(0xFF316472), const MapScreen()),
                squareButton(context, 'Previsão Climática', Icons.cloud, const Color(0xFF282631), WeatherInfoScreen()),
                squareButton(context, 'OPSEC Digital', Icons.shield, const Color(0xFF5555AA), OPSECDigitalScreen()),
                squareButton(context, 'Repetidoras de Rádio', Icons.radio, const Color(0xFF90E5D5), RepeaterListScreen()),
                squareButton(context, 'Informações sobre Marés', Icons.waves, const Color(0xFF4F9297), TideInfoScreen()),
                squareButton(context, 'Checklists', Icons.checklist, const Color(0xFF2D333D), ChecklistScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
