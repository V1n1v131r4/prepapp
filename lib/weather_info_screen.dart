import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoaaWeatherScreen extends StatefulWidget {
  const NoaaWeatherScreen({super.key});

  @override
  _NoaaWeatherScreenState createState() => _NoaaWeatherScreenState();
}

class _NoaaWeatherScreenState extends State<NoaaWeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final url = Uri.parse('https://api.weather.gov/gridpoints/BOU/62,54/forecast');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'FlutterApp (your_email@example.com)', // NOAA exige um User-Agent válido
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherData = data['properties'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao carregar os dados (Código: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao buscar dados: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Condições Climáticas - NOAA'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: weatherData?['periods'].length ?? 0,
                  itemBuilder: (context, index) {
                    final period = weatherData?['periods'][index];
                    return Card(
                      child: ListTile(
                        title: Text(period['name'] ?? 'Sem nome'),
                        subtitle: Text(period['detailedForecast'] ?? 'Sem previsão disponível'),
                        trailing: Text('${period['temperature']}° ${period['temperatureUnit']}'),
                      ),
                    );
                  },
                ),
    );
  }
}
