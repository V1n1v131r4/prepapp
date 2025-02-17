import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  final Set<Marker> _markers = {};
  bool _loading = true;
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
      _addNearbyMarkers();
    });
  }

  void _addNearbyMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("hospital"),
          position: LatLng(_currentPosition.latitude + 0.01, _currentPosition.longitude),
          infoWindow: const InfoWindow(title: "Hospital Próximo"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId("gas_station"),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude + 0.01),
          infoWindow: const InfoWindow(title: "Posto de Gasolina"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId("alternative_route"),
          position: LatLng(_currentPosition.latitude - 0.01, _currentPosition.longitude - 0.01),
          infoWindow: const InfoWindow(title: "Via Alternativa"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  Future<void> _saveOfflineMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("lat", _currentPosition.latitude);
    await prefs.setDouble("lng", _currentPosition.longitude);
    setState(() {
      _offlineMode = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mapa salvo para uso offline!")),
    );
  }

  Future<void> _loadOfflineMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble("lat");
    double? lng = prefs.getDouble("lng");

    if (lat != null && lng != null) {
      setState(() {
        _currentPosition = LatLng(lat, lng);
        _offlineMode = true;
      });
    }
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
            tooltip: "Salvar Mapa Offline",
          ),
          IconButton(
            icon: const Icon(Icons.wifi_off),
            onPressed: _loadOfflineMap,
            tooltip: "Carregar Mapa Offline",
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15.0,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
