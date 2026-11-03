import 'package:flutter/foundation.dart';
import 'package:restmail_api/restmail_api.dart';

/// The signed-in account's recovery email, as the server last reported it.
class RecoveryEmailState extends ChangeNotifier {
  RecoveryEmailState({required this.client});

  final RestmailClient client;
  RecoveryEmailStatus? status;
  ApiException? loadError;
  ApiException? saveError;
  bool loading = false;
  bool saving = false;
  bool linkSent = false;
  bool _disposed = false;

  /// Only the newest read may answer: one started before a registration
  /// must not put the old address back.
  var _read = 0;

  /// Reads the status again. What is already shown stays if this fails.
  Future<void> load() async {
    if (saving) return;
    final read = ++_read;
    loading = true;
    loadError = null;
    notifyListeners();
    try {
      final value = await client.recoveryEmail();
      if (_disposed || read != _read) return;
      status = value;
      if (value.stage == RecoveryEmailStage.verified) linkSent = false;
    } on ApiException catch (failure) {
      if (_disposed || read != _read) return;
      loadError = failure;
    }
    loading = false;
    notifyListeners();
  }

  /// Registers [email], and answers whether the server took it.
  Future<bool> register({
    required String email,
    required String currentPassword,
  }) async {
    if (saving) return false;
    _read++;
    loading = false;
    saving = true;
    saveError = null;
    loadError = null;
    linkSent = false;
    notifyListeners();
    try {
      await client.registerRecoveryEmail(
        email: email,
        currentPassword: currentPassword,
      );
    } on ApiException catch (failure) {
      if (_disposed) return false;
      saving = false;
      saveError = failure;
      notifyListeners();
      return false;
    }
    if (_disposed) return true;
    saving = false;
    // The server stores the address in lower case, pending. The read below
    // confirms it; if that read fails, this is still what is true.
    status = RecoveryEmailStatus(email: email.toLowerCase());
    linkSent = true;
    await load();
    return true;
  }

  void clearSaveError() {
    if (saveError == null) return;
    saveError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
