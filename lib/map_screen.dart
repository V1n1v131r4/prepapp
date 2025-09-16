import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(0, 0);
  final List<Marker> _markers = [];
  bool _loading = true;
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _restoreLastCoords().then((_) => _getCurrentLocation());
  }

  Future<void> _restoreLastCoords() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble("lat");
    final lng = prefs.getDouble("lng");
    if (lat != null && lng != null) {
      _currentPosition = LatLng(lat, lng);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _finishLoadingWithMessage('Serviço de localização desativado.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _finishLoadingWithMessage('Permissão de localização negada.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _finishLoadingWithMessage('Permissão negada permanentemente.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _addNearbyMarkers();

      setState(() => _loading = false);

      // garante que o FlutterMap já montou antes de mover a camera
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_currentPosition, 15.0);
      });
    } catch (e) {
      _finishLoadingWithMessage('Falha ao obter localização: $e');
    }
  }

  void _finishLoadingWithMessage(String msg) {
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _addNearbyMarkers() {
    _markers
      ..clear()
      ..addAll([
        Marker(
          point: LatLng(_currentPosition.latitude + 0.01, _currentPosition.longitude),
          width: 40,
          height: 40,
          child: const _MarkerDot(color: Colors.red, label: 'Hospital'),
        ),
        Marker(
          point: LatLng(_currentPosition.latitude, _currentPosition.longitude + 0.01),
          width: 40,
          height: 40,
          child: const _MarkerDot(color: Colors.blue, label: 'Posto'),
        ),
        Marker(
          point: LatLng(_currentPosition.latitude - 0.01, _currentPosition.longitude - 0.01),
          width: 40,
          height: 40,
          child: const _MarkerDot(color: Colors.green, label: 'Rota'),
        ),
      ]);
  }

  Future<void> _saveOfflineMap() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("lat", _currentPosition.latitude);
    await prefs.setDouble("lng", _currentPosition.longitude);
    setState(() => _offlineMode = true);
    _showSnack("Coordenadas salvas para uso offline.");
  }

  Future<void> _loadOfflineMap() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble("lat");
    final lng = prefs.getDouble("lng");

    if (lat != null && lng != null) {
      setState(() {
        _currentPosition = LatLng(lat, lng);
        _offlineMode = true;
        _addNearbyMarkers();
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_currentPosition, 15.0);
      });
    } else {
      _showSnack("Nenhuma coordenada offline salva.");
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mapa Interativo'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _saveOfflineMap,
            tooltip: "Salvar Mapa Offline (coordenadas)",
          ),
          IconButton(
            icon: const Icon(Icons.wifi_off),
            onPressed: _loadOfflineMap,
            tooltip: "Carregar Mapa Offline (coordenadas)",
          ),
          IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: () {
              // re-centra se já temos posição
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mapController.move(_currentPosition, 15.0);
              });
            },
            tooltip: "Centralizar",
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition,
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.bunqr.prepapp.fdroid",
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        point: _currentPosition,
                        width: 52,
                        height: 52,
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: const [
                            Icon(Icons.location_pin, size: 42, color: Colors.orange),
                            SizedBox(height: 2),
                            Text("Você", style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                      ..._markers,
                    ]),
                  ],
                ),
                if (_offlineMode)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Modo offline (coordenadas salvas). Para tiles offline reais, habilitar cache em futura versão.",
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _MarkerDot extends StatelessWidget {
  final Color color;
  final String label;
  const _MarkerDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.place, color: color, size: 32),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
