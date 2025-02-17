import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyLocationsScreen extends StatefulWidget {
  const NearbyLocationsScreen({super.key});

  @override
  _NearbyLocationsScreenState createState() => _NearbyLocationsScreenState();
}

class _NearbyLocationsScreenState extends State<NearbyLocationsScreen> {
  Position? _currentPosition;
  String _locationStatus = "Obtendo localização...";
  final String _googleApiKey = "AIzaSyCT1Uf1shnpAG4e_qYnAMP8fdmHqCH4me4"; // Substitua pela sua chave da API
  List<Map<String, dynamic>> _waterSources = [];
  List<Map<String, dynamic>> _nationalParks = [];
  List<Map<String, dynamic>> _hospitals = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus = "Serviço de localização desativado";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = "Permissão negada";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus = "Permissão negada permanentemente";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      _locationStatus = "Localização obtida!";
    });

    _fetchNearbyPlaces();
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_currentPosition == null) return;

    double lat = _currentPosition!.latitude;
    double lng = _currentPosition!.longitude;

    // Buscar hospitais
    _hospitals = await _getPlacesNearby(lat, lng, "hospital");
    // Buscar parques nacionais
    _nationalParks = await _getPlacesNearby(lat, lng, "park");
    // Buscar fontes de água (lagos, rios)
    _waterSources = await _getPlacesNearby(lat, lng, "natural_feature");

    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _getPlacesNearby(double lat, double lng, String type) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=5000&type=$type&key=$_googleApiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data["results"] as List)
          .map((place) => {
                "name": place["name"],
                "address": place["vicinity"] ?? "Endereço não disponível",
              })
          .toList();
    } else {
      return [];
    }
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
                  Text(
                    _locationStatus,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    child: const Text("Atualizar Localização"),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCategory("Pontos de Água", Icons.water, Colors.blue, _waterSources),
                  _buildCategory("Parques Nacionais", Icons.park, Colors.green, _nationalParks),
                  _buildCategory("Hospitais", Icons.local_hospital, Colors.red, _hospitals),
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
