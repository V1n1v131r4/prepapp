import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import relativo pro shim
import '../location_shim.dart';

class NOAAWeatherScreen extends StatefulWidget {
  const NOAAWeatherScreen({super.key});

  @override
  State<NOAAWeatherScreen> createState() => _NOAAWeatherScreenState();
}

class _NOAAWeatherScreenState extends State<NOAAWeatherScreen> {
  final AppLocation _appLoc = AppLocation();

  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchLocationAndWeather();
  }

  Future<void> fetchLocationAndWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await _appLoc.getCurrentLocation();
      final lat = data?.latitude;
      final lon = data?.longitude;

      if (lat == null || lon == null) {
        throw 'Não foi possível obter a localização atual.';
      }

      await fetchWeatherData(lat, lon);
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao obter localização: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherData(double lat, double lon) async {
    final pointUrl = Uri.parse('https://api.weather.gov/points/$lat,$lon');

    try {
      final pointResponse = await http.get(pointUrl, headers: {
        'User-Agent': 'PrepApp (contact@bunqrlabs.com)',
      });

      if (pointResponse.statusCode != 200) {
        throw 'Erro ao obter ponto NOAA (Código: ${pointResponse.statusCode})';
      }

      final pointData = json.decode(pointResponse.body);
      final forecastUrl = pointData['properties']?['forecast'];
      if (forecastUrl == null) throw 'Ponto NOAA sem URL de previsão.';

      final weatherResponse = await http.get(Uri.parse(forecastUrl), headers: {
        'User-Agent': 'PrepApp (contact@bunqrlabs.com)',
      });

      if (weatherResponse.statusCode == 200) {
        final data = json.decode(weatherResponse.body);
        setState(() {
          weatherData = data['properties'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao carregar os dados (Código: ${weatherResponse.statusCode})';
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

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Condições Climáticas - NOAA'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: weatherData?['periods']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final period = weatherData?['periods'][index];
                    final double tempFahrenheit = (period['temperature'] as num).toDouble();
                    final double tempCelsius = fahrenheitToCelsius(tempFahrenheit);

                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        title: Text(
                          _translatePeriod(period['name']),
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          _translateForecast(period['detailedForecast']),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          '${tempCelsius.toStringAsFixed(1)}°C',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _translatePeriod(String period) {
    final translations = {
      "Tonight": "Esta noite",
      "Monday": "Segunda-feira",
      "Tuesday": "Terça-feira",
      "Wednesday": "Quarta-feira",
      "Thursday": "Quinta-feira",
      "Friday": "Sexta-feira",
      "Saturday": "Sábado",
      "Sunday": "Domingo",
      "Today": "Hoje",
      "Tomorrow": "Amanhã",
    };

    return translations[period] ?? period;
  }

  String _translateForecast(String forecast) {
    return forecast
        .replaceAll("Showers", "Chuva")
        .replaceAll("Thunderstorms", "Tempestades")
        .replaceAll("Partly cloudy", "Parcialmente nublado")
        .replaceAll("Sunny", "Ensolarado")
        .replaceAll("Mostly cloudy", "Predominantemente nublado")
        .replaceAll("Cloudy", "Nublado")
        .replaceAll("Rain", "Chuva")
        .replaceAll("Snow", "Neve")
        .replaceAll("Windy", "Ventania");
  }
}
