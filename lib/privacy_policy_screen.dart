import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Política de Privacidade")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Política de Privacidade",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Última atualização: 19/02/2025"),
              SizedBox(height: 16),
              Text(
                "A BunQr Studios valoriza a privacidade e a segurança dos usuários do PrepApp. Esta política explica como tratamos seus dados e o uso de permissões no aplicativo.",
              ),
              SizedBox(height: 16),
              Text(
                "1. Coleta de Dados",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "O PrepApp não coleta, armazena ou compartilha qualquer dado pessoal dos usuários. Nosso aplicativo foi desenvolvido para funcionar sem necessidade de criar contas ou fornecer informações pessoais.",
              ),
              SizedBox(height: 16),
              Text(
                "2. Uso da Localização",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "O PrepApp pode solicitar permissão para acessar sua localização para fornecer funcionalidades que incluem:\n\n"
                "- Exibição do mapa com sua posição atual.\n"
                "- Informações sobre clima, trânsito e locais próximos.\n\n"
                "A permissão para acessar a localização é opcional. Você pode recusá-la ou desativá-la a qualquer momento nas configurações do seu dispositivo. Caso não conceda a permissão, algumas funcionalidades podem ser limitadas, mas o aplicativo continuará funcionando normalmente.",
              ),
              SizedBox(height: 16),
              Text(
                "3. Permissões do Aplicativo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Além da localização, o PrepApp pode solicitar outras permissões para funcionalidades específicas, sempre com a sua autorização. Todas as permissões são utilizadas exclusivamente para a funcionalidade oferecida, sem coleta ou armazenamento de dados.",
              ),
              SizedBox(height: 16),
              Text(
                "4. Alterações nesta Política",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Podemos atualizar esta Política de Privacidade periodicamente. Caso isso ocorra, informaremos os usuários sobre qualquer alteração significativa.\n\n"
                "Se tiver dúvidas, entre em contato conosco pelo e-mail: contato@bunqr.com.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
