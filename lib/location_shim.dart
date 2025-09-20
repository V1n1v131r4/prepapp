// lib/location_shim.dart
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationData {
  final double? latitude;
  final double? longitude;
  final double? accuracy;

  LocationData({this.latitude, this.longitude, this.accuracy});
}

class AppLocation {
  static const MethodChannel _ch = MethodChannel('app.location');

  Future<LocationData?> getCurrentLocation() async {
    final status = await Permission.location.request();
    if (!status.isGranted) return null;

    try {
      final map = await _ch.invokeMapMethod<String, dynamic>('getCurrentLocation');
      if (map == null) return null;
      return LocationData(
        latitude: (map['latitude'] as num?)?.toDouble(),
        longitude: (map['longitude'] as num?)?.toDouble(),
        accuracy: (map['accuracy'] as num?)?.toDouble(),
      );
    } catch (_) {
      return null;
    }
  }

  // Mantém assinatura compatível com o que você já usava (se precisar no futuro).
  Stream<LocationData> onLocationChanged() {
    // Implementar depois se quiser stream; por ora, retorno um stream vazio.
    return const Stream<LocationData>.empty();
  }
}
