import 'package:flutter/material.dart';

/// The design's colour tokens (its `LIGHT` and `DARK` palettes and accent) as
/// a theme extension, so widgets say `context.rm.ink2` rather than guessing
/// which Material role a grey maps to.
@immutable
class RmColors extends ThemeExtension<RmColors> {
  const RmColors({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.good,
    required this.danger,
    required this.tintPurple,
    required this.tintAmber,
    required this.accent,
    required this.accentSoft,
    required this.accentLine,
  });

  static const _accent = Color(0xFF2B59FF);

  static const light = RmColors(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF7F7F8),
    ink: Color(0xFF0B0B0C),
    ink2: Color(0xFF585A5F),
    ink3: Color(0xFF8B8E94),
    line: Color(0xFFE4E5E8),
    good: Color(0xFF0F9E6E),
    danger: Color(0xFFD2402C),
    tintPurple: Color(0xFF7A5CFF),
    tintAmber: Color(0xFFD08420),
    accent: _accent,
    accentSoft: Color(0x122B59FF), // 7%
    accentLine: Color(0x382B59FF), // 22%
  );

  static const dark = RmColors(
    bg: Color(0xFF0C0D0F),
    surface: Color(0xFF15171A),
    ink: Color(0xFFF4F5F6),
    ink2: Color(0xFFA3A7AE),
    ink3: Color(0xFF767A82),
    line: Color(0xFF242730),
    good: Color(0xFF3BC495),
    danger: Color(0xFFF4715C),
    tintPurple: Color(0xFF9B85FF),
    tintAmber: Color(0xFFE0A24A),
    accent: _accent,
    accentSoft: Color(0x242B59FF), // 14%
    accentLine: Color(0x592B59FF), // 35%
  );

  /// Page background.
  final Color bg;

  /// Cards, grouped rows, input fields.
  final Color surface;

  /// Primary, secondary and tertiary text.
  final Color ink;
  final Color ink2;
  final Color ink3;

  /// Hairlines and borders.
  final Color line;
  final Color good;
  final Color danger;
  final Color tintPurple;
  final Color tintAmber;
  final Color accent;

  /// The accent as a wash, behind a selected row.
  final Color accentSoft;

  /// The accent as a border, around a focused field.
  final Color accentLine;

  @override
  RmColors copyWith({
    Color? bg,
    Color? surface,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? good,
    Color? danger,
    Color? tintPurple,
    Color? tintAmber,
    Color? accent,
    Color? accentSoft,
    Color? accentLine,
  }) => RmColors(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    ink: ink ?? this.ink,
    ink2: ink2 ?? this.ink2,
    ink3: ink3 ?? this.ink3,
    line: line ?? this.line,
    good: good ?? this.good,
    danger: danger ?? this.danger,
    tintPurple: tintPurple ?? this.tintPurple,
    tintAmber: tintAmber ?? this.tintAmber,
    accent: accent ?? this.accent,
    accentSoft: accentSoft ?? this.accentSoft,
    accentLine: accentLine ?? this.accentLine,
  );

  @override
  RmColors lerp(RmColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return RmColors(
      bg: mix(bg, other.bg),
      surface: mix(surface, other.surface),
      ink: mix(ink, other.ink),
      ink2: mix(ink2, other.ink2),
      ink3: mix(ink3, other.ink3),
      line: mix(line, other.line),
      good: mix(good, other.good),
      danger: mix(danger, other.danger),
      tintPurple: mix(tintPurple, other.tintPurple),
      tintAmber: mix(tintAmber, other.tintAmber),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      accentLine: mix(accentLine, other.accentLine),
    );
  }
}

extension RmThemeContext on BuildContext {
  RmColors get rm => Theme.of(this).extension<RmColors>()!;
}

const rmFontFamily = 'PublicSans';

/// A text style the way the design writes one: size in logical pixels and
/// letter-spacing in ems, so `-0.03em` at 19px is `tracking: -0.03`.
TextStyle rmText(
  double size, {
  required Color color,
  FontWeight weight = FontWeight.w400,
  double? height,
  double tracking = 0,
}) => TextStyle(
  fontFamily: rmFontFamily,
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
  letterSpacing: size * tracking,
);

/// `#RRGGBB`, for the CSS handed to the HTML renderer.
String cssColor(Color color) =>
    '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
