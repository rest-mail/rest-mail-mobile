import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

Future<String> deviceTimeZone() async {
  try {
    return (await FlutterTimezone.getLocalTimezone()).identifier;
  } on PlatformException {
    return '';
  } on MissingPluginException {
    return '';
  }
}
