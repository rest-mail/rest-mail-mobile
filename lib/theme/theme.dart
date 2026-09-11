import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? RmColors.dark : RmColors.light;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: c.accent,
        brightness: brightness,
      ).copyWith(
        primary: c.accent,
        onPrimary: Colors.white,
        surface: c.bg,
        onSurface: c.ink,
        onSurfaceVariant: c.ink2,
        surfaceContainerHighest: c.surface,
        outline: c.line,
        outlineVariant: c.line,
        error: c.danger,
      );
  final field = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c.line, width: 1.5),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: rmFontFamily,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    extensions: [c],
    dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
    iconTheme: IconThemeData(color: c.ink),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.accent,
      selectionColor: c.accentLine,
      selectionHandleColor: c.accent,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      hintStyle: rmText(16, color: c.ink3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      enabledBorder: field,
      border: field,
      focusedBorder: field.copyWith(
        borderSide: BorderSide(color: c.accent, width: 1.5),
      ),
      errorBorder: field.copyWith(
        borderSide: BorderSide(color: c.danger, width: 1.5),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.ink,
      contentTextStyle: rmText(14, color: c.bg, weight: FontWeight.w600),
      actionTextColor: c.accent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.bg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.line),
      ),
      textStyle: rmText(14.5, color: c.ink, weight: FontWeight.w500),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.bg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: rmText(
        17,
        color: c.ink,
        weight: FontWeight.w700,
        tracking: -0.02,
      ),
      contentTextStyle: rmText(14.5, color: c.ink2, height: 1.45),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.bg,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: Colors.black.withValues(alpha: 0.35),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: c.bg,
      surfaceTintColor: Colors.transparent,
      scrimColor: Colors.black.withValues(alpha: 0.42),
      width: 302,
      shape: const RoundedRectangleBorder(),
    ),
  );
}
