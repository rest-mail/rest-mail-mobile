import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/push/push_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('rest-mail/push');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  for (final entry in {
    'granted': NotificationPermission.granted,
    'denied': NotificationPermission.denied,
    'undetermined': NotificationPermission.undetermined,
    'unknown': NotificationPermission.denied,
  }.entries) {
    test(
      'badge permission reads its own platform setting: ${entry.key}',
      () async {
        final calls = <String>[];
        messenger.setMockMethodCallHandler(channel, (call) async {
          calls.add(call.method);
          return call.method == 'badgePermission' ? entry.key : 'granted';
        });
        expect(await ApplePushService().badgePermission(), entry.value);
        expect(calls, ['badgePermission']);
      },
    );
  }

  test('a missing or failed badge channel fails closed', () async {
    final service = ApplePushService();
    expect(await service.badgePermission(), NotificationPermission.denied);
    messenger.setMockMethodCallHandler(
      channel,
      (_) async => throw PlatformException(code: 'unavailable'),
    );
    expect(await service.badgePermission(), NotificationPermission.denied);
  });

  test('unsupported platforms cannot request permission or badges', () async {
    const service = NoPushService();
    expect(service.platform, isNull);
    expect(await service.badgePermission(), NotificationPermission.denied);
    expect(await service.requestPermission(), isFalse);
  });
}
