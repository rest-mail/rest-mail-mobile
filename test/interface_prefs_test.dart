import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/interface_prefs.dart';
import 'package:restmail/state/settings.dart';

void main() {
  test('a panel follows its default until it is set', () {
    const prefs = InterfacePrefs();
    expect(prefs.isOn(dateSeparatorsPanel), isFalse);
    expect(prefs.isOn(senderTrustPanel), isTrue);
  });

  test('options keep their defaults and remember changes', () {
    var prefs = const InterfacePrefs();
    expect(prefs.choice(dateSeparatorsPanel, dayStyleOption), 'relative');
    expect(prefs.toggle(dateSeparatorsPanel, dayCountOption), isFalse);

    prefs = prefs.withPanel('date_separators', true);
    prefs = prefs.withValue('date_separators', 'style', 'absolute');
    prefs = prefs.withValue('date_separators', 'count', true);

    expect(prefs.choice(dateSeparatorsPanel, dayStyleOption), 'absolute');
    expect(prefs.toggle(dateSeparatorsPanel, dayCountOption), isTrue);
  });

  test('settings round-trip through storage', () {
    final prefs = const InterfacePrefs()
        .withPanel('date_separators', true)
        .withValue('date_separators', 'style', 'absolute');
    final encoded = const AppSettings().copyWith(interface: prefs).encode();
    final back = AppSettings.decode(encoded).interface;
    expect(back.isOn(dateSeparatorsPanel), isTrue);
    expect(back.choice(dateSeparatorsPanel, dayStyleOption), 'absolute');
  });

  test('unknown stored keys are ignored', () {
    final prefs = InterfacePrefs.decode({
      'panels': {'gone_panel': true},
      'values': {
        'gone_panel': {'x': 3},
      },
    });
    expect(prefs.enabled['gone_panel'], isTrue);
    expect(prefs.values['gone_panel'], isEmpty);
  });
}
