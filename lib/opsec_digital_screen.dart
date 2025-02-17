import 'package:flutter/material.dart';

class OPSECDigitalScreen extends StatefulWidget {
  const OPSECDigitalScreen({super.key});

  @override
  _OPSECDigitalScreenState createState() => _OPSECDigitalScreenState();
}

class _OPSECDigitalScreenState extends State<OPSECDigitalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final Map<String, List<Map<String, String>>> categories = {
    'Privacidade Online': [
      {
        'title': 'Importância da Privacidade',
        'content': 'A privacidade online protege seus dados pessoais contra abusos, rastreamento indevido e roubo de identidade. Utilizar ferramentas como navegadores seguros e bloqueadores de rastreamento reduz sua exposição.'
      },
      {
        'title': 'Navegação Anônima',
        'content': 'Modos de navegação anônima, como o Tor e VPNs, ajudam a ocultar sua identidade online. No entanto, é importante entender suas limitações e configurar corretamente para maior segurança.'
      },
    ],
    'VPN': [
      {
        'title': 'O que é e como funciona',
        'content': 'Uma VPN (Virtual Private Network) criptografa sua conexão e oculta seu IP, garantindo maior privacidade. É útil para proteger-se em redes Wi-Fi públicas e evitar monitoramento de provedores de internet.'
      },
      {
        'title': 'Escolhendo uma VPN Segura',
        'content': 'Ao escolher uma VPN, prefira serviços que não guardam registros de conexão e oferecem criptografia forte. Evite VPNs gratuitas, pois muitas delas lucram vendendo seus dados.'
      },
    ],
    'Redes Sociais': [
      {
        'title': 'Riscos e Exposição de Dados',
        'content': 'Redes sociais coletam grandes quantidades de dados pessoais. Limite as permissões de aplicativos, evite compartilhar informações sensíveis e revise configurações de privacidade regularmente.'
      },
      {
        'title': 'Identidade Digital Segura',
        'content': 'Utilizar pseudônimos, separar contas pessoais e profissionais e restringir quem pode visualizar suas postagens ajuda a manter sua identidade segura.'
      },
    ],
    'Dispositivos Móveis': [
      {
        'title': 'Segurança no Smartphone',
        'content': 'Ative autenticação em dois fatores, use senhas fortes e mantenha o sistema atualizado. Evite baixar aplicativos de fontes não oficiais para reduzir riscos de malware.'
      },
      {
        'title': 'Monitoramento e Rastreio',
        'content': 'Muitos aplicativos rastreiam sua localização e comportamento. Desative serviços de rastreamento quando não forem necessários e revise permissões concedidas a cada app.'
      },
    ],
    'Criptomoedas': [
      {
        'title': 'Carteiras Seguras',
        'content': 'Para proteger suas criptomoedas, utilize carteiras de hardware ou carteiras frias (offline). Evite armazená-las em exchanges, pois estão sujeitas a ataques.'
      },
      {
        'title': 'Transações Anônimas',
        'content': 'Algumas criptomoedas, como Monero e Zcash, oferecem maior privacidade em transações. Utilize misturadores de moedas e redes privadas para dificultar rastreamentos.'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('OPSEC Digital'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: categories.keys.map((category) {
                  List<Map<String, String>> filteredArticles = categories[category]!
                      .where((article) => article['title']!.toLowerCase().contains(_searchQuery))
                      .toList();

                  if (_searchQuery.isNotEmpty && filteredArticles.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return ExpansionTile(
                    title: Text(category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    collapsedBackgroundColor: Colors.grey[850],
                    backgroundColor: Colors.grey[900],
                    children: filteredArticles.map((article) {
                      return ListTile(
                        title: Text(article['title']!, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(article['content']!, style: const TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
