import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase access for entitlement (API §2). Reads the server-authoritative tier
/// and applies a verified purchase via an Edge Function (privileged receipt
/// verification + service-role write live there — CLAUDE.md §12/§13). Only this
/// source touches the SDK.
class EntitlementRemoteDataSource {
  EntitlementRemoteDataSource(this._client);

  static const _table = 'profiles';

  final SupabaseClient _client;

  /// Reads the current user's tier; true when `premium`.
  Future<bool> fetchIsPremium(String userId) async {
    final row = await _client
        .from(_table)
        .select('tier')
        .eq('id', userId)
        .maybeSingle();
    return (row?['tier'] as String?) == 'premium';
  }

  /// Submits a store purchase to the `apply-entitlement` Edge Function, which
  /// verifies the receipt and sets `profiles.tier`. Throws on failure.
  Future<void> applyEntitlement({
    required String productId,
    required String purchaseToken,
  }) async {
    await _client.functions.invoke(
      'apply-entitlement',
      body: {'product_id': productId, 'purchase_token': purchaseToken},
    );
  }
}
