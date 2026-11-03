import 'package:flutter/foundation.dart';
import 'package:restmail_api/restmail_api.dart';

import '../util/device_time_zone.dart';

class QuietHoursState extends ChangeNotifier {
  QuietHoursState({
    required this.client,
    required this.accountId,
    this.localTimeZone = deviceTimeZone,
  });

  final RestmailClient client;
  final int accountId;
  final Future<String> Function() localTimeZone;
  QuietHoursSetting? setting;
  ApiException? error;
  bool loading = false;
  bool saving = false;
  bool saved = false;
  bool _disposed = false;

  bool get editable => setting != null && !loading && !saving;

  Future<void> load() async {
    if (loading || saving) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      var value = await client.quietHours(accountId);
      if (value.timeZone.isEmpty) {
        value = value.copyWith(timeZone: await localTimeZone());
      }
      if (!_disposed) setting = value;
    } on ApiException catch (failure) {
      if (!_disposed) error = failure;
    } finally {
      if (!_disposed) {
        loading = false;
        notifyListeners();
      }
    }
  }

  void edit(QuietHoursSetting value) {
    if (!editable) return;
    setting = value;
    error = null;
    saved = false;
    notifyListeners();
  }

  Future<void> save() async {
    if (!editable) return;
    saving = true;
    saved = false;
    error = null;
    notifyListeners();
    try {
      final value = await client.setQuietHours(accountId, setting!);
      if (!_disposed) {
        setting = value;
        saved = true;
      }
    } on ApiException catch (failure) {
      if (!_disposed) error = failure;
    } finally {
      if (!_disposed) {
        saving = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
