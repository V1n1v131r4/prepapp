import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _callEmergency(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Não foi possível iniciar a chamada para $number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Emergências'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: [
            emergencyButton(context, '🚢 Marinha', '185'),
            emergencyButton(context, '🚔 Polícia Militar', '190'),
            emergencyButton(context, '🚓 PRF', '191'),
            emergencyButton(context, '🚑 SAMU', '192'),
            emergencyButton(context, '🔥 Bombeiros', '193'),
            emergencyButton(context, '🕵️ Polícia Federal', '194'),
            emergencyButton(context, '🚔 PRE', '198'),
            emergencyButton(context, '⚠️ Defesa Civil', '199'),
          ],
        ),
      ),
    );
  }

  Widget emergencyButton(BuildContext context, String text, String number) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      ),
      onPressed: () => _callEmergency(number),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
