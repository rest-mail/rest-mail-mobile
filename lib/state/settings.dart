import 'dart:convert';

import 'package:flutter/material.dart';

import 'interface_prefs.dart';

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
    this.packId = 'classic',
    this.signature = '',
    this.signReplies = false,
    this.notifications = NotificationChoice.undecided,
    this.appIconBadge = true,
    this.interface = const InterfacePrefs(),
    this.languageCode = 'system',
    this.lastSeenVersion = '',
    this.mailCheckInterval = const Duration(minutes: 1),
    this.mailCheckLive = true,
  });

  /// The intervals the app offers for accounts without live updates.
  static const mailCheckMinutes = [1, 5, 15, 30, 60];

  factory AppSettings.decode(String? raw) {
    if (raw == null) return const AppSettings();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings(
        themeMode:
            ThemeMode.values.asNameMap()[json['theme']] ?? ThemeMode.system,
        packId: json['pack'] as String? ?? 'classic',
        signature: json['signature'] as String? ?? '',
        signReplies: json['sign_replies'] as bool? ?? false,
        notifications:
            NotificationChoice.values.asNameMap()[json['notifications']] ??
            NotificationChoice.undecided,
        appIconBadge: json['app_icon_badge'] as bool? ?? true,
        interface: InterfacePrefs.decode(json['interface']),
        languageCode: json['language'] as String? ?? 'system',
        lastSeenVersion: json['last_seen_version'] as String? ?? '',
        mailCheckInterval: _mailCheckInterval(json['mail_check_minutes']),
        mailCheckLive: json['mail_check_live'] as bool? ?? true,
      );
    } on Object {
      return const AppSettings();
    }
  }

  /// System until the user picks light or dark.
  final ThemeMode themeMode;

  /// The theme pack in force. Packs that pin a brightness ignore [themeMode].
  final String packId;

  /// Appended to new messages when not empty.
  final String signature;

  /// Whether replies and forwards get the signature too.
  final bool signReplies;

  /// New mail notifications, for the REST Mail accounts whose server can
  /// send them.
  final NotificationChoice notifications;

  /// Show the total inbox unread count when the phone permits badges.
  /// Independent of new-mail alerts and server push support.
  final bool appIconBadge;

  /// Which optional components are on, and the options inside them.
  final InterfacePrefs interface;

  /// The language the app speaks: a language code, or `system` to follow the
  /// phone.
  final String languageCode;

  /// The app version whose What's New screen has been shown. Empty until one
  /// has been.
  final String lastSeenVersion;

  /// How often an account without live updates checks its inbox. REST Mail
  /// is live over SSE; IMAP uses IDLE where its server supports it. The
  /// interval is the fallback there, and what POP3 will use.
  final Duration mailCheckInterval;

  /// Whether IMAP may use IDLE, the server's live channel. False makes it
  /// check at [mailCheckInterval] instead, which is what a fixed interval
  /// asks for. REST Mail is live either way.
  final bool mailCheckLive;

  static Duration _mailCheckInterval(Object? value) {
    final minutes = value is num ? value.toInt() : 1;
    return Duration(minutes: mailCheckMinutes.contains(minutes) ? minutes : 1);
  }

  String encode() => jsonEncode({
    'theme': themeMode.name,
    'pack': packId,
    'signature': signature,
    'sign_replies': signReplies,
    'notifications': notifications.name,
    'app_icon_badge': appIconBadge,
    'interface': interface.toJson(),
    'language': languageCode,
    'last_seen_version': lastSeenVersion,
    'mail_check_minutes': mailCheckInterval.inMinutes,
    'mail_check_live': mailCheckLive,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? packId,
    String? signature,
    bool? signReplies,
    NotificationChoice? notifications,
    bool? appIconBadge,
    InterfacePrefs? interface,
    String? languageCode,
    String? lastSeenVersion,
    Duration? mailCheckInterval,
    bool? mailCheckLive,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    packId: packId ?? this.packId,
    signature: signature ?? this.signature,
    signReplies: signReplies ?? this.signReplies,
    notifications: notifications ?? this.notifications,
    appIconBadge: appIconBadge ?? this.appIconBadge,
    interface: interface ?? this.interface,
    languageCode: languageCode ?? this.languageCode,
    lastSeenVersion: lastSeenVersion ?? this.lastSeenVersion,
    mailCheckInterval: mailCheckInterval ?? this.mailCheckInterval,
    mailCheckLive: mailCheckLive ?? this.mailCheckLive,
  );
}
