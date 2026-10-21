import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/theme/packs.dart';

void main() {
  test('every pack has its own id, and byId falls back to classic', () {
    final ids = ThemePack.all.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
    expect(ThemePack.byId(null), same(ThemePack.classic));
    expect(ThemePack.byId('nope'), same(ThemePack.classic));
    expect(ThemePack.byId('nightops'), same(ThemePack.nightops));
  });

  test('only classic follows the system brightness', () {
    expect(ThemePack.classic.followsSystem, isTrue);
    for (final pack in ThemePack.all.skip(1)) {
      expect(pack.followsSystem, isFalse);
    }
    expect(ThemePack.nightops.brightness, Brightness.dark);
  });

  test('the classic pack keeps the shipped look', () {
    final v = ThemePack.classic.variants;
    expect(v.surface, Surface.dividers);
    expect(v.unread, UnreadSignal.dot);
    expect(v.identity, Identity.circle);
    expect(v.listType, Typeface.sans);
    expect(v.actions, ActionStyle.icons);
  });

  test('variant axes lerp by snapping, they do not blend', () {
    const a = RmVariants();
    const b = RmVariants(surface: Surface.cards, actions: ActionStyle.words);
    expect(a.lerp(b, 0.49).surface, Surface.dividers);
    expect(a.lerp(b, 0.51).surface, Surface.cards);
  });

  test('the mark always carries its own ink', () {
    for (final pack in ThemePack.all) {
      expect(
        pack.colors.mark.computeLuminance(),
        isNot(pack.colors.onMark.computeLuminance()),
      );
    }
  });

  test('settings remember the pack, and survive a bad value', () {
    final encoded = const AppSettings(packId: 'ledger').encode();
    expect(AppSettings.decode(encoded).packId, 'ledger');
    expect(const AppSettings().packId, 'classic');
    expect(AppSettings.decode('not json').packId, 'classic');
  });
}
