import 'package:restmail/push/push_service.dart';
import 'package:restmail_api/restmail_api.dart';

/// iOS's side of push, for tests: a token if the build had the entitlement,
/// the user's answer to the prompt, and the notifications and badge the app
/// set.
class FakePushService implements PushService {
  FakePushService({
    this.deviceToken = _token,
    this.answer = true,
    this.permissionState = NotificationPermission.undetermined,
  });

  static const _token =
      'a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90';

  /// Null for a build without the push entitlement.
  String? deviceToken;

  /// What the user taps in iOS's prompt.
  bool answer;

  /// What the user has let the app do so far.
  NotificationPermission permissionState;

  /// How many times iOS's prompt came up.
  var prompts = 0;
  var tokenRequests = 0;
  var listening = false;
  final shown = <LocalNotification>[];
  final badges = <int>[];

  Future<bool> Function(Map<String, Object?> payload)? _onPush;
  void Function(Map<String, String> data)? _onOpen;

  /// A push arriving, as iOS hands it to the app.
  Future<bool> deliver(Map<String, Object?> payload) =>
      _onPush?.call(payload) ?? Future.value(false);

  /// The user tapping a notification the app posted.
  void tap(LocalNotification notification) => _onOpen?.call(notification.data);

  @override
  String get platform => PushPlatform.apns;

  @override
  String get environment => ApnsEnvironment.sandbox;

  @override
  String get appId => 'com.antimatterstudios.restmail';

  @override
  Future<NotificationPermission> permission() async => permissionState;

  @override
  Future<bool> requestPermission() async {
    if (permissionState == NotificationPermission.undetermined) {
      prompts++;
      permissionState = answer
          ? NotificationPermission.granted
          : NotificationPermission.denied;
    }
    return permissionState == NotificationPermission.granted;
  }

  @override
  Future<String?> token() async {
    tokenRequests++;
    return deviceToken;
  }

  @override
  set onPush(Future<bool> Function(Map<String, Object?> payload)? handler) =>
      _onPush = handler;

  @override
  set onOpen(void Function(Map<String, String> data)? handler) =>
      _onOpen = handler;

  @override
  Future<void> listen() async => listening = true;

  @override
  Future<void> show(LocalNotification notification) async =>
      shown.add(notification);

  @override
  Future<void> setBadge(int count) async => badges.add(count);
}
