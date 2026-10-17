import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    SecretClipboard.register(with: engineBridge.applicationRegistrar.messenger())
  }
}

/// Copies a secret, such as a new app password, for lib/util/secret_clipboard.dart:
/// local only, so Universal Clipboard never carries it to the user's other
/// devices, and gone from the pasteboard by itself after the given seconds.
enum SecretClipboard {
  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "rest-mail/secret-clipboard", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "copy",
        let arguments = call.arguments as? [String: Any],
        let text = arguments["text"] as? String,
        let seconds = arguments["seconds"] as? Int
      else {
        result(FlutterMethodNotImplemented)
        return
      }
      UIPasteboard.general.setItems(
        [["public.utf8-plain-text": text]],
        options: [
          .localOnly: true,
          .expirationDate: Date().addingTimeInterval(TimeInterval(seconds)),
        ])
      // It expires, and stays on this device.
      result(true)
    }
  }
}
