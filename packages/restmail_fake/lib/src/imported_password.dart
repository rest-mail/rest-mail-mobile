import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypt/crypt.dart';

const importedPasswordProblem =
    'use a valid BLF-CRYPT (cost 4–14), SHA256-CRYPT or SHA512-CRYPT '
    '(1000–1000000 rounds) hash';

// The production request schema's formats and bounds. Only format validation
// happens on import; the libraries verify the password when it is presented.
final _bcrypt = RegExp(r'^\$2[aby]\$(0[4-9]|1[0-4])\$[./A-Za-z0-9]{53}$');
final _sha256 = RegExp(
  r'^\$5\$(rounds=([1-9][0-9]{3,5}|1000000)\$)?[./A-Za-z0-9]{1,16}\$[./A-Za-z0-9]{43}$',
);
final _sha512 = RegExp(
  r'^\$6\$(rounds=([1-9][0-9]{3,5}|1000000)\$)?[./A-Za-z0-9]{1,16}\$[./A-Za-z0-9]{86}$',
);

String normalizeImportedPasswordHash(String value) {
  if (utf8.encode(value).length > 256) {
    throw const FormatException(importedPasswordProblem);
  }
  var raw = value;
  var scheme = '';
  if (value.startsWith('{')) {
    final end = value.indexOf('}');
    if (end < 0) throw const FormatException(importedPasswordProblem);
    scheme = value.substring(0, end + 1);
    raw = value.substring(end + 1);
  }
  if ((_bcrypt.hasMatch(raw) && (scheme.isEmpty || scheme == '{BLF-CRYPT}')) ||
      (_sha256.hasMatch(raw) &&
          (scheme.isEmpty || scheme == '{SHA256-CRYPT}')) ||
      (_sha512.hasMatch(raw) &&
          (scheme.isEmpty || scheme == '{SHA512-CRYPT}'))) {
    return raw;
  }
  throw const FormatException(importedPasswordProblem);
}

bool verifyImportedPassword(String raw, String password) {
  if (utf8.encode(password).length > 4096) return false;
  return raw.startsWith(r'$2')
      ? BCrypt.checkpw(password, raw)
      : Crypt(raw).match(password);
}
