import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tripmate/core/entitlement/premium_gate.dart';

/// Persists the entitlement flag locally so gating is correct offline on a cold
/// start (PRD §12 — entitlement persists). Tier is not a secret, but reusing the
/// app's encrypted store keeps one storage surface.
class EntitlementLocalSource {
  EntitlementLocalSource(this._storage);

  final FlutterSecureStorage _storage;

  Future<bool> readIsPremium() async {
    return (await _storage.read(key: premiumCacheKey)) == 'true';
  }

  Future<void> writeIsPremium({required bool isPremium}) {
    return _storage.write(key: premiumCacheKey, value: '$isPremium');
  }
}
