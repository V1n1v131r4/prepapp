import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FoodCalculatorScreen extends StatefulWidget {
  @override
  _FoodCalculatorScreenState createState() => _FoodCalculatorScreenState();
}

class _FoodCalculatorScreenState extends State<FoodCalculatorScreen> {
  List<Map<String, dynamic>> _foods = [];
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _gramsController = TextEditingController();
  final TextEditingController _pricePerKgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedFoods();
  }

  Future<void> _loadSavedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedFoods = prefs.getString('saved_foods');
    if (savedFoods != null) {
      setState(() {
        _foods = List<Map<String, dynamic>>.from(json.decode(savedFoods));
      });
    }
  }

  Future<void> _saveFoods() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_foods', json.encode(_foods));
  }

  void _addFood() {
    if (_foodController.text.isEmpty ||
        _gramsController.text.isEmpty ||
        _pricePerKgController.text.isEmpty) return;

    double gramsPerDay = double.tryParse(_gramsController.text) ?? 0;
    double pricePerKg = double.tryParse(_pricePerKgController.text) ?? 0;
    double monthlyWeight = gramsPerDay * 30 / 1000;
    double annualWeight = monthlyWeight * 12;
    double totalAnnualCost = annualWeight * pricePerKg;

    setState(() {
      _foods.add({
        'name': _foodController.text,
        'gramsPerDay': gramsPerDay,
        'monthlyWeight': monthlyWeight,
        'annualWeight': annualWeight,
        'pricePerKg': pricePerKg,
        'totalAnnualCost': totalAnnualCost,
      });
    });

    _saveFoods();

    _foodController.clear();
    _gramsController.clear();
    _pricePerKgController.clear();
  }

  void _removeFood(int index) {
    setState(() {
      _foods.removeAt(index);
    });
    _saveFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de Preparação de Alimentos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _foodController,
              decoration: InputDecoration(labelText: 'Nome do Alimento'),
            ),
            TextField(
              controller: _gramsController,
              decoration: InputDecoration(labelText: 'Gramas por dia'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pricePerKgController,
              decoration: InputDecoration(labelText: 'Preço por Kg'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addFood,
              child: Text('Adicionar Alimento'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  final food = _foods[index];
                  return ListTile(
                    title: Text(food['name']),
                    subtitle: Text(
                        'Mensal: ${food['monthlyWeight'].toStringAsFixed(2)} Kg - Anual: ${food['annualWeight'].toStringAsFixed(2)} Kg\nCusto Anual: R\$${food['totalAnnualCost'].toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFood(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
