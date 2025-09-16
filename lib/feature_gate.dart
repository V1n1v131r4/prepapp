/// Nesta branch (fdroid), deixamos sempre `true`.
/// Se quiser reaproveitar em outra branch, compile com:
///   --dart-define=FDROID=true/false
const bool kIsFdroid = bool.fromEnvironment('FDROID', defaultValue: true);
