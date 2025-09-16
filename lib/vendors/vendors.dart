abstract class Vendors {
  /// Inicializações de SDKs/telemetria/push/maps/etc.
  Future<void> init();

  /// Chamada quando o app fecha ou precisa liberar recursos.
  Future<void> dispose();
}
