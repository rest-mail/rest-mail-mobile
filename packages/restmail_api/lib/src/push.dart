/// The services a REST Mail server can push through.
abstract final class PushPlatform {
  /// Apple Push Notification service: iPhone and iPad.
  static const apns = 'apns';

  /// Firebase Cloud Messaging: Android.
  static const fcm = 'fcm';
}

/// Which APNs a token belongs to. A build signed for the App Store or
/// TestFlight gets production tokens; one run from Xcode gets sandbox ones,
/// and the two don't mix.
abstract final class ApnsEnvironment {
  static const production = 'production';
  static const sandbox = 'sandbox';
}

/// A phone registered for push by a session, as `GET /api/v1/devices` lists
/// it. The server never answers with the token itself.
class PushDevice {
  const PushDevice({
    required this.id,
    required this.platform,
    this.environment,
    this.createdAt,
  });

  factory PushDevice.fromJson(Map<String, dynamic> json) => PushDevice(
    // An id is opaque: a number on one server, a string on another.
    id: '${json['id']}',
    platform: json['platform'] as String? ?? '',
    environment: json['environment'] as String?,
    createdAt: switch (json['created_at']) {
      final String at when at.isNotEmpty => DateTime.tryParse(at),
      _ => null,
    },
  );

  final String id;

  /// [PushPlatform.apns] or [PushPlatform.fcm].
  final String platform;

  /// For APNs, [ApnsEnvironment.production] or [ApnsEnvironment.sandbox].
  final String? environment;
  final DateTime? createdAt;
}

/// What `GET /api/v1/devices` reports: the services the server is set up to
/// push through, and the devices this session has registered.
class PushRegistrations {
  const PushRegistrations({required this.platforms, required this.devices});

  factory PushRegistrations.fromJson(Map<String, dynamic> json) =>
      PushRegistrations(
        platforms: {
          for (final p in json['platforms'] as List? ?? const [])
            if (p is String) p,
        },
        devices: [
          for (final d in json['devices'] as List? ?? const [])
            PushDevice.fromJson(d as Map<String, dynamic>),
        ],
      );

  /// Empty when the server has the routes but no credentials for any
  /// service: push is off there.
  final Set<String> platforms;
  final List<PushDevice> devices;

  bool supports(String platform) => platforms.contains(platform);
}
