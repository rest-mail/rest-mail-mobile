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

  test('the list panels start on, matching the shipped look', () {
    const prefs = InterfacePrefs();
    expect(prefs.isOn(listPreviewPanel), isTrue);
    expect(prefs.choice(listPreviewPanel, previewLinesOption), 'two');
    expect(prefs.isOn(listAttachmentsPanel), isTrue);
    expect(prefs.isOn(listCountPanel), isTrue);
    expect(prefs.isOn(listFlagPanel), isTrue);
  });

  test('turning a list panel off leaves the row to its other parts', () {
    final prefs = const InterfacePrefs()
        .withPanel('list_count', false)
        .withPanel('list_flag', false)
        .withValue('list_preview', 'lines', 'none');
    expect(prefs.isOn(listCountPanel), isFalse);
    expect(prefs.isOn(listFlagPanel), isFalse);
    expect(prefs.choice(listPreviewPanel, previewLinesOption), 'none');
  });

  test('the composer panels start off, so nothing opens by surprise', () {
    const prefs = InterfacePrefs();
    expect(prefs.isOn(composerCcPanel), isFalse);
    expect(prefs.isOn(composerFromPanel), isFalse);
  });

  test('a preset writes every panel and option at once', () {
    var prefs = const InterfacePrefs();
    expect(classicPreset.prefs.matches(prefs), isTrue);

    prefs = triagePreset.prefs;
    expect(prefs.isOn(dateSeparatorsPanel), isTrue);
    expect(prefs.choice(dateSeparatorsPanel, dayStyleOption), 'absolute');
    expect(prefs.toggle(dateSeparatorsPanel, dayCountOption), isTrue);
    expect(prefs.choice(senderTrustPanel, trustShowForOption), 'warnings');
    expect(triagePreset.prefs.matches(prefs), isTrue);
    expect(classicPreset.prefs.matches(prefs), isFalse);

    prefs = readingPreset.prefs;
    expect(prefs.isOn(composerCcPanel), isTrue);
    expect(prefs.isOn(composerFromPanel), isFalse);
    expect(prefs.choice(senderTrustPanel, trustDetailOption), 'receipt');
    expect(readingPreset.prefs.matches(prefs), isTrue);
  });

  test('a preset survives storage and still matches', () {
    final stored = AppSettings.decode(
      const AppSettings().copyWith(interface: readingPreset.prefs).encode(),
    ).interface;
    expect(readingPreset.prefs.matches(stored), isTrue);
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
