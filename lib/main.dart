import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'app.dart';
import 'net/http_client.dart';
import 'sample_mode.dart';
import 'state/app_state.dart';
import 'state/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = sampleMode
      ? _sampleState()
      : AppState(
          store: SecureKeyValueStore(),
          httpClientFactory: createHttpClient,
        );
  runApp(RestmailApp(state: state));
  await state.start();
  // Sign-in links, from the QR code the installer showed: the app opens on the
  // server's setup, sign-in filled in.
  final links = AppLinks();
  links.uriLinkStream.listen(state.openLink);
  final initial = await links.getInitialLink();
  if (initial != null) state.openLink(initial);
}

/// The app on an in-memory server. Nothing is kept between launches: the
/// fake starts afresh each time, so a stored session would name tokens it
/// never issued.
AppState _sampleState() {
  final fake = FakeRestmail(
    scenario: FakeScenario.values.byName(sampleScenario),
  );
  return AppState(
    store: MemoryKeyValueStore(),
    httpClientFactory: () => fake.client,
  );
}
