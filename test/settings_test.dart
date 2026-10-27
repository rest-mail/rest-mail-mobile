import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/settings.dart';

void main() {
  test('badge defaults migrate old preferences and persist independently of alerts', () {
    expect(const AppSettings().appIconBadge, isTrue);
    final old = AppSettings.decode('{"notifications":"off"}');
    expect(old.appIconBadge, isTrue);
    final disabled = AppSettings.decode(
      old.copyWith(appIconBadge: false).encode(),
    );
    expect(disabled.appIconBadge, isFalse);
    expect(disabled.notifications, NotificationChoice.off);
    final enabled = disabled.copyWith(appIconBadge: true);
    expect(AppSettings.decode(enabled.encode()).appIconBadge, isTrue);
    expect(enabled.notifications, NotificationChoice.off);
  });

  test('the mail check interval defaults to a minute and round-trips', () {
    const defaults = AppSettings();
    expect(defaults.mailCheckInterval, const Duration(minutes: 1));
    expect(defaults.mailCheckLive, isTrue);
    final decoded = AppSettings.decode(defaults.encode());
    expect(decoded.mailCheckInterval, const Duration(minutes: 1));
    expect(decoded.mailCheckLive, isTrue);

    final chosen = defaults.copyWith(
      mailCheckInterval: const Duration(minutes: 15),
      mailCheckLive: false,
    );
    final roundTrip = AppSettings.decode(chosen.encode());
    expect(roundTrip.mailCheckInterval, const Duration(minutes: 15));
    expect(roundTrip.mailCheckLive, isFalse);
  });

  test('an interval the app no longer offers falls back to a minute', () {
    expect(
      AppSettings.decode('{"mail_check_minutes": 7}').mailCheckInterval,
      const Duration(minutes: 1),
    );
  });
}
