import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _callEmergency(String number) async {
    var status = await Permission.phone.request();

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
      backgroundColor: const Color(0xFF141424),
      appBar: AppBar(
        title: const Text('Emergências'),
        backgroundColor: const Color(0xFF24212F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: [
            _emergencyButton(context, 'Marinha', '185', Icons.directions_boat, const Color(0xFF316472)),
            _emergencyButton(context, 'Polícia Militar', '190', Icons.local_police, const Color(0xFF4F9297)),
            _emergencyButton(context, 'PRF', '191', Icons.car_crash, const Color(0xFFF38E0C)),
            _emergencyButton(context, 'SAMU', '192', Icons.health_and_safety, const Color(0xFFBFC9A3)),
            _emergencyButton(context, 'Bombeiros', '193', Icons.local_fire_department, const Color(0xFF282631)),
            _emergencyButton(context, 'Polícia Federal', '194', Icons.policy, const Color(0xFF90E5D5)),
            _emergencyButton(context, 'PRE', '198', Icons.directions_car, const Color(0xFF354048)),
            _emergencyButton(context, 'Defesa Civil', '199', Icons.warning, const Color(0xFF2D333D)),
          ],
        ),
      ),
    );
  }

  Widget _emergencyButton(BuildContext context, String text, String number, IconData icon, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      ),
      onPressed: () => _callEmergency(number),
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
}
