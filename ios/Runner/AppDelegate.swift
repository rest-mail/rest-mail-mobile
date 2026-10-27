import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Before launch finishes, so a tap on a notification that launched the
    // app is not missed.
    UNUserNotificationCenter.current().delegate = PushChannel.shared
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    SecretClipboard.register(with: engineBridge.applicationRegistrar.messenger())
    PushChannel.shared.attach(to: engineBridge.applicationRegistrar.messenger())
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    PushChannel.shared.registered(deviceToken)
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    PushChannel.shared.failedToRegister()
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    PushChannel.shared.received(userInfo, completion: completionHandler)
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

/// New-mail pushes, for lib/push/push_service.dart.
///
/// A push from REST Mail carries no mail, only word that there is some to
/// fetch. The app fetches it over the API and posts the notification itself,
/// so nothing of a message passes through Apple. Without the aps-environment
/// entitlement there is no token, and the app carries on without push.
final class PushChannel: NSObject, UNUserNotificationCenterDelegate {
  static let shared = PushChannel()

  /// How long the app has to fetch a push's mail. iOS allows about 30
  /// seconds before it counts the app as having overrun.
  private static let fetchBudget: TimeInterval = 25

  /// How long a push waits for the app to start listening, after iOS
  /// launched it in the background, before a plain "New mail" is posted in
  /// its place.
  private static let startBudget: TimeInterval = 10

  private var channel: FlutterMethodChannel?

  /// The app has said it is listening. Until then pushes and taps wait.
  private var listening = false
  private var waitingPushes: [Push] = []
  private var waitingOpens: [[String: Any]] = []
  private var tokenRequests: [FlutterResult] = []

  /// A push and its completion handler, which is called once.
  private final class Push {
    let payload: [String: Any]
    private var completion: ((UIBackgroundFetchResult) -> Void)?

    init(_ payload: [String: Any], _ completion: @escaping (UIBackgroundFetchResult) -> Void) {
      self.payload = payload
      self.completion = completion
    }

    var isDone: Bool { completion == nil }

    func finish(_ result: UIBackgroundFetchResult) {
      completion?(result)
      completion = nil
    }
  }

  func attach(to messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "rest-mail/push", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel
    listening = false
  }

  // MARK: The app's calls

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    let arguments = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "permission":
      center.getNotificationSettings { settings in
        let status: String
        switch settings.authorizationStatus {
        case .notDetermined: status = "undetermined"
        case .denied: status = "denied"
        default: status = "granted"  // authorized, provisional, ephemeral
        }
        DispatchQueue.main.async { result(status) }
      }
    case "badgePermission":
      center.getNotificationSettings { settings in
        let status: String
        if settings.authorizationStatus == .notDetermined {
          status = "undetermined"
        } else {
          status = settings.badgeSetting == .enabled ? "granted" : "denied"
        }
        DispatchQueue.main.async { result(status) }
      }
    case "requestPermission":
      center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
        DispatchQueue.main.async { result(granted) }
      }
    case "token":
      tokenRequests.append(result)
      if tokenRequests.count == 1 {
        UIApplication.shared.registerForRemoteNotifications()
      }
    case "show":
      guard let id = arguments["id"] as? String else {
        result(FlutterError(code: "bad_arguments", message: "show needs an id", details: nil))
        return
      }
      let content = UNMutableNotificationContent()
      content.title = arguments["title"] as? String ?? ""
      content.body = arguments["body"] as? String ?? ""
      if let subtitle = arguments["subtitle"] as? String {
        content.subtitle = subtitle
      }
      content.sound = .default
      if let thread = arguments["thread"] as? String {
        content.threadIdentifier = thread
      }
      if let data = arguments["data"] as? [String: Any] {
        content.userInfo = data
      }
      if let badge = arguments["badge"] as? Int {
        content.badge = NSNumber(value: badge)
      }
      // The account's custom icon, as the notification's thumbnail. iOS keeps
      // the app icon itself fixed; this is the closest it allows.
      if let icon = arguments["icon"] as? String, !icon.isEmpty,
         FileManager.default.fileExists(atPath: icon),
         let attachment = try? UNNotificationAttachment(
           identifier: "account-icon",
           url: URL(fileURLWithPath: icon),
           options: nil) {
        content.attachments = [attachment]
      }
      center.add(UNNotificationRequest(identifier: id, content: content, trigger: nil)) { error in
        DispatchQueue.main.async { result(error == nil) }
      }
    case "setBadge":
      let count = arguments["count"] as? Int ?? 0
      if #available(iOS 16.0, *) {
        center.setBadgeCount(count) { _ in
          DispatchQueue.main.async { result(nil) }
        }
      } else {
        UIApplication.shared.applicationIconBadgeNumber = count
        result(nil)
      }
    case "ready":
      listening = true
      result(nil)
      let pushes = waitingPushes
      let opens = waitingOpens
      waitingPushes = []
      waitingOpens = []
      for push in pushes where !push.isDone {
        send(push)
      }
      for data in opens {
        channel?.invokeMethod("open", arguments: data)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: From iOS

  func registered(_ deviceToken: Data) {
    finishTokenRequests(deviceToken.map { String(format: "%02x", $0) }.joined())
  }

  /// No aps-environment entitlement in this build, or no way to reach
  /// Apple: no token, and nothing to tell the user about it.
  func failedToRegister() {
    finishTokenRequests(nil)
  }

  private func finishTokenRequests(_ token: String?) {
    let requests = tokenRequests
    tokenRequests = []
    for request in requests {
      request(token)
    }
  }

  func received(
    _ userInfo: [AnyHashable: Any],
    completion: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    let push = Push(Self.stringKeyed(userInfo), completion)
    DispatchQueue.main.asyncAfter(deadline: .now() + Self.fetchBudget) {
      push.finish(.failed)
    }
    if listening, channel != nil {
      send(push)
      return
    }
    // Launched in the background with no app running to fetch the mail:
    // give it a moment to start, then say only that there is new mail.
    waitingPushes.append(push)
    DispatchQueue.main.asyncAfter(deadline: .now() + Self.startBudget) { [weak self] in
      guard let self = self, !self.listening, !push.isDone else { return }
      self.waitingPushes.removeAll { $0 === push }
      self.postPlainNotice()
      push.finish(.noData)
    }
  }

  private func send(_ push: Push) {
    guard let channel = channel else { return }
    channel.invokeMethod("push", arguments: push.payload) { reply in
      push.finish((reply as? String) == "newData" ? .newData : .noData)
    }
  }

  /// "New mail", with nothing of it, for when the app could not fetch it.
  private func postPlainNotice() {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      guard settings.authorizationStatus == .authorized else { return }
      let content = UNMutableNotificationContent()
      content.title = "New mail"
      content.body = "Open REST Mail to read it."
      content.sound = .default
      center.add(
        UNNotificationRequest(identifier: "new-mail", content: content, trigger: nil))
    }
  }

  // MARK: UNUserNotificationCenterDelegate

  /// The app posts a notification only when it means it to be seen, the
  /// app open or not.
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .list, .sound])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let data = Self.stringKeyed(response.notification.request.content.userInfo)
    if listening, let channel = channel {
      channel.invokeMethod("open", arguments: data)
    } else {
      waitingOpens.append(data)
    }
    completionHandler()
  }

  private static func stringKeyed(_ dictionary: [AnyHashable: Any]) -> [String: Any] {
    var result: [String: Any] = [:]
    for (key, value) in dictionary {
      if let key = key as? String {
        result[key] = value
      }
    }
    return result
  }
}
