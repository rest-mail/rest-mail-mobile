import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the app keeps what it remembers between launches: the session and
/// the settings. Small strings only.
abstract interface class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// The Keychain on iOS and the Keystore-backed store on Android.
class SecureKeyValueStore implements KeyValueStore {
  SecureKeyValueStore()
    : _storage = const FlutterSecureStorage(
        // Readable after the first unlock since boot, not only while the phone
        // is unlocked, so a background refresh can still reach the session.
        // Never synced to another device.
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// For tests, and for sample mode, which keeps nothing between launches.
class MemoryKeyValueStore implements KeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}
