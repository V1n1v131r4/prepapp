import 'package:flutter/material.dart';

class SurvivalGuideScreen extends StatefulWidget {
  const SurvivalGuideScreen({super.key});

  @override
  _SurvivalGuideScreenState createState() => _SurvivalGuideScreenState();
}

class _SurvivalGuideScreenState extends State<SurvivalGuideScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final Map<String, List<Map<String, String>>> categories = {
    'Água': [
  {
    'title': 'Purificação de Água',
    'content': 'A purificação da água é essencial para evitar doenças transmitidas por micro-organismos. O método mais seguro é a fervura: basta ferver a água por pelo menos 5 minutos para eliminar patógenos. Outra opção são os filtros portáteis, que removem impurezas e sedimentos. Além disso, comprimidos de purificação com iodo ou cloro podem ser usados para tornar a água potável em poucos minutos.'
  },
  {
    'title': 'Coleta de Água da Chuva',
    'content': 'A captação de água da chuva é uma excelente alternativa para abastecimento em situações de sobrevivência. Utilize lonas, plásticos ou telhados inclinados para direcionar a água para recipientes limpos. Para evitar contaminação, é recomendável ferver a água coletada ou filtrá-la antes do consumo. Um sistema simples de coleta pode ser montado com um funil e um barril de armazenamento.'
  },
  {
    'title': 'Dessalinização',
    'content': 'A dessalinização é crucial quando se tem acesso apenas a água salgada. O método mais eficaz é a destilação por evaporação e condensação: ao ferver a água salgada e capturar o vapor em uma superfície fria, a água doce se separa do sal. Outra alternativa é o uso de filtros de osmose reversa, que são altamente eficazes, mas exigem equipamentos específicos e manutenção.'
  }
],
'Fogo': [
  {
    'title': 'Métodos de Acender Fogo',
    'content': 'Acender fogo é uma habilidade essencial na sobrevivência. Métodos tradicionais incluem o uso de isqueiros e fósforos à prova d’água. Alternativamente, pederneiras (ferrocerium) geram faíscas mesmo em condições úmidas. Técnicas primitivas, como fricção de madeira (arco e broca), exigem prática, mas podem ser úteis em situações extremas.'
  },
  {
    'title': 'Madeiras Ideais para Fogueira',
    'content': 'Para iniciar e manter uma fogueira, escolha madeiras secas e de combustão eficiente. Gravetos finos e folhas secas servem como iniciadores. Madeiras macias, como pinho e cedro, queimam rapidamente e são úteis para iniciar o fogo. Madeiras densas, como carvalho e nogueira, proporcionam brasas duradouras e calor intenso.'
  },
  {
    'title': 'Segurança ao Fazer Fogueira',
    'content': 'Sempre monte a fogueira em locais protegidos do vento e afastados de materiais inflamáveis. Cave um pequeno buraco ou cerque a fogueira com pedras para evitar que as chamas se espalhem. Tenha sempre água ou areia por perto para extinguir o fogo rapidamente. Após o uso, certifique-se de apagar completamente as brasas para evitar incêndios acidentais.'
  }
],
'Abrigo': [
  {
    'title': 'Construção de Abrigos Naturais',
    'content': 'Em situações de emergência, abrigos naturais podem salvar vidas. Utilize materiais disponíveis no ambiente, como galhos, folhas e pedras. Um abrigo simples pode ser feito inclinando galhos contra um tronco caído e cobrindo-os com vegetação para isolamento térmico. Se possível, adicione folhas secas no interior para criar uma camada de isolamento contra o frio.'
  },
  {
    'title': 'Melhores Locais para Abrigo',
    'content': 'Escolher um local adequado para montar um abrigo é tão importante quanto a sua construção. Evite áreas baixas, pois podem alagar em caso de chuva. Prefira locais protegidos do vento e longe de encostas íngremes que possam desmoronar. Se estiver em ambiente frio, procure um local com exposição ao sol para aquecimento natural.'
  },
  {
    'title': 'Isolamento Térmico',
    'content': 'O isolamento térmico é essencial para manter o calor corporal durante a noite. Use folhas secas, musgo ou grama para forrar o chão do abrigo e evitar a perda de calor pelo contato com o solo. Cobertores térmicos refletores também são extremamente úteis. Se possível, construa uma pequena barreira contra o vento usando troncos e pedras para bloquear correntes de ar frias.'
  }
],
'Alimento': [
  {
    'title': 'Plantas Comestíveis',
    'content': 'O conhecimento sobre plantas comestíveis pode ser um diferencial na sobrevivência. Algumas plantas seguras incluem dente-de-leão, trevo e urtiga, ricos em nutrientes. Antes de consumir qualquer planta, faça o teste de comestibilidade: esfregue uma pequena porção nos lábios e aguarde reações adversas. Evite plantas com seiva leitosa ou odor forte, pois podem ser tóxicas.'
  },
  {
    'title': 'Técnicas de Caça',
    'content': 'Em ambientes selvagens, a caça pode ser necessária para obtenção de proteína. Armadilhas simples, como laços e buracos camuflados, podem capturar pequenos animais sem exigir muita energia. Arcos, lanças e estilingues são opções para caça ativa. O consumo seguro envolve cozinhar bem a carne para eliminar parasitas e bactérias.'
  },
  {
    'title': 'Armazenamento de Alimentos',
    'content': 'Manter os alimentos secos e protegidos de pragas é essencial. Alimentos desidratados duram mais e podem ser armazenados em sacos vedados. Pendurar alimentos em árvores reduz o risco de ataques de animais. Em locais frios, cavar um pequeno buraco na terra pode funcionar como uma geladeira natural para conservação de alimentos perecíveis.'
  }
],
'Defesa': [
  {
    'title': 'Autodefesa na Natureza',
    'content': 'A autodefesa é crucial em ambientes selvagens. Mantenha-se atento a ruídos estranhos e rastros no chão. Evite confrontos com animais selvagens e, se necessário, faça barulhos altos para afugentá-los. Em casos de ataque, proteja órgãos vitais e busque pontos de fuga rapidamente.'
  },
  {
    'title': 'Armas Improvisadas',
    'content': 'Em cenários de sobrevivência, armas improvisadas podem ser úteis para defesa. Bastões afiados, estacas e lanças são fáceis de fabricar e oferecem proteção contra animais e ameaças humanas. Estilingues e fundas são eficientes para caça e autodefesa de médio alcance.'
  },
  {
    'title': 'Evitação de Perigos',
    'content': 'A melhor defesa é evitar situações de risco. Evite áreas desconhecidas durante a noite e mantenha distância de locais com sinais de atividade animal. Aprenda a identificar rastros e comportamentos de predadores locais para minimizar encontros inesperados. Sempre tenha um plano de fuga em mente.'
  }
],
'Equipamentos': [
  {
    'title': 'Mochila de Emergência',
    'content': 'Uma mochila de emergência deve conter itens essenciais para pelo menos 72 horas. Inclua ferramentas multifuncionais, facas afiadas, lanternas, baterias extras e suprimentos médicos. O peso deve ser equilibrado para facilitar o transporte em longas caminhadas.'
  },
  {
    'title': 'Itens Essenciais',
    'content': 'Os itens essenciais variam conforme o ambiente, mas alguns são indispensáveis: cordas resistentes, bússola, kit de primeiros socorros e filtros de água. Lanternas de dínamo são ideais para evitar dependência de baterias.'
  },
  {
    'title': 'Roupas Adequadas',
    'content': 'O vestuário certo pode salvar vidas. Em climas frios, vista-se em camadas para isolamento térmico. Roupas impermeáveis evitam hipotermia em ambientes úmidos. Botas resistentes protegem os pés em terrenos acidentados.'
  }
],
'Preparação': [
  {
    'title': 'Plano de Fuga',
    'content': 'Ter um plano de fuga bem definido é essencial para emergências. Mapeie rotas alternativas e estabeleça pontos de encontro com sua equipe ou família. Pratique evacuações periódicas para garantir eficiência em situações reais.'
  },
  {
    'title': 'Treinamento em Sobrevivência',
    'content': 'Treinamento constante melhora as chances de sobrevivência. Pratique acender fogo, construir abrigos e navegar com bússola. Aprender primeiros socorros pode fazer a diferença em situações críticas.'
  },
  {
    'title': 'Comunicação em Emergências',
    'content': 'Rádios portáteis, apitos e sinais visuais são essenciais para se comunicar em situações extremas. Defina códigos de comunicação com seu grupo e mantenha sempre baterias carregadas ou métodos alternativos de energia.'
  }
],
  'Técnicas de Sobrevivência': [
  {
      'title': 'Técnicas de Plantio e Armazenamento',
      'content': 'Para garantir segurança alimentar, cultive alimentos de ciclo curto, como batatas, feijão e milho. Utilize compostagem para enriquecer o solo e técnicas como rotação de culturas para manter a fertilidade. Para armazenamento, seque grãos ao sol e guarde em recipientes herméticos para evitar pragas e umidade.'
   },
   {
     'title': 'Proteína Animal (Técnicas e Cuidados)',
     'content': 'A criação de pequenos animais, como galinhas e coelhos, é eficiente para obtenção de proteína. Garanta abrigo adequado, alimentação equilibrada e acesso a água limpa. A caça exige conhecimento de rastreamento e armadilhas, sempre respeitando legislações locais.'
   },
   {
     'title': 'Pesca',
     'content': 'A pesca é uma excelente fonte de alimento. Técnicas eficazes incluem anzol e linha, armadilhas submersas e redes. Identifique locais propícios, como rios de correnteza moderada e lagos ricos em peixes. A preservação da pesca envolve respeitar períodos de reprodução e tamanhos mínimos de captura.'
    },
    {
     'title': 'Coleta de Plantas e Frutas Silvestres',
     'content': 'O conhecimento sobre plantas comestíveis é essencial. Estude guias confiáveis e aprenda a identificar espécies seguras. Evite plantas com seiva leitosa ou odor forte, pois muitas são tóxicas. Frutas e raízes devem ser coletadas com moderação para não esgotar recursos naturais locais.'
   }
  ],
    'Energia Solar': [
      {
        'title': 'Painéis Solares Portáteis',
        'content': 'Os painéis solares portáteis são uma excelente opção para gerar energia em ambientes remotos. Eles podem carregar dispositivos essenciais como lanternas, rádios e celulares. Escolha um painel leve e dobrável para facilitar o transporte.'
      },
      {
        'title': 'Armazenamento de Energia',
        'content': 'Para garantir energia mesmo quando o sol não está presente, utilize baterias recarregáveis. Modelos de íon-lítio são os mais recomendados por sua durabilidade e eficiência. Conecte corretamente os painéis solares a um banco de baterias para melhor aproveitamento.'
      },
      {
        'title': 'Eficácia em Diferentes Condições',
        'content': 'A eficiência dos painéis solares pode variar conforme a inclinação e a incidência de luz solar. Durante dias nublados, a geração de energia pode ser reduzida, tornando essencial um bom planejamento de armazenamento.'
      },
    ],
    'Bug out Bag': [
      {
        'title': 'Montagem da Bug out Bag',
        'content': 'Uma Bug out Bag deve conter itens essenciais para sobrevivência por pelo menos 72 horas. Isso inclui água, alimentos não perecíveis, ferramentas multifuncionais e equipamentos de proteção. Escolha uma mochila resistente e confortável para facilitar o transporte.'
      },
      {
        'title': 'Itens Essenciais',
        'content': 'Além de mantimentos básicos, adicione um kit de primeiros socorros, cobertores térmicos e lanternas. Um rádio de emergência e baterias extras são fundamentais para manter-se informado.'
      },
      {
        'title': 'Manutenção e Atualização',
        'content': 'Reveja o conteúdo da mochila regularmente, substituindo itens vencidos e ajustando conforme a estação do ano. Teste os equipamentos para garantir que estão funcionando corretamente quando necessário.'
      },
    ],
    'Bug out Vehicle': [
      {
        'title': 'Escolhendo o Veículo Ideal',
        'content': 'Um bom veículo de fuga deve ser robusto, econômico e preparado para enfrentar terrenos difíceis. SUVs, caminhonetes e veículos off-road são ótimas escolhas. Personalize o veículo com racks de carga e armazenamento extra para suprimentos.'
      },
      {
        'title': 'Modificações e Equipamentos',
        'content': 'Adicione tanques extras de combustível, pneus reforçados e um kit de ferramentas completo. Sistemas de comunicação, como rádios CB, também são essenciais para manter contato em emergências.'
      },
      {
        'title': 'Manutenção e Planejamento',
        'content': 'Realize manutenções periódicas para garantir que o veículo esteja sempre pronto para uso. Mapeie rotas seguras e pontos estratégicos de reabastecimento para evitar contratempos durante evacuações.'
      },
    ],
    'Bug out Location': [
      {
        'title': 'Escolhendo o Local Perfeito',
        'content': 'Uma Bug out Location deve ser afastada de áreas urbanas, segura e de fácil acesso. Prefira locais com fontes naturais de água e boas condições para cultivo. Considere a proximidade de riscos naturais e a facilidade de defesa.'
      },
      {
        'title': 'Infraestrutura e Recursos',
        'content': 'Tenha um abrigo seguro e bem equipado com mantimentos duráveis. Geradores de energia, filtros de água e estoques de alimentos são fundamentais para uma estadia prolongada.'
      },
      {
        'title': 'Segurança e Sustentabilidade',
        'content': 'Evite chamar atenção para sua localização. Plante alimentos de forma discreta e desenvolva técnicas de defesa passiva para evitar invasores. Estabeleça uma rotina de monitoramento e segurança no local.'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Guia de Sobrevivência'),
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
