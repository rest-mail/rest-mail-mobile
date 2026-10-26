import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/settings.dart';

void main() {
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
