import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.radius,
  });

  final String name;

  /// What picks the colour — the address, so a sender keeps theirs.
  final String seed;
  final double size;

  /// Overrides the seeded colour, as the drawer does for the user's own.
  final Color? color;

  /// Corner radius for packs whose identity axis wants a squircle; null
  /// keeps the circle.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? avatarTint(seed),
        borderRadius: radius,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
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

/// The REST Mail brand mark, exactly as the brand draws it.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/brand/rest-mail-icon.svg',
    width: size,
    height: size,
  );
}
