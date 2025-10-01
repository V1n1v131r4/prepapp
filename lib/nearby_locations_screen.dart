import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// import relativo pro shim
import '../location_shim.dart';

class NearbyLocationsScreen extends StatefulWidget {
  const NearbyLocationsScreen({super.key});

  @override
  State<NearbyLocationsScreen> createState() => _NearbyLocationsScreenState();
}

class _NearbyLocationsScreenState extends State<NearbyLocationsScreen> {
  final AppLocation _appLoc = AppLocation();

  double? _lat;
  double? _lng;

  String _locationStatus = "Obtendo localização...";
  bool _loadingPlaces = false;

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
    setState(() {
      _locationStatus = "Obtendo localização...";
    });

    try {
      final data = await _appLoc.getCurrentLocation();
      if (data?.latitude == null || data?.longitude == null) {
        setState(() => _locationStatus = "Serviço de localização indisponível");
        return;
      }
      setState(() {
        _lat = data!.latitude!;
        _lng = data.longitude!;
        _locationStatus = "Localização obtida!";
      });
      _fetchNearbyPlaces();
    } catch (e) {
      setState(() => _locationStatus = "Erro ao obter localização: $e");
    }
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_lat == null || _lng == null) return;

    setState(() => _loadingPlaces = true);

    try {
      // Raio em metros
      const radius = 5000;

      _hospitals      = await _overpassAmenity(_lat!, _lng!, radius, "hospital");
      _gasStations    = await _overpassAmenity(_lat!, _lng!, radius, "fuel");
      _markets        = await _overpassAmenity(_lat!, _lng!, radius, "supermarket");
      _hardwareStores = await _overpassAmenity(_lat!, _lng!, radius, "doityourself"); // lojas de material/DIY
      _nationalParks  = await _overpassParks(_lat!, _lng!, radius);
      _waterSources   = await _overpassWater(_lat!, _lng!, radius);
    } catch (e) {
      setState(() => _locationStatus = "Erro ao obter locais: $e");
    }

    setState(() => _loadingPlaces = false);
  }

  Future<List<Map<String, dynamic>>> _overpassAmenity(
    double lat, double lng, int radius, String amenity,
  ) async {
    final query = """
[out:json][timeout:25];
(
  node["amenity"="$amenity"](around:$radius,$lat,$lng);
  way["amenity"="$amenity"](around:$radius,$lat,$lng);
  relation["amenity"="$amenity"](around:$radius,$lat,$lng);
);
out center tags;
""";
    return _overpassQuery(query);
  }

  Future<List<Map<String, dynamic>>> _overpassParks(
    double lat, double lng, int radius,
  ) async {
    // parques podem estar como leisure=park ou boundary=protected_area + protect_class
    final query = """
[out:json][timeout:25];
(
  node["leisure"="park"](around:$radius,$lat,$lng);
  way["leisure"="park"](around:$radius,$lat,$lng);
  relation["leisure"="park"](around:$radius,$lat,$lng);
  way["boundary"="protected_area"](around:$radius,$lat,$lng);
  relation["boundary"="protected_area"](around:$radius,$lat,$lng);
);
out center tags;
""";
    return _overpassQuery(query);
  }

  Future<List<Map<String, dynamic>>> _overpassWater(
    double lat, double lng, int radius,
  ) async {
    // fontes d’água/natural: natural=water | water=lake/river/pond
    final query = """
[out:json][timeout:25];
(
  node["natural"="water"](around:$radius,$lat,$lng);
  way["natural"="water"](around:$radius,$lat,$lng);
  relation["natural"="water"](around:$radius,$lat,$lng);

  way["water"~"^(lake|river|pond)\$"](around:$radius,$lat,$lng);
  relation["water"~"^(lake|river|pond)\$"](around:$radius,$lat,$lng);
);
out center tags;
""";
    return _overpassQuery(query);
  }

  Future<List<Map<String, dynamic>>> _overpassQuery(String overpassQL) async {
    final uri = Uri.parse("https://overpass-api.de/api/interpreter");
    final resp = await http.post(uri, body: {"data": overpassQL});
    if (resp.statusCode != 200) {
      return [];
    }
    final jsonMap = json.decode(resp.body);
    final elements = (jsonMap["elements"] as List?) ?? [];

    return elements.map<Map<String, dynamic>>((e) {
      final tags = (e["tags"] as Map?) ?? {};
      final name = (tags["name"] ?? "Sem nome").toString();
      final addrParts = [
        tags["addr:street"],
        tags["addr:housenumber"],
        tags["addr:city"],
      ].where((x) => x != null).join(", ");
      final lat = (e["lat"] ?? e["center"]?["lat"])?.toDouble();
      final lon = (e["lon"] ?? e["center"]?["lon"])?.toDouble();
      return {
        "name": name,
        "address": addrParts.isEmpty ? "Endereço não disponível" : addrParts,
        "lat": lat,
        "lng": lon,
      };
    }).toList();
  }

  // --- abrir no mapa com pin
  Future<void> _openInMaps(Map<String, dynamic> place) async {
    final lat = place["lat"] as double?;
    final lng = place["lng"] as double?;
    final name = (place["name"] as String?) ?? "Local";
    if (lat == null || lng == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Coordenadas indisponíveis para este local.")),
        );
      }
      return;
    }

    // Tenta esquema geo: (abre Google Maps / app de mapas nativo)
    final geo = Uri.parse("geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(name)})");

    // Fallback: URL do Google Maps no browser
    final web = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=",
    );

    if (await canLaunchUrl(geo)) {
      await launchUrl(geo, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(web, mode: LaunchMode.externalApplication);
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
      body: (_lat == null || _lng == null)
          ? Center(
              child: Column(
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
              ),
            )
          : _loadingPlaces
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        "Aguarde, estamos buscando…",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildCategory("Pontos de Água", Icons.water, Colors.blue, _waterSources),
                    _buildCategory("Parques / Áreas Protegidas", Icons.park, Colors.green, _nationalParks),
                    _buildCategory("Hospitais", Icons.local_hospital, Colors.red, _hospitals),
                    _buildCategory("Postos de Gasolina", Icons.local_gas_station, Colors.orange, _gasStations),
                    _buildCategory("Mercados", Icons.store, Colors.purple, _markets),
                    _buildCategory("Lojas de Ferramenta", Icons.build, Colors.brown, _hardwareStores),
                  ],
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
            ? const [
                ListTile(
                  title: Text("Nenhum local encontrado", style: TextStyle(color: Colors.grey)),
                ),
              ]
            : items.map((place) {
                return ListTile(
                  onTap: () => _openInMaps(place),
                  title: Text(place["name"], style: const TextStyle(color: Colors.white)),
                  subtitle: Text(place["address"], style: const TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.directions, color: Colors.lightBlueAccent),
                    tooltip: "Abrir no mapa",
                    onPressed: () => _openInMaps(place),
                  ),
                );
              }).toList(),
      ),
    );
  }
}
