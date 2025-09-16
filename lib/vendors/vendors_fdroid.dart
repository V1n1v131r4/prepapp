import 'vendors.dart';

/// Implementação F-Droid: não inicializa nenhum SDK proprietário.
class VendorsFdroid implements Vendors {
  const VendorsFdroid();

  @override
  Future<void> init() async {
    // no-op
  }

  @override
  Future<void> dispose() async {
    // no-op
  }
}
