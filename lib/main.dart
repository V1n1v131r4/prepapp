import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'premium_placeholder_page.dart';
import 'training_content.dart';
import 'calculator_screen.dart';
import 'weather_alert_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool available = await InAppPurchase.instance.isAvailable();
  if (!available) {
    debugPrint("⚠️ Google Play Billing não está disponível.");
  }
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
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isPremium = prefs.getBool('isPremium') ?? false;
    setState(() {
      _isPremium = isPremium;
    });

    final Stream<List<PurchaseDetails>> purchaseStream = InAppPurchase.instance.purchaseStream;
    purchaseStream.listen((purchaseDetailsList) {
      for (var purchase in purchaseDetailsList) {
        if (purchase.productID == "prepapp_premium" &&
            (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored)) {
          prefs.setBool('isPremium', true);
          setState(() {
            _isPremium = true;
          });
          break;
        }
      }
    });
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

  Widget squareButton(BuildContext context, String title, IconData icon, Color color, Widget destination) {
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
            if (!_isPremium)
              menuItem(context, '🚀 Upgrade para Premium', PremiumPlaceholderPage())
            else
              menuItem(context, '🎓 Treinamentos', TrainingContentScreen()),
            menuItem(context, 'ℹ️ Sobre o PrepApp', AboutScreen()),
            menuItem(context, '🔏 Política de Privacidade', PrivacyPolicyScreen()),
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
                squareButton(context, 'Guia de Sobrevivência', Icons.book, const Color(0xFF354048), SurvivalGuideScreen()),
                squareButton(context, 'Primeiros Socorros', Icons.health_and_safety, const Color(0xFFF38E0C), FirstAidScreen()),
                squareButton(context, 'Emergência', Icons.warning, const Color(0xFFBFC9A3), EmergencyScreen()),
                squareButton(context, 'Locais Próximos', Icons.location_on, const Color(0xFF4F9297), NearbyLocationsScreen()),
                squareButton(context, 'Mapa Interativo', Icons.map, const Color(0xFF316472), MapScreen()),
                squareButton(context, 'Previsão Climática', Icons.cloud, const Color(0xFF282631), WeatherInfoScreen()),
                squareButton(context, 'Calculadora de Alimentos', Icons.calculate, const Color(0xFF8A2BE2), FoodCalculatorScreen()),
                squareButton(context, 'Alertas Climáticos', Icons.calculate, const Color.fromARGB(255, 2, 43, 0), AlertasClimaticosScreen()),
                squareButton(context, 'OPSEC Digital', Icons.shield, const Color(0xFF5555AA), OPSECDigitalScreen()),
                squareButton(context, 'Repetidoras de Rádio', Icons.radio, const Color(0xFF2D333D), RepeaterListScreen()),
                squareButton(context, 'Informações sobre Marés', Icons.waves, const Color(0xFF90E5D5), TideInfoScreen()),
                squareButton(context, 'Checklists', Icons.checklist, const Color(0xFF4F9297), ChecklistScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}