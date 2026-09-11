import 'package:flutter/material.dart';

import 'app.dart';
import 'net/http_client.dart';
import 'state/app_state.dart';
import 'state/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(
    store: SecureKeyValueStore(),
    httpClientFactory: createHttpClient,
  );
  runApp(RestmailApp(state: state));
  await state.start();
}
