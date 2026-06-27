import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'premium_gate.g.dart';

/// Secure-storage key for the cached entitlement flag (offline-first gating).
const premiumCacheKey = 'tripmate.premium';

/// Seed value for [premiumGate], read from the local cache at bootstrap so the
/// gate is correct offline on a cold start. Overridden in the composition root;
/// defaults to free.
@Riverpod(keepAlive: true)
bool initialPremium(Ref ref) => false;

/// Cross-cutting "is the user Premium?" flag (PRD §12). Core owns it as a plain
/// reactive bool so any feature can gate on it without depending on the
/// `premium` feature; the premium feature is the sole writer. Seeded from the
/// offline cache via [initialPremium].
@Riverpod(keepAlive: true)
class PremiumGate extends _$PremiumGate {
  @override
  bool build() => ref.watch(initialPremiumProvider);

  // ignore: use_setters_to_change_properties
  void set({required bool isPremium}) => state = isPremium;
}
