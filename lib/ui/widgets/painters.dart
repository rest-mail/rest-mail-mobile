import 'dart:math';

import 'package:flutter/material.dart';

/// Diagonal stripes, the design's stand-in for a file preview.
class Hatch extends StatelessWidget {
  const Hatch({super.key, required this.color, this.child});

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _HatchPainter(color), child: child);
}

class _HatchPainter extends CustomPainter {
  _HatchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const period = 10.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = period / 2 / sqrt2;
    canvas.clipRect(Offset.zero & size);
    for (var x = -size.height; x < size.width; x += period) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HatchPainter oldDelegate) => oldDelegate.color != color;
}

/// A horizontal dashed rule.
class DashedLine extends StatelessWidget {
  const DashedLine({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    width: double.infinity,
    child: CustomPaint(painter: _DashPainter(color)),
  );
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 7) {
      canvas.drawLine(
        Offset(x, 0.5),
        Offset(min(x + 4, size.width), 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => oldDelegate.color != color;
}

/// A dashed ring, for the "add" row in a list of avatars.
class DashedCircle extends StatelessWidget {
  const DashedCircle({
    super.key,
    required this.color,
    required this.size,
    this.child,
  });

  final Color color;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _RingPainter(color),
      child: Center(child: child),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final rect = (Offset.zero & size).deflate(0.7);
    const dashes = 16;
    const sweep = 2 * pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, i * sweep, sweep * 0.6, false, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => oldDelegate.color != color;
}
