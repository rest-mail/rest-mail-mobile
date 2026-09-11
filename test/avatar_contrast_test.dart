import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/util/format.dart';

/// The WCAG contrast ratio between two colours, 1 to 21.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  // Enough senders that every colour in the palette comes up.
  final seeds = [for (var i = 0; i < 400; i++) 'sender$i@example.test'];

  test('every avatar colour stands out from the dark background', () {
    for (final seed in seeds) {
      final tint = avatarTint(seed);
      expect(
        _contrast(tint, RmColors.dark.bg),
        greaterThanOrEqualTo(2),
        reason: '$seed gets ${cssColor(tint)}',
      );
    }
  });

  test('and from the light one', () {
    for (final seed in seeds) {
      final tint = avatarTint(seed);
      expect(
        _contrast(tint, RmColors.light.bg),
        greaterThanOrEqualTo(2),
        reason: '$seed gets ${cssColor(tint)}',
      );
    }
  });
}
