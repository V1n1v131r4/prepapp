import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import relativo pro shim
import '../location_shim.dart';

// OBS: guarde a key de forma segura/por flavor de build em produção.
const String apiKey = "decae72b5a444fa9b93171941251802";

class WeatherInfoScreen extends StatefulWidget {
  const WeatherInfoScreen({super.key});

  @override
  State<WeatherInfoScreen> createState() => _WeatherInfoScreenState();
}

class _WeatherInfoScreenState extends State<WeatherInfoScreen> {
  final AppLocation _appLoc = AppLocation();

  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  Future<void> _fetchWeather(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url = Uri.parse("https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$query&lang=pt");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao carregar os dados: ${response.reasonPhrase}';
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

  Future<void> _fetchWeatherByLocation() async {
    try {
      final data = await _appLoc.getCurrentLocation();
      final lat = data?.latitude;
      final lon = data?.longitude;
      if (lat == null || lon == null) {
        setState(() => errorMessage = 'Não foi possível obter a localização.');
        return;
      }
      await _fetchWeather("$lat,$lon");
    } catch (e) {
      setState(() => errorMessage = 'Erro ao obter localização: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condições Climáticas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Buscar cidade",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _fetchWeather(_cityController.text),
                ),
              ),
              onSubmitted: _fetchWeather,
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading && errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            if (!isLoading && errorMessage.isEmpty)
              Expanded(
                child: Center(
                  child: weatherData != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              weatherData!["location"]["name"],
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${weatherData!["current"]["temp_c"]}°C",
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              weatherData!["current"]["condition"]["text"],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : const Text("Nenhuma informação disponível."),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchWeatherByLocation,
        label: const Text("Usar minha localização"),
        icon: const Icon(Icons.my_location),
      ),
    );
  }
}
