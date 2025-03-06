import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'training_content.dart'; // Importando a página de treinamento premium

class PremiumPlaceholderPage extends StatefulWidget {
  @override
  _PremiumPlaceholderPageState createState() => _PremiumPlaceholderPageState();
}

class _PremiumPlaceholderPageState extends State<PremiumPlaceholderPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isPremium = false;
  bool _isProcessing = false;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _initializePurchase();
  }

  /// 🔄 **Inicializa e verifica compras anteriores**
  Future<void> _initializePurchase() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint("⚠️ In-App Purchases não está disponível.");
      return;
    }

    // Escuta mudanças na compra (compra nova ou restauração)
    _iap.purchaseStream.listen((List<PurchaseDetails> purchases) {
      _handlePurchaseUpdates(purchases);
    });

    // Carrega os produtos da loja
    _loadProducts();

    // Carregar o status de Premium salvo
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPremiumSaved = prefs.getBool('isPremium') ?? false;
    setState(() {
      _isPremium = isPremiumSaved;
    });
  }

  /// 🛍️ **Carrega os produtos disponíveis**
  Future<void> _loadProducts() async {
    const Set<String> _productIds = {'prepapp_premium'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_productIds);

    if (response.productDetails.isNotEmpty) {
      setState(() {
        _products = response.productDetails;
      });
    }
  }

  /// 🎯 **Verifica e atualiza status das compras**
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == "prepapp_premium") {
          setState(() {
            _isPremium = true;
          });

          // Salvar o status de Premium
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isPremium', true);

          // Navegar automaticamente para a página de conteúdo Premium
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TrainingContentScreen()),
          );
        }
      }
    }
  }

  /// 💳 **Processa a compra**
  Future<void> _buyPremium() async {
    if (_products.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: _products.first);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade para Premium")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Acesse conteúdos exclusivos de treinamento ao se tornar Premium!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Benefícios do Premium:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "- Acesso ilimitado a treinamentos\n"
              "- Atualizações exclusivas\n"
              "- Suporte prioritário",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _isPremium
                ? const Text(
                    "✅ Você já é Premium!",
                    style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : ElevatedButton(
                    onPressed: _isProcessing ? null : _buyPremium,
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _products.isNotEmpty ? "Upgrade para Premium (${_products.first.price})" : "Carregando...",
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
