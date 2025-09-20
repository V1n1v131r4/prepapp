import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

// use import relativo pro shim
import '../location_shim.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(-23.0, -45.5); // fallback
  final List<Marker> _markers = [];
  bool _loading = true;
  bool _offlineMode = false;
  bool _mapReady = false;

  final AppLocation _appLoc = AppLocation();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final data = await _appLoc.getCurrentLocation();
      final lat = data?.latitude;
      final lng = data?.longitude;
      if (lat != null && lng != null) {
        _currentPosition = LatLng(lat, lng);
        _addNearbyMarkers();
      }
    } catch (_) {
      // mantém fallback silenciosamente
    } finally {
      _finishLoading();
      if (_markers.isEmpty) _addNearbyMarkers(); // garante pointer no fallback
      _maybeMoveToCurrent();
    }
  }

  void _finishLoading() {
    if (mounted) setState(() => _loading = false);
  }

  void _maybeMoveToCurrent() {
    if (_mapReady) {
      _mapController.move(_currentPosition, 13);
    }
  }

  void _addNearbyMarkers() {
    _markers
      ..clear()
      ..addAll([
        // 🔵 Marker da posição atual
        Marker(
          point: _currentPosition,
          width: 46,
          height: 46,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyanAccent.withOpacity(0.25),
              border: Border.all(color: Colors.cyanAccent, width: 2),
            ),
            child: const Icon(Icons.my_location, size: 20, color: Colors.cyanAccent),
          ),
        ),
        // Exemplos de marcadores próximos
        Marker(
          point: LatLng(_currentPosition.latitude + 0.01, _currentPosition.longitude),
          width: 40,
          height: 40,
          child: const Icon(Icons.local_hospital, size: 32, color: Colors.redAccent),
        ),
        Marker(
          point: LatLng(_currentPosition.latitude, _currentPosition.longitude + 0.01),
          width: 40,
          height: 40,
          child: const Icon(Icons.local_gas_station, size: 32, color: Colors.blueAccent),
        ),
        Marker(
          point: LatLng(_currentPosition.latitude - 0.01, _currentPosition.longitude - 0.01),
          width: 40,
          height: 40,
          child: const Icon(Icons.alt_route, size: 32, color: Colors.greenAccent),
        ),
      ]);

    if (mounted) setState(() {});
  }

  Future<void> _saveOfflineLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("lat", _currentPosition.latitude);
    await prefs.setDouble("lng", _currentPosition.longitude);
    setState(() => _offlineMode = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Localização salva para uso offline.")),
      );
    }
  }

  Future<void> _loadOfflineLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble("lat");
    final lng = prefs.getDouble("lng");
    if (lat != null && lng != null) {
      setState(() {
        _currentPosition = LatLng(lat, lng);
        _offlineMode = true;
      });
      _addNearbyMarkers();
      _maybeMoveToCurrent();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhuma localização offline salva.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiles = TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.bunqr.prepapp.fdroid',
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mapa Interativo'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _saveOfflineLocation,
            tooltip: "Salvar Localização Offline",
          ),
          IconButton(
            icon: const Icon(Icons.wifi_off),
            onPressed: _loadOfflineLocation,
            tooltip: "Carregar Localização Offline",
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 13,
                onMapReady: () {
                  _mapReady = true;
                  _maybeMoveToCurrent();
                },
              ),
              children: [
                tiles,
                MarkerLayer(markers: _markers),
              ],
            ),
      floatingActionButton: !_loading
          ? FloatingActionButton(
              onPressed: _maybeMoveToCurrent,
              tooltip: 'Centralizar',
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }
}
