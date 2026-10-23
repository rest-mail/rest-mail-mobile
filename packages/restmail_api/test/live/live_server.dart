// A real REST Mail server for the live tests, started by
// tool/ci/live_server.sh. Without its settings every live test is skipped, so
// `dart test` on its own runs only the unit tests.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:restmail_api/restmail_api.dart';

final _env = Platform.environment;

/// Why the live tests are skipped, or null when a server is set.
final String? skipLive = _env['RESTMAIL_LIVE_SERVER'] == null
    ? 'no live server: run tool/ci/live_server.sh up and load its settings'
    : null;

Uri get liveServer => Uri.parse(_env['RESTMAIL_LIVE_SERVER']!);
String get liveEmail => _env['RESTMAIL_LIVE_EMAIL']!;
String get bootstrapPassword => _env['RESTMAIL_LIVE_PASSWORD']!;

/// The password the tests choose in place of the bootstrap one.
const livePassword = 'a live test password, long enough';

/// Where the first test file to sign in leaves the authenticator's secret for
/// the others: the bootstrap password works only once.
File get _stateFile => File(
  _env['RESTMAIL_LIVE_STATE'] ??
      '${Directory.systemTemp.path}/restmail-live-${liveServer.port}.json',
);

/// The admin, signed in with a password of its own and an authenticator, as a
/// fresh install's first sign-in makes it.
class LiveAdmin {
  LiveAdmin._(this.client, this.secret);

  final RestmailClient client;

  /// The authenticator's secret, for fresh codes.
  final String secret;

  int _lastStep = -1;

  /// Signs in with the bootstrap password, replaces it, enrolls an
  /// authenticator and signs in again with a code. Once that is done, a later
  /// test file signs in with the password and authenticator it left.
  static Future<LiveAdmin> setUp() async {
    final client = RestmailClient(server: liveServer);
    final LoginResult first;
    try {
      first = await client.login(email: liveEmail, password: bootstrapPassword);
    } on ApiException catch (e) {
      if (e.statusCode != 401 || !_stateFile.existsSync()) rethrow;
      final state = jsonDecode(_stateFile.readAsStringSync()) as Map;
      final admin = LiveAdmin._(client, state['secret'] as String)
        .._lastStep = state['step'] as int;
      await client.login(
        email: liveEmail,
        password: livePassword,
        totpCode: await admin.freshCode(),
      );
      return admin;
    }
    if (!first.setupRequired.contains(SetupStep.password)) {
      throw StateError('a fresh install asks for a new password first');
    }
    await client.changePassword(current: bootstrapPassword, next: livePassword);
    await client.login(email: liveEmail, password: livePassword);
    final enrollment = await client.enrollTwoFactor();
    final admin = LiveAdmin._(client, enrollment.secret);
    await client.confirmTwoFactor(await admin.freshCode());
    final signedIn = await client.login(
      email: liveEmail,
      password: livePassword,
      totpCode: await admin.freshCode(),
    );
    if (!signedIn.isSetUp) {
      throw StateError('still in setup: ${signedIn.setupRequired}');
    }
    return admin;
  }

  /// A code from a 30-second step no earlier code used: the server takes each
  /// step's code once.
  Future<String> freshCode() async {
    while (true) {
      final step = DateTime.now().millisecondsSinceEpoch ~/ 30000;
      if (step > _lastStep) {
        _lastStep = step;
        _stateFile.writeAsStringSync(
          jsonEncode({'secret': secret, 'step': step}),
        );
        return totp(secret, step);
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }
}

/// RFC 6238 TOTP: six digits, HMAC-SHA1, 30-second steps.
String totp(String base32Secret, int step) {
  final key = _base32(base32Secret);
  final counter = List<int>.generate(8, (i) => (step >> (8 * (7 - i))) & 0xff);
  final mac = Hmac(sha1, key).convert(counter).bytes;
  final offset = mac.last & 0x0f;
  final value =
      ((mac[offset] & 0x7f) << 24) |
      (mac[offset + 1] << 16) |
      (mac[offset + 2] << 8) |
      mac[offset + 3];
  return (value % 1000000).toString().padLeft(6, '0');
}

List<int> _base32(String text) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  final bytes = <int>[];
  var buffer = 0, bits = 0;
  for (final char in text.toUpperCase().replaceAll('=', '').split('')) {
    final index = alphabet.indexOf(char);
    if (index < 0) continue;
    buffer = (buffer << 5) | index;
    bits += 5;
    if (bits >= 8) {
      bits -= 8;
      bytes.add((buffer >> bits) & 0xff);
    }
  }
  return bytes;
}
