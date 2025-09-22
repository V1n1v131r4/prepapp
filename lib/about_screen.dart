import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _appName = 'PrepApp';
  static const _version = '1.0.6-fdroid';
  static const _website = 'https://bunqrlabs.com'; 
  static const _email = 'contact@bunqrlabs.com';   

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // fallback silencioso
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeQueryComponent('subject=$_appName ($_version) – contato'),
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: const Color(0xFF24212F),
      ),
      backgroundColor: const Color(0xFF141424),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          Text(_appName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text('Versão $_version • Build F-Droid (FLOSS)', style: textStyle),
          const SizedBox(height: 20),
          Text(
            'O PrepApp ajuda você a estar preparado: guias de sobrevivência, '
            'primeiros socorros, ações de emergência, locais próximos, '
            'repetidoras de rádio, marés e clima. Esta build é 100% FLOSS '
            '(sem Google Play Services e nenhum tipo de rastreamento).',
            style: textStyle,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Site'),
            subtitle: Text(_website),
            onTap: () => _openUrl(_website),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Contato'),
            subtitle: Text(_email),
            onTap: () => _sendEmail(_email),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Licença'),
            subtitle: const Text('MIT (veja LICENSE na raiz do repositório)'),
          ),
        ],
      ),
    );
  }
}
