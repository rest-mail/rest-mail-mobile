import 'dart:convert';

import 'package:flutter/material.dart';

/// Preferences kept on the device. None of them reach the server.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.signature = '',
    this.signReplies = false,
  });

  factory AppSettings.decode(String? raw) {
    if (raw == null) return const AppSettings();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings(
        themeMode:
            ThemeMode.values.asNameMap()[json['theme']] ?? ThemeMode.system,
        signature: json['signature'] as String? ?? '',
        signReplies: json['sign_replies'] as bool? ?? false,
      );
    } on Object {
      return const AppSettings();
    }
  }

  /// System until the user picks light or dark.
  final ThemeMode themeMode;

  /// Appended to new messages when not empty.
  final String signature;

  /// Whether replies and forwards get the signature too.
  final bool signReplies;

  String encode() => jsonEncode({
    'theme': themeMode.name,
    'signature': signature,
    'sign_replies': signReplies,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? signature,
    bool? signReplies,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    signature: signature ?? this.signature,
    signReplies: signReplies ?? this.signReplies,
  );
}
