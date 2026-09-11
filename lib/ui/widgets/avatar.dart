import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../util/format.dart';

/// A round avatar with a person's initials on a colour of their own.
class RmAvatar extends StatelessWidget {
  const RmAvatar({
    super.key,
    required this.name,
    required this.seed,
    this.size = 42,
    this.color,
  });

  final String name;

  /// What picks the colour — the address, so a sender keeps theirs.
  final String seed;
  final double size;

  /// Overrides the seeded colour, as the drawer does for the user's own.
  final Color? color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? avatarTint(seed),
        shape: BoxShape.circle,
      ),
      child: Text(
        initialsOf(name),
        style: rmText(
          size * 0.34,
          color: Colors.white,
          weight: FontWeight.w700,
          tracking: -0.01,
        ),
      ),
    ),
  );
}

/// The rest-mail mark: an envelope on an accent tile.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: context.rm.accent,
      borderRadius: BorderRadius.circular(size * 9 / 34),
    ),
    child: CustomPaint(painter: _EnvelopePainter()),
  );
}

/// The design's 18-unit envelope glyph, drawn at 18/34 of the tile.
class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width * 18 / 34 / 18;
    final offset = (size.width - 18 * unit) / 2;
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * unit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..save()
      ..translate(offset, offset)
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1.5 * unit, 3.5 * unit, 15 * unit, 11 * unit),
          Radius.circular(2 * unit),
        ),
        stroke,
      )
      ..drawPath(
        Path()
          ..moveTo(2 * unit, 5 * unit)
          ..lineTo(9 * unit, 10 * unit)
          ..lineTo(16 * unit, 5 * unit),
        stroke,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_EnvelopePainter oldDelegate) => false;
}
