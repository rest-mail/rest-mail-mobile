import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';

/// How message rows are separated / surfaced.
enum Surface { dividers, rules, dense, cards }

/// How an unread message announces itself beyond being heavier.
enum UnreadSignal { weight, rail, dot }

/// The sender identity chip; `none` hides avatars altogether.
enum Identity { none, squircle, circle }

/// Family used for the list, the reader and message bodies.
enum Typeface { sans, serif, mono }

/// How the reader labels its actions.
enum ActionStyle { icons, words, keyed }

/// The structural half of a theme pack. Tokens alone cannot say "rows become
/// cards" or "actions become words", so a pack pins one value per axis and
/// widgets branch on them — once each.
@immutable
class RmVariants extends ThemeExtension<RmVariants> {
  const RmVariants({
    this.surface = Surface.dividers,
    this.unread = UnreadSignal.dot,
    this.identity = Identity.circle,
    this.listType = Typeface.sans,
    this.readerType = Typeface.sans,
    this.actions = ActionStyle.icons,
  });

  final Surface surface;
  final UnreadSignal unread;
  final Identity identity;
  final Typeface listType;
  final Typeface readerType;
  final ActionStyle actions;

  @override
  RmVariants copyWith({
    Surface? surface,
    UnreadSignal? unread,
    Identity? identity,
    Typeface? listType,
    Typeface? readerType,
    ActionStyle? actions,
  }) => RmVariants(
    surface: surface ?? this.surface,
    unread: unread ?? this.unread,
    identity: identity ?? this.identity,
    listType: listType ?? this.listType,
    readerType: readerType ?? this.readerType,
    actions: actions ?? this.actions,
  );

  /// Axes are discrete: a theme animation snaps at the halfway point.
  @override
  RmVariants lerp(RmVariants? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

extension RmVariantsContext on BuildContext {
  RmVariants get rmv => Theme.of(this).extension<RmVariants>()!;
}

/// The platform family for a typeface axis. Only Public Sans ships in the
/// bundle; serif and mono fall back to the platform's own book and terminal
/// faces, so a pack costs no extra font assets.
String typefaceFamily(Typeface typeface) => switch (typeface) {
  Typeface.sans => rmFontFamily,
  Typeface.serif =>
    defaultTargetPlatform == TargetPlatform.iOS ? 'Georgia' : 'serif',
  Typeface.mono =>
    defaultTargetPlatform == TargetPlatform.iOS ? 'Courier New' : 'monospace',
};

/// A skin: a palette, a brightness policy and a pinned value per variant
/// axis. Adding one that reuses existing axis values touches only this file.
@immutable
class ThemePack {
  const ThemePack({
    required this.id,
    required this.name,
    required this.tagline,
    required this.colors,
    required this.variants,
    this.followsSystem = false,
    this.brightness = Brightness.light,
  });

  final String id;
  final String name;
  final String tagline;
  final RmColors colors;
  final RmVariants variants;

  /// Classic follows the system light/dark choice; the others are their own.
  final bool followsSystem;
  final Brightness brightness;

  /// The look the app shipped with: the design's blue on light or dark.
  static const classic = ThemePack(
    id: 'classic',
    name: 'Classic',
    tagline: 'The design as shipped. Follows system light and dark.',
    colors: RmColors.light,
    variants: RmVariants(),
    followsSystem: true,
  );

  /// Navy ink with yellow as the single loud note.
  static const brand = ThemePack(
    id: 'brand',
    name: 'Brand',
    tagline: 'Navy ink, one loud yellow note. The official-client look.',
    colors: RmColors(
      bg: Color(0xFFFFFFFF),
      surface: Color(0xFFF4F6FA),
      ink: Color(0xFF12203A),
      ink2: Color(0xFF61708B),
      ink3: Color(0xFF8A97AC),
      line: Color(0xFFE4E9F1),
      good: Color(0xFF1E8A50),
      danger: Color(0xFFC0392B),
      tintPurple: Color(0xFF5E6AD2),
      tintAmber: Color(0xFFB98900),
      accent: Color(0xFF1A2A4A),
      accentSoft: Color(0x121A2A4A),
      accentLine: Color(0x381A2A4A),
      mark: Color(0xFFFFCC00),
      onMark: Color(0xFF12203A),
    ),
    variants: RmVariants(
      unread: UnreadSignal.rail,
      identity: Identity.squircle,
    ),
  );

  /// Editorial paper: serif subjects, full-bleed rules, actions as words.
  static const ledger = ThemePack(
    id: 'ledger',
    name: 'Ledger',
    tagline: 'Editorial paper. Serif subjects, rules, actions as words.',
    colors: RmColors(
      bg: Color(0xFFFAF7F0),
      surface: Color(0xFFF1ECE0),
      ink: Color(0xFF1A1B17),
      ink2: Color(0xFF6F6A5C),
      ink3: Color(0xFF98917F),
      line: Color(0xFFE4DDCD),
      good: Color(0xFF4A6741),
      danger: Color(0xFF96351F),
      tintPurple: Color(0xFF6B5E78),
      tintAmber: Color(0xFF8A6A00),
      accent: Color(0xFF96351F),
      accentSoft: Color(0x1296351F),
      accentLine: Color(0x3896351F),
      mark: Color(0xFF96351F),
      onMark: Color(0xFFFAF7F0),
    ),
    variants: RmVariants(
      surface: Surface.rules,
      unread: UnreadSignal.weight,
      identity: Identity.none,
      listType: Typeface.serif,
      readerType: Typeface.serif,
      actions: ActionStyle.words,
    ),
  );

  /// Terminal dark: dense rows, amber rail, key hints on the actions.
  static const nightops = ThemePack(
    id: 'nightops',
    name: 'Night Ops',
    tagline: 'Terminal dark. Dense rows, amber rail, key hints.',
    brightness: Brightness.dark,
    colors: RmColors(
      bg: Color(0xFF0B0D12),
      surface: Color(0xFF11161D),
      ink: Color(0xFFD9E1EB),
      ink2: Color(0xFF7A8494),
      ink3: Color(0xFF5A6472),
      line: Color(0xFF1C232D),
      good: Color(0xFF3DD68C),
      danger: Color(0xFFFF6259),
      tintPurple: Color(0xFF9B85FF),
      tintAmber: Color(0xFFFFB020),
      accent: Color(0xFFFFB020),
      accentSoft: Color(0x24FFB020),
      accentLine: Color(0x59FFB020),
      mark: Color(0xFFFFB020),
      onMark: Color(0xFF191204),
    ),
    variants: RmVariants(
      surface: Surface.dense,
      unread: UnreadSignal.rail,
      identity: Identity.none,
      listType: Typeface.mono,
      readerType: Typeface.mono,
      actions: ActionStyle.keyed,
    ),
  );

  static const all = [classic, brand, ledger, nightops];

  static ThemePack byId(String? id) =>
      all.firstWhere((p) => p.id == id, orElse: () => classic);
}
