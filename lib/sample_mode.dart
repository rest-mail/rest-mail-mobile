import 'package:flutter/foundation.dart';

/// `--dart-define=RESTMAIL_FAKE=<scenario>` runs the app on the in-memory
/// server from packages/restmail_fake instead of the network, so every screen
/// works on a simulator or phone with no rest-mail server. The scenarios are
/// `sample`, `empty` and `twoFactor`.
const sampleScenario = String.fromEnvironment('RESTMAIL_FAKE');

/// Debug builds only. Both halves are compile-time constants, and
/// `kDebugMode` is false in profile and release, so there the fake is not
/// even compiled in.
const sampleMode = kDebugMode && sampleScenario != '';
