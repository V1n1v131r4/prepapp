import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _callEmergency(String number) async {
    var status = await Permission.phone.request(); // Solicita permissão

    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: number);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Erro ao tentar iniciar a chamada para $number. Tentando fallback...');
        try {
          await launchUrl(phoneUri);
        } catch (e) {
          debugPrint('Falha ao iniciar a chamada: $e');
        }
      }
    } else {
      debugPrint('Permissão de chamada não concedida.');
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
            _emergencyButton('🚢 Marinha', '185'),
            _emergencyButton('🚔 Polícia Militar', '190'),
            _emergencyButton('🚓 PRF', '191'),
            _emergencyButton('🚑 SAMU', '192'),
            _emergencyButton('🔥 Bombeiros', '193'),
            _emergencyButton('🕵️ Polícia Federal', '194'),
            _emergencyButton('🚔 PRE', '198'),
            _emergencyButton('⚠️ Defesa Civil', '199'),
          ],
        ),
      ),
    );
  }

  Widget _emergencyButton(String text, String number) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      ),
      onPressed: () => _callEmergency(number),
      icon: const Icon(Icons.phone, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
