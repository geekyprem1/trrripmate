import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists the Supabase auth session in encrypted storage instead of plain
/// shared preferences (CLAUDE.md §13 — tokens MUST live in secure storage).
///
/// Adapts [FlutterSecureStorage] to gotrue's [LocalStorage] contract.
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage(this._storage);

  static const _sessionKey = 'tripmate.auth.session';

  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async {
    return _storage.containsKey(key: _sessionKey);
  }

  @override
  Future<String?> accessToken() {
    return _storage.read(key: _sessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) {
    return _storage.write(key: _sessionKey, value: persistSessionString);
  }

  @override
  Future<void> removePersistedSession() {
    return _storage.delete(key: _sessionKey);
  }
}

/// Stores the PKCE code verifier securely during OAuth flows.
class SecureGotrueAsyncStorage extends GotrueAsyncStorage {
  SecureGotrueAsyncStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getItem({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> setItem({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> removeItem({required String key}) {
    return _storage.delete(key: key);
  }
}
