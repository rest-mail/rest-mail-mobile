import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

import '../../state/app_scope.dart';
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
    this.iconFileName,
    this.faviconHosts,
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

  /// The custom icon this account picked, or null for the initials.
  final String? iconFileName;

  /// When set, the account's provider or domain favicons, in preference
  /// order.
  final List<String>? faviconHosts;

  @override
  Widget build(BuildContext context) {
    final fallback = ExcludeSemantics(
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
    if (iconFileName == null &&
        (faviconHosts == null || faviconHosts!.isEmpty)) {
      return fallback;
    }
    return AccountIcon(
      fileName: iconFileName,
      faviconHosts: faviconHosts,
      fallback: fallback,
      size: size,
      radius: radius,
    );
  }
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

/// An account's custom icon when it has one, otherwise its fetched provider
/// favicon, otherwise [fallback]: the REST Mail mark in the mailbox header,
/// or initials in a list.
class AccountIcon extends StatefulWidget {
  const AccountIcon({
    super.key,
    this.fileName,
    this.faviconHosts,
    required this.fallback,
    this.size = 42,
    this.radius,
  });

  /// The file name in the app's `account_icons` folder, or null.
  final String? fileName;

  /// The hosts whose favicon may label this account, in order.
  final List<String>? faviconHosts;
  final Widget fallback;
  final double size;
  final BorderRadius? radius;

  @override
  State<AccountIcon> createState() => _AccountIconState();
}

class _AccountIconState extends State<AccountIcon> {
  Future<File?>? _file;
  Future<File?>? _favicon;

  @override
  void initState() {
    super.initState();
    _file = _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favicon = _loadFavicon();
  }

  @override
  void didUpdateWidget(covariant AccountIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileName != widget.fileName) {
      _file = _load();
      _favicon = _loadFavicon();
    }
    if (!listEquals(oldWidget.faviconHosts, widget.faviconHosts)) {
      _favicon = _loadFavicon();
    }
  }

  Future<File?>? _load() {
    final name = widget.fileName;
    if (name == null) return null;
    return _iconFile(name);
  }

  Future<File?>? _loadFavicon() {
    final hosts = widget.faviconHosts;
    if (widget.fileName != null || hosts == null || hosts.isEmpty) return null;
    return AppScope.of(context).favicons.iconFor(hosts);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileName != null) {
      return _fileBuilder(_file);
    }
    if (widget.faviconHosts?.isNotEmpty ?? false) {
      return _fileBuilder(_favicon);
    }
    return widget.fallback;
  }

  Widget _fileBuilder(Future<File?>? future) => FutureBuilder<File?>(
    future: future,
    builder: (context, snapshot) {
      final file = snapshot.data;
      return _imageOrFallback(file);
    },
  );

  Widget _imageOrFallback(File? file) {
    if (file == null) return widget.fallback;
    return ClipRRect(
      borderRadius: widget.radius ?? BorderRadius.circular(widget.size / 2),
      child: Image.file(
        file,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => widget.fallback,
      ),
    );
  }

  static Future<File?> _iconFile(String name) async {
    try {
      final directory = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/account_icons',
      );
      final file = File('${directory.path}/$name');
      return await file.exists() ? file : null;
    } on FileSystemException {
      return null;
    }
  }
}
