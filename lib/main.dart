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
