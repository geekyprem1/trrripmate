// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_gate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initialPremiumHash() => r'25e64837a4af3e525bc19b6f8042f6f1e6981019';

/// Seed value for [premiumGate], read from the local cache at bootstrap so the
/// gate is correct offline on a cold start. Overridden in the composition root;
/// defaults to free.
///
/// Copied from [initialPremium].
@ProviderFor(initialPremium)
final initialPremiumProvider = Provider<bool>.internal(
  initialPremium,
  name: r'initialPremiumProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initialPremiumHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitialPremiumRef = ProviderRef<bool>;
String _$premiumGateHash() => r'53611fdab20446404faa2fd75db3ad13cf95796c';

/// Cross-cutting "is the user Premium?" flag (PRD §12). Core owns it as a plain
/// reactive bool so any feature can gate on it without depending on the
/// `premium` feature; the premium feature is the sole writer. Seeded from the
/// offline cache via [initialPremium].
///
/// Copied from [PremiumGate].
@ProviderFor(PremiumGate)
final premiumGateProvider = NotifierProvider<PremiumGate, bool>.internal(
  PremiumGate.new,
  name: r'premiumGateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$premiumGateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PremiumGate = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
