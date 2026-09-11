import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// A PEM certificate authority to trust on top of the system's, so a debug
/// build can reach a local testbed whose certificates come from its own CA.
///
/// Passed with `--dart-define-from-file=.dev/testbed.json` and honoured in
/// debug builds only: `kDebugMode` is a compile-time false in profile and
/// release, so there the branch below is not even compiled in and the app
/// trusts exactly what the device trusts. There is deliberately no switch to
/// skip certificate checks.
const _devCertificateAuthority = String.fromEnvironment('RESTMAIL_DEV_CA');

http.Client createHttpClient() {
  final context = SecurityContext(withTrustedRoots: true);
  if (kDebugMode && _devCertificateAuthority.isNotEmpty) {
    context.setTrustedCertificatesBytes(utf8.encode(_devCertificateAuthority));
  }
  final client = HttpClient(context: context)
    ..connectionTimeout = const Duration(seconds: 15)
    ..idleTimeout = const Duration(seconds: 30);
  return IOClient(client);
}
