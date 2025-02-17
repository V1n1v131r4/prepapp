import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCT1Uf1shnpAG4e_qYnAMP8fdmHqCH4me4") // Substitua pela sua chave do Google Maps
    GeneratedPluginRegistrant.register(with: self) // Registra todos os plugins automaticamente
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
