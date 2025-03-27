import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBOPr-e2uMd5dPR0BnF4LobzqGAP_fyFRs")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
