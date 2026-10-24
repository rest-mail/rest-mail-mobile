import 'dart:convert';
import 'dart:io';

import '../../lib/l10n/catalog.dart';

/// Keep system permission prompts in the same language catalog as the app.
void main(List<String> args) {
  final check = args.contains('--check');
  for (final language in ['en', 'de', 'es', 'hi', 'ne', 'ar', 'fa']) {
    final file = File('ios/Runner/$language.lproj/InfoPlist.strings');
    final text = languageLine(language, 'native.cameraUsage');
    final expected =
        '// Generated from lib/l10n; edit the language pack.\n'
        '"NSCameraUsageDescription" = ${jsonEncode(text)};\n';
    if (check) {
      if (!file.existsSync() || file.readAsStringSync() != expected) {
        stderr.writeln(
          '${file.path} is out of date. Run dart tool/ci/generate_ios_localizations.dart.',
        );
        exitCode = 1;
      }
    } else {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(expected);
    }
  }
}
