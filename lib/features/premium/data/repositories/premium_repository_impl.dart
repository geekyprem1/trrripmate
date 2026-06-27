import 'dart:async';

import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/premium/data/datasources/entitlement_local_source.dart';
import 'package:tripmate/features/premium/data/datasources/entitlement_remote_data_source.dart';
import 'package:tripmate/features/premium/domain/billing_service.dart';
import 'package:tripmate/features/premium/domain/entities/entitlement.dart';
import 'package:tripmate/features/premium/domain/entities/premium_plan.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';
import 'package:tripmate/features/premium/domain/repositories/premium_repository.dart';

/// Coordinates the store ([BillingService]), server entitlement, the local
/// cache and the cross-cutting gate (PRD §12). Purchases verify server-side
/// before the tier flips; the cache keeps gating correct offline.
class PremiumRepositoryImpl implements PremiumRepository {
  PremiumRepositoryImpl({
    required BillingService billing,
    required EntitlementRemoteDataSource remote,
    required EntitlementLocalSource local,
    required AuthRepository authRepository,
    required AppLogger logger,
    void Function({required bool isPremium})? onEntitlementChanged,
  })  : _billing = billing,
        _remote = remote,
        _local = local,
        _auth = authRepository,
        _logger = logger,
        _onChanged = onEntitlementChanged;

  static const _tag = 'premium';

  final BillingService _billing;
  final EntitlementRemoteDataSource _remote;
  final EntitlementLocalSource _local;
  final AuthRepository _auth;
  final AppLogger _logger;
  final void Function({required bool isPremium})? _onChanged;

  final StreamController<Entitlement> _controller =
      StreamController<Entitlement>.broadcast();
  Entitlement _current = Entitlement.free;

  @override
  Entitlement get current => _current;

  @override
  Stream<Entitlement> watchEntitlement() async* {
    yield _current;
    yield* _controller.stream;
  }

  /// Seeds [current] from the local cache (offline-correct), then refreshes from
  /// the server in the background. Called once at startup.
  Future<void> hydrate() async {
    final cached = await _local.readIsPremium();
    _apply(Entitlement(isPremium: cached));
    await refresh();
  }

  @override
  Future<void> refresh() async {
    final userId = _auth.currentUser?.id;
    if (userId == null) return;
    try {
      final isPremium = await _remote.fetchIsPremium(userId);
      await _persist(Entitlement(isPremium: isPremium));
    } catch (error) {
      // Offline / transient — keep the cached entitlement (not an error).
      _logger.warning(_tag, 'entitlement refresh unavailable: $error');
    }
  }

  @override
  Future<List<PremiumPlan>> plans() => _billing.loadPlans();

  @override
  Future<bool> isStoreAvailable() => _billing.isAvailable();

  @override
  Future<PurchaseOutcome> purchase(String planId) async {
    final outcome = await _billing.purchase(planId);
    if (outcome is! PurchaseSuccess) return outcome;
    return _applyPurchase(outcome, fallbackProductId: planId);
  }

  @override
  Future<PurchaseOutcome> restore() async {
    final outcome = await _billing.restore();
    if (outcome is PurchaseSuccess) {
      return _applyPurchase(outcome, fallbackProductId: outcome.productId ?? '');
    }
    // No local receipt — the server may still hold the entitlement.
    await refresh();
    return outcome;
  }

  /// Verifies a successful purchase server-side, then flips the tier.
  Future<PurchaseOutcome> _applyPurchase(
    PurchaseSuccess success, {
    required String fallbackProductId,
  }) async {
    final productId = success.productId ?? fallbackProductId;
    try {
      await _remote.applyEntitlement(
        productId: productId,
        purchaseToken: success.purchaseToken ?? '',
      );
    } catch (error, stackTrace) {
      _logger.error(_tag, 'entitlement verification failed',
          error: error, stackTrace: stackTrace);
      return const PurchaseOutcome.failed(
        "We couldn't confirm your purchase. Try Restore in a moment.",
      );
    }
    await _persist(Entitlement(isPremium: true, productId: productId));
    return success;
  }

  Future<void> _persist(Entitlement entitlement) async {
    _apply(entitlement);
    await _local.writeIsPremium(isPremium: entitlement.isPremium);
  }

  void _apply(Entitlement entitlement) {
    _current = entitlement;
    _controller.add(entitlement);
    _onChanged?.call(isPremium: entitlement.isPremium);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
