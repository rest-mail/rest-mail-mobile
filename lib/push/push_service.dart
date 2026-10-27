import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';

/// Whether the user has let the app show notifications.
enum NotificationPermission {
  /// Not asked yet: asking shows the system's prompt.
  undetermined,

  /// Turned off, in the prompt or in the phone's Settings. Only Settings can
  /// turn it back on.
  denied,

  granted,
}

/// What the app posts once it has fetched the mail a push told it about.
@immutable
class LocalNotification {
  const LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    this.subtitle,
    this.thread,
    this.data = const {},
    this.badge,
    this.icon,
  });

  /// One per message, so the same one posted twice shows once.
  final String id;
  final String title;

  /// Which mailbox, when the phone has more than one.
  final String? subtitle;
  final String body;

  /// Groups an account's notifications together.
  final String? thread;

  /// Handed back by [PushService.onOpen] when the notification is tapped.
  final Map<String, String> data;
  final int? badge;

  /// The account's custom icon on disk, when it has one. iOS shows it as the
  /// notification's attachment; the app icon itself cannot be replaced.
  final String? icon;
}

/// The phone's push service: its token, the permission to show
/// notifications, the pushes that arrive and the notifications the app
/// posts.
abstract interface class PushService {
  /// Which service the token is for, [PushPlatform.apns], or null where the
  /// app has no push: Android for now, sample mode and tests.
  String? get platform;

  /// For APNs, which of Apple's two services the token belongs to.
  String? get environment;

  /// The bundle id a push has to be addressed to.
  String? get appId;

  Future<NotificationPermission> permission();

  /// The actual badge setting, which can differ from alert authorization.
  Future<NotificationPermission> badgePermission();

  /// Shows the system's prompt, the first time; after that it answers with
  /// what the user chose. True when notifications may be shown.
  Future<bool> requestPermission();

  /// This install's token, or null when the phone can't have one: a build
  /// without the push entitlement, or no way to reach Apple.
  Future<String?> token();

  /// Called for each push with its payload. The future completes once the
  /// app is done with it, true if there was new mail. iOS gives it about
  /// 30 seconds.
  set onPush(Future<bool> Function(Map<String, Object?> payload)? handler);

  /// Called when the user taps a notification the app posted, with its
  /// [LocalNotification.data].
  set onOpen(void Function(Map<String, String> data)? handler);

  /// Tells the platform the app is listening, so pushes and taps that came
  /// while it was starting are handed over.
  Future<void> listen();

  Future<void> show(LocalNotification notification);

  /// The number on the app's icon; 0 takes it off.
  Future<void> setBadge(int count);
}

/// No push: what every platform but iOS has for now, and sample mode. The
/// app behaves as it did before there was push.
class NoPushService implements PushService {
  const NoPushService();

  @override
  String? get platform => null;

  @override
  String? get environment => null;

  @override
  String? get appId => null;

  @override
  Future<NotificationPermission> permission() async =>
      NotificationPermission.denied;

  @override
  Future<NotificationPermission> badgePermission() async =>
      NotificationPermission.denied;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> token() async => null;

  @override
  set onPush(Future<bool> Function(Map<String, Object?> payload)? handler) {}

  @override
  set onOpen(void Function(Map<String, String> data)? handler) {}

  @override
  Future<void> listen() async {}

  @override
  Future<void> show(LocalNotification notification) async {}

  @override
  Future<void> setBadge(int count) async {}
}

/// APNs straight from iOS, through the `rest-mail/push` channel in
/// ios/Runner/AppDelegate.swift. No Firebase: Apple's own service is all an
/// iPhone needs.
class ApplePushService implements PushService {
  ApplePushService() {
    _channel.setMethodCallHandler(_fromPlatform);
  }

  static const _channel = MethodChannel('rest-mail/push');

  /// The bundle id in ios/Runner.xcodeproj.
  static const bundleId = 'com.antimatterstudios.restmail';

  /// How long to wait for Apple to hand out a token before taking it that
  /// there is none.
  static const _tokenWait = Duration(seconds: 20);

  /// [ApplePushService] on iOS, [NoPushService] anywhere else.
  static PushService forThisPlatform() =>
      !kIsWeb && Platform.isIOS ? ApplePushService() : const NoPushService();

  Future<bool> Function(Map<String, Object?> payload)? _onPush;
  void Function(Map<String, String> data)? _onOpen;

  @override
  String get platform => PushPlatform.apns;

  /// Release builds are the App Store's and TestFlight's, signed for
  /// production; anything run from Xcode gets sandbox tokens.
  @override
  String get environment =>
      kReleaseMode ? ApnsEnvironment.production : ApnsEnvironment.sandbox;

  @override
  String get appId => bundleId;

  @override
  set onPush(Future<bool> Function(Map<String, Object?> payload)? handler) =>
      _onPush = handler;

  @override
  set onOpen(void Function(Map<String, String> data)? handler) =>
      _onOpen = handler;

  @override
  Future<NotificationPermission> permission() async =>
      switch (await _call<String>('permission')) {
        'granted' => NotificationPermission.granted,
        'undetermined' => NotificationPermission.undetermined,
        _ => NotificationPermission.denied,
      };

  @override
  Future<NotificationPermission> badgePermission() async =>
      switch (await _call<String>('badgePermission')) {
        'granted' => NotificationPermission.granted,
        'undetermined' => NotificationPermission.undetermined,
        _ => NotificationPermission.denied,
      };

  @override
  Future<bool> requestPermission() async =>
      await _call<bool>('requestPermission') ?? false;

  @override
  Future<String?> token() async {
    try {
      final token = await _call<String>('token').timeout(_tokenWait);
      return token == null || token.isEmpty ? null : token;
    } on TimeoutException {
      return null;
    }
  }

  @override
  Future<void> listen() => _call<void>('ready');

  @override
  Future<void> show(LocalNotification n) => _call<void>('show', {
    'id': n.id,
    'title': n.title,
    'subtitle': ?n.subtitle,
    'body': n.body,
    'thread': ?n.thread,
    'data': n.data,
    'badge': ?n.badge,
    'icon': ?n.icon,
  });

  @override
  Future<void> setBadge(int count) => _call<void>('setBadge', {'count': count});

  /// A platform call, or null if the platform has no channel, so a build
  /// without it carries on without push.
  Future<T?> _call<T>(String method, [Object? arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<Object?> _fromPlatform(MethodCall call) async {
    final arguments = call.arguments;
    final data = arguments is Map
        ? {
            for (final MapEntry(:key, :value) in arguments.entries)
              '$key': value,
          }
        : <String, Object?>{};
    switch (call.method) {
      case 'push':
        final handler = _onPush;
        if (handler == null) return 'noData';
        try {
          return await handler(data) ? 'newData' : 'noData';
        } on Object {
          return 'failed';
        }
      case 'open':
        _onOpen?.call({
          for (final MapEntry(:key, :value) in data.entries)
            if (value is String) key: value,
        });
        return null;
    }
    throw MissingPluginException('No method ${call.method} on rest-mail/push');
  }
}
