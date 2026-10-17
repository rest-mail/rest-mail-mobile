import 'package:flutter/services.dart';

/// Copies a secret, such as a new app password, as briefly and as privately
/// as the platform allows. Flutter's own [Clipboard] can do neither.
///
/// - iOS: the copy stays on this iPhone, so Universal Clipboard never hands
///   it to the user's other devices, and leaves the pasteboard by itself
///   after [lifetime] (`localOnly` and `expirationDate`, ios/Runner).
/// - Android: the copy is marked sensitive, so Android 13 and later keep it
///   out of the clipboard's preview, but nothing makes it expire.
/// - Anywhere else, Flutter's clipboard.
class SecretClipboard {
  const SecretClipboard();

  static const channel = MethodChannel('rest-mail/secret-clipboard');

  /// How long a copy lasts where the platform can make it expire.
  static const lifetime = Duration(minutes: 2);

  /// Copies [secret]. True when the copy stays on this device and goes by
  /// itself after [lifetime]; false when it stays until something else is
  /// copied, and other apps may read it.
  Future<bool> copy(String secret) async {
    try {
      final expires = await channel.invokeMethod<bool>('copy', {
        'text': secret,
        'seconds': lifetime.inSeconds,
      });
      if (expires != null) return expires;
    } on MissingPluginException {
      // A platform with no channel of ours: the plain clipboard below.
    } on PlatformException {
      // The same.
    }
    await Clipboard.setData(ClipboardData(text: secret));
    return false;
  }
}
