import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/entitlement/premium_gate.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/premium/data/datasources/entitlement_local_source.dart';
import 'package:tripmate/features/premium/data/datasources/entitlement_remote_data_source.dart';
import 'package:tripmate/features/premium/data/datasources/fake_billing_service.dart';
import 'package:tripmate/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:tripmate/features/premium/domain/billing_service.dart';
import 'package:tripmate/features/premium/domain/entities/entitlement.dart';
import 'package:tripmate/features/premium/domain/entities/premium_plan.dart';
import 'package:tripmate/features/premium/domain/repositories/premium_repository.dart';

part 'premium_providers.g.dart';

/// The store adapter. v1.0 ships the dev fake; the production `in_app_purchase`
/// adapter overrides this in the composition root (Architecture §7).
@Riverpod(keepAlive: true)
BillingService billingService(Ref ref) => const FakeBillingService();

@Riverpod(keepAlive: true)
EntitlementRemoteDataSource entitlementRemoteDataSource(Ref ref) {
  return EntitlementRemoteDataSource(ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
EntitlementLocalSource entitlementLocalSource(Ref ref) {
  return EntitlementLocalSource(ref.watch(secureStorageProvider));
}

@Riverpod(keepAlive: true)
PremiumRepository premiumRepository(Ref ref) {
  final repository = PremiumRepositoryImpl(
    billing: ref.watch(billingServiceProvider),
    remote: ref.watch(entitlementRemoteDataSourceProvider),
    local: ref.watch(entitlementLocalSourceProvider),
    authRepository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
    // Keep the cross-cutting gate (trips quota, export) in sync.
    onEntitlementChanged: ({required isPremium}) =>
        ref.read(premiumGateProvider.notifier).set(isPremium: isPremium),
  );
  // Seed from cache + refresh from the server once on first read.
  unawaited(repository.hydrate());
  ref.onDispose(repository.dispose);
  return repository;
}

/// Reactive entitlement for Settings/Paywall UI.
@riverpod
Stream<Entitlement> entitlement(Ref ref) {
  return ref.watch(premiumRepositoryProvider).watchEntitlement();
}

/// Store-localized plans for the paywall.
@riverpod
Future<List<PremiumPlan>> premiumPlans(Ref ref) {
  return ref.watch(premiumRepositoryProvider).plans();
}
