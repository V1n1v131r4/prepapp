import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(-23.0, -45.5); // fallback (ex.: Vale do Paraíba)
  final List<Marker> _markers = [];
  bool _loading = true;
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _finishLoading();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _finishLoading();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _finishLoading();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _addNearbyMarkers();
    } catch (_) {
      // mantém fallback
    } finally {
      _finishLoading();
      // centraliza no ponto atual
      _mapController.move(_currentPosition, 13);
    }
  }

  void _finishLoading() {
    if (mounted) {
      setState(() => _loading = false);
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
      _mapController.move(_currentPosition, 13);
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
      // OpenStreetMap padrão — 100% FLOSS
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.bunqr.prepapp.fdroid',
      // OBS: isso não baixa tiles offline. Para cache/tiles offline reais, usar plugins específicos.
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
              ),
              children: [
                tiles,
                MarkerLayer(markers: _markers),
              ],
            ),
      floatingActionButton: !_loading
          ? FloatingActionButton(
              onPressed: () => _mapController.move(_currentPosition, 13),
              tooltip: 'Centralizar',
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }
}
