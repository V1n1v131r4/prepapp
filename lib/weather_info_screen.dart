import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

const String apiKey = "decae72b5a444fa9b93171941251802";

class WeatherInfoScreen extends StatefulWidget {
  const WeatherInfoScreen({super.key});

  @override
  _WeatherInfoScreenState createState() => _WeatherInfoScreenState();
}

class _WeatherInfoScreenState extends State<WeatherInfoScreen> {
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

    final url = Uri.parse("http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$query&lang=pt");
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
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _fetchWeather("${position.latitude},${position.longitude}");
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao obter localização: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condições Climáticas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Buscar cidade",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _fetchWeather(_cityController.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : errorMessage.isNotEmpty
                    ? Text(errorMessage, style: const TextStyle(color: Colors.red))
                    : weatherData != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
