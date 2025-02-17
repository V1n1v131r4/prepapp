import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  _FirstAidScreenState createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Primeiros Socorros'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ficha de Saúde'),
            Tab(text: 'Guia Interativo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HealthRecordScreen(),
          FirstAidGuideScreen(),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// ✅ GUIA INTERATIVO DE PRIMEIROS SOCORROS
// ------------------------------------------------
class FirstAidGuideScreen extends StatelessWidget {
  const FirstAidGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGuideItem('🚑 RCP (Reanimação Cardiopulmonar)', 
          '1️⃣ Verifique se a pessoa responde e respira.\n'
          '2️⃣ Caso não respire, inicie compressões torácicas (100 a 120 por minuto).\n'
          '3️⃣ Alterne 30 compressões com 2 ventilações (boca-a-boca, se treinado).\n'
          '4️⃣ Continue até a chegada do socorro ou recuperação da vítima.'
        ),
        _buildGuideItem('🔥 Evasão de Incêndios', 
          '1️⃣ Mantenha-se próximo ao chão para evitar inalar fumaça.\n'
          '2️⃣ Use um pano molhado para cobrir nariz e boca.\n'
          '3️⃣ Evite elevadores e use escadas.\n'
          '4️⃣ Se possível, feche portas para reduzir a propagação do fogo.\n'
          '5️⃣ Chame o Corpo de Bombeiros (193) e busque saídas seguras.'
        ),
        _buildGuideItem('🌊 Evasão de Afogamentos (Veículos e Embarcações)', 
          '1️⃣ Se estiver em um veículo, tente abrir as janelas imediatamente.\n'
          '2️⃣ Se a janela não abrir, use um objeto pesado para quebrá-la.\n'
          '3️⃣ Desaperte o cinto de segurança e ajude os passageiros a sair.\n'
          '4️⃣ Mantenha a calma e nade na direção mais segura (correnteza fraca ou superfície).'
        ),
        _buildGuideItem('☠️ Procedimentos para Gases Venenosos', 
          '1️⃣ Afaste-se imediatamente do ambiente contaminado.\n'
          '2️⃣ Se não for possível sair, cubra o rosto com um pano úmido.\n'
          '3️⃣ Ventile o local abrindo janelas, se seguro.\n'
          '4️⃣ Busque atendimento médico se houver sintomas como tontura, náusea ou desmaio.'
        ),
        _buildGuideItem('🆘 Dicas Gerais de Primeiros Socorros', 
          '✅ Ligue para emergências caso a situação pareça grave (SAMU - 192).\n'
          '✅ Em caso de cortes profundos, aplique pressão direta com um pano limpo.\n'
          '✅ Para queimaduras, resfrie com água corrente por pelo menos 10 minutos.\n'
          '✅ Em caso de engasgos, se a pessoa estiver consciente, faça a manobra de Heimlich. Se desmaiar, inicie a RCP.\n'
          '✅ Em caso de torções, imobilize e aplique gelo.\n'
          '✅ Em caso de picada de Cobra, mantenha a vítima calma, imobilize o local da picada e leve-a imediatamente ao hospital. Não faça torniquetes nem tente sugar o veneno.\n'
          '✅ Em caso de envenenamento identifique a substância e ligue imediatamente para o centro de intoxicações ou leve a vítima ao hospital. Não induza vômito sem orientação médica.\n'
          '✅ Em caso de convulsão Afaste objetos ao redor para evitar lesões e aguarde a crise passar. Não segure a pessoa nem tente colocar algo em sua boca.'
        ),
      ],
    );
  }

  static Widget _buildGuideItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------
// ✅ FICHA DE SAÚDE (HEALTH RECORD)
// ------------------------------------------------
class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  _HealthRecordScreenState createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  bool _isEditing = false;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _loadHealthRecord();
  }

  Future<void> _loadHealthRecord() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bloodTypeController.text = prefs.getString('bloodType') ?? '';
      _weightController.text = prefs.getString('weight') ?? '';
      _heightController.text = prefs.getString('height') ?? '';
      _allergiesController.text = prefs.getString('allergies') ?? '';
      _medicationsController.text = prefs.getString('medications') ?? '';
      _notesController.text = prefs.getString('notes') ?? '';

      _hasData = _bloodTypeController.text.isNotEmpty;
    });
  }

  Future<void> _saveHealthRecord() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bloodType', _bloodTypeController.text);
    await prefs.setString('weight', _weightController.text);
    await prefs.setString('height', _heightController.text);
    await prefs.setString('allergies', _allergiesController.text);
    await prefs.setString('medications', _medicationsController.text);
    await prefs.setString('notes', _notesController.text);

    setState(() {
      _isEditing = false;
      _hasData = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ficha de saúde salva!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _isEditing || !_hasData
          ? _buildHealthForm()
          : _buildSummary(),
    );
  }

  Widget _buildHealthForm() {
    return ListView(
      children: [
        _buildTextField('Tipo Sanguíneo', _bloodTypeController),
        _buildTextField('Peso (kg)', _weightController),
        _buildTextField('Altura (cm)', _heightController),
        _buildTextField('Alergias', _allergiesController),
        _buildTextField('Remédios de uso contínuo', _medicationsController),
        _buildTextField('Observações gerais', _notesController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveHealthRecord,
          child: const Text('Salvar Ficha'),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Tipo Sanguíneo', _bloodTypeController.text),
        _buildInfoRow('Peso', _weightController.text),
        _buildInfoRow('Altura', _heightController.text),
        _buildInfoRow('Alergias', _allergiesController.text),
        _buildInfoRow('Remédios de uso contínuo', _medicationsController.text),
        _buildInfoRow('Observações', _notesController.text),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: const Text('Editar'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
