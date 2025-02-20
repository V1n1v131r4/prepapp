import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyLocationsScreen extends StatefulWidget {
  @override
  _NearbyLocationsScreenState createState() => _NearbyLocationsScreenState();
}

class _NearbyLocationsScreenState extends State<NearbyLocationsScreen> {
  Position? _currentPosition;
  String _locationStatus = "Obtendo localização...";
  bool _loadingPlaces = false;
  final String _googleApiKey = "AIzaSyCT1Uf1shnpAG4e_qYnAMP8fdmHqCH4me4"; // Armazene isso com segurança
  List<Map<String, dynamic>> _waterSources = [];
  List<Map<String, dynamic>> _nationalParks = [];
  List<Map<String, dynamic>> _hospitals = [];
  List<Map<String, dynamic>> _gasStations = [];
  List<Map<String, dynamic>> _markets = [];
  List<Map<String, dynamic>> _hardwareStores = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationStatus = "Serviço de localização desativado");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationStatus = "Permissão negada");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationStatus = "Permissão negada permanentemente");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _locationStatus = "Localização obtida!";
      });

      _fetchNearbyPlaces();
    } catch (e) {
      setState(() => _locationStatus = "Erro ao obter localização: $e");
    }
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_currentPosition == null) return;

    setState(() => _loadingPlaces = true);

    double lat = _currentPosition!.latitude;
    double lng = _currentPosition!.longitude;

    try {
      _hospitals = await _getPlacesNearby(lat, lng, "hospital");
      _nationalParks = await _getPlacesNearby(lat, lng, "park");
      _waterSources = await _getPlacesNearby(lat, lng, "natural_feature");
      _gasStations = await _getPlacesNearby(lat, lng, "gas_station");
      _markets = await _getPlacesNearby(lat, lng, "supermarket");
      _hardwareStores = await _getPlacesNearby(lat, lng, "hardware_store");
    } catch (e) {
      setState(() => _locationStatus = "Erro ao obter locais: $e");
    }

    setState(() => _loadingPlaces = false);
  }

  Future<List<Map<String, dynamic>>> _getPlacesNearby(double lat, double lng, String type) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=5000&type=$type&key=$_googleApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          return (data["results"] as List)
              .map((place) => {
                    "name": place["name"],
                    "address": place["vicinity"] ?? "Endereço não disponível",
                  })
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar $type: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Locais Próximos"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _currentPosition == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_locationStatus, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    child: const Text("Atualizar Localização"),
                  ),
                ],
              )
            : _loadingPlaces
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildCategory("Pontos de Água", Icons.water, Colors.blue, _waterSources),
                      _buildCategory("Parques Nacionais", Icons.park, Colors.green, _nationalParks),
                      _buildCategory("Hospitais", Icons.local_hospital, Colors.red, _hospitals),
                      _buildCategory("Postos de Gasolina", Icons.local_gas_station, Colors.orange, _gasStations),
                      _buildCategory("Mercados", Icons.store, Colors.purple, _markets),
                      _buildCategory("Lojas de Ferramenta", Icons.build, Colors.brown, _hardwareStores),
                    ],
                  ),
      ),
    );
  }

  Widget _buildCategory(String title, IconData icon, Color color, List<Map<String, dynamic>> items) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: items.isEmpty
            ? [
                const ListTile(
                  title: Text("Nenhum local encontrado", style: TextStyle(color: Colors.grey)),
                ),
              ]
            : items.map((place) {
                return ListTile(
                  title: Text(place["name"], style: const TextStyle(color: Colors.white)),
                  subtitle: Text(place["address"], style: const TextStyle(color: Colors.grey)),
                );
              }).toList(),
      ),
    );
  }
}
