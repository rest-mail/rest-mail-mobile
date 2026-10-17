import 'dart:convert';

import 'package:flutter/material.dart';

/// Whether the user wants to hear of new mail when the app is closed.
enum NotificationChoice {
  /// Not asked yet. The app explains and asks once, after sign-in.
  undecided,
  on,

  /// Said no, or turned it off in Settings.
  off,
}

/// Preferences kept on the device. None of them reach the server.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.signature = '',
    this.signReplies = false,
    this.notifications = NotificationChoice.undecided,
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
        notifications:
            NotificationChoice.values.asNameMap()[json['notifications']] ??
            NotificationChoice.undecided,
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

  /// New mail notifications, for the REST Mail accounts whose server can
  /// send them.
  final NotificationChoice notifications;

  String encode() => jsonEncode({
    'theme': themeMode.name,
    'signature': signature,
    'sign_replies': signReplies,
    'notifications': notifications.name,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? signature,
    bool? signReplies,
    NotificationChoice? notifications,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    signature: signature ?? this.signature,
    signReplies: signReplies ?? this.signReplies,
    notifications: notifications ?? this.notifications,
  );
}
