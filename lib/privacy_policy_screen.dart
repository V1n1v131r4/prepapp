import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Política de Privacidade"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Política de Privacidade",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Última atualização: 19/02/2025",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                "A Bunqr Labs valoriza a privacidade e a segurança dos usuários do PrepApp. "
                "Esta política explica como tratamos seus dados e o uso de permissões no aplicativo.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "1. Coleta de Dados",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "O PrepApp não coleta, armazena ou compartilha qualquer dado pessoal dos usuários. "
                "Nosso aplicativo foi desenvolvido para funcionar sem necessidade de criar contas "
                "ou fornecer informações pessoais.",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                "2. Uso da Localização",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "O PrepApp pode solicitar permissão para acessar sua localização para fornecer funcionalidades "
                "que incluem:\n\n"
                "- Exibição do mapa com sua posição atual.\n"
                "- Informações sobre clima, trânsito e locais próximos.\n\n"
                "A permissão para acessar a localização é opcional. Você pode recusá-la ou desativá-la "
                "a qualquer momento nas configurações do seu dispositivo. Caso não conceda a permissão, "
                "algumas funcionalidades podem ser limitadas, mas o aplicativo continuará funcionando normalmente.",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                "3. Permissões do Aplicativo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Além da localização, o PrepApp pode solicitar outras permissões para funcionalidades específicas, "
                "sempre com a sua autorização. Todas as permissões são utilizadas exclusivamente para a funcionalidade "
                "oferecida, sem coleta ou armazenamento de dados.",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                "4. Alterações nesta Política",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Podemos atualizar esta Política de Privacidade periodicamente. Caso isso ocorra, informaremos os usuários "
                "sobre qualquer alteração significativa.\n\n"
                "Contato: contact@bunqrlabs.com\n"
                "Site: bunqrlabs.com",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
