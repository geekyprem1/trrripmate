import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/premium/data/datasources/entitlement_local_source.dart';
import 'package:tripmate/features/premium/data/datasources/entitlement_remote_data_source.dart';
import 'package:tripmate/features/premium/data/datasources/fake_billing_service.dart';
import 'package:tripmate/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:tripmate/features/premium/domain/entities/entitlement.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockRemoteDataSource extends Mock
    implements EntitlementRemoteDataSource {}

class _MockLocalSource extends Mock implements EntitlementLocalSource {}

void main() {
  late _MockAuthRepository auth;
  late _MockRemoteDataSource remote;
  late _MockLocalSource local;
  late PremiumRepositoryImpl repo;

  // Tracks entitlement changes pushed to the cross-cutting gate.
  final gateValues = <bool>[];

  setUp(() {
    gateValues.clear();
    auth = _MockAuthRepository();
    remote = _MockRemoteDataSource();
    local = _MockLocalSource();

    when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u1'));
    when(() => local.readIsPremium()).thenAnswer((_) async => false);
    when(() => local.writeIsPremium(isPremium: any(named: 'isPremium')))
        .thenAnswer((_) async {});
    when(() => remote.fetchIsPremium(any())).thenAnswer((_) async => false);

    repo = PremiumRepositoryImpl(
      billing: const FakeBillingService(),
      remote: remote,
      local: local,
      authRepository: auth,
      logger: AppLogger('off'),
      onEntitlementChanged: ({required isPremium}) =>
          gateValues.add(isPremium),
    );
  });

  // -------------------------------------------------------------------------
  // hydrate
  // -------------------------------------------------------------------------
  group('hydrate', () {
    test('seeds from cache then refreshes from server', () async {
      when(() => local.readIsPremium()).thenAnswer((_) async => false);
      when(() => remote.fetchIsPremium('u1')).thenAnswer((_) async => true);

      await repo.hydrate();

      // Two calls to _apply: cache seed (false) then server refresh (true).
      expect(gateValues, [false, true]);
      expect(repo.current.isPremium, isTrue);
    });

    test('keeps cached entitlement when server is unreachable (offline)', () async {
      when(() => local.readIsPremium()).thenAnswer((_) async => true);
      when(() => remote.fetchIsPremium(any()))
          .thenThrow(Exception('offline'));

      await repo.hydrate();

      // Only the cache seed fires; server error is swallowed.
      expect(gateValues, [true]);
      expect(repo.current.isPremium, isTrue);
    });

    test('skips server refresh when no user is signed in', () async {
      when(() => auth.currentUser).thenReturn(null);
      when(() => local.readIsPremium()).thenAnswer((_) async => false);

      await repo.hydrate();

      // Cache seed fires; server fetch is skipped.
      expect(gateValues, [false]);
      verifyNever(() => remote.fetchIsPremium(any()));
    });
  });

  // -------------------------------------------------------------------------
  // purchase
  // -------------------------------------------------------------------------
  group('purchase', () {
    test('applies entitlement and flips gate on success', () async {
      when(() => remote.applyEntitlement(
            productId: any(named: 'productId'),
            purchaseToken: any(named: 'purchaseToken'),
          )).thenAnswer((_) async {});

      final outcome = await repo.purchase('premium_monthly');

      expect(outcome, isA<PurchaseSuccess>());
      expect(repo.current.isPremium, isTrue);
      expect(gateValues.last, isTrue);
      verify(() => local.writeIsPremium(isPremium: true)).called(1);
    });

    test('returns failure when server verification fails', () async {
      when(() => remote.applyEntitlement(
            productId: any(named: 'productId'),
            purchaseToken: any(named: 'purchaseToken'),
          )).thenThrow(Exception('server error'));

      final outcome = await repo.purchase('premium_monthly');

      expect(outcome, isA<PurchaseFailed>());
      // Gate must NOT flip on verification failure.
      expect(gateValues.where((v) => v), isEmpty);
    });

    test('propagates cancelled outcome without touching entitlement', () async {
      final cancelledRepo = PremiumRepositoryImpl(
        billing: const FakeBillingService(
          purchaseOutcome: PurchaseOutcome.cancelled(),
        ),
        remote: remote,
        local: local,
        authRepository: auth,
        logger: AppLogger('off'),
      );

      final outcome = await cancelledRepo.purchase('premium_monthly');

      expect(outcome, isA<PurchaseCancelled>());
      verifyNever(() => remote.applyEntitlement(
            productId: any(named: 'productId'),
            purchaseToken: any(named: 'purchaseToken'),
          ));
    });

    test('returns failed outcome when store is unavailable', () async {
      final unavailableRepo = PremiumRepositoryImpl(
        billing: const FakeBillingService(available: false),
        remote: remote,
        local: local,
        authRepository: auth,
        logger: AppLogger('off'),
      );

      final outcome = await unavailableRepo.purchase('premium_monthly');

      expect(outcome, isA<PurchaseFailed>());
    });
  });

  // -------------------------------------------------------------------------
  // restore
  // -------------------------------------------------------------------------
  group('restore', () {
    test('refreshes from server when nothing to restore', () async {
      when(() => remote.fetchIsPremium('u1')).thenAnswer((_) async => true);

      final outcome = await repo.restore();

      expect(outcome, isA<PurchaseNothingToRestore>());
      // Refresh call should have updated the gate.
      expect(gateValues.last, isTrue);
    });

    test('applies entitlement when restore succeeds', () async {
      final restoreRepo = PremiumRepositoryImpl(
        billing: const FakeBillingService(
          restoreOutcome: PurchaseOutcome.success(
            productId: 'premium_yearly',
            purchaseToken: 'restore-token',
          ),
        ),
        remote: remote,
        local: local,
        authRepository: auth,
        logger: AppLogger('off'),
        onEntitlementChanged: ({required isPremium}) =>
            gateValues.add(isPremium),
      );
      when(() => remote.applyEntitlement(
            productId: any(named: 'productId'),
            purchaseToken: any(named: 'purchaseToken'),
          )).thenAnswer((_) async {});

      final outcome = await restoreRepo.restore();

      expect(outcome, isA<PurchaseSuccess>());
      expect(gateValues.last, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // watchEntitlement stream
  // -------------------------------------------------------------------------
  group('watchEntitlement', () {
    test('yields current entitlement then emits updates', () async {
      when(() => local.readIsPremium()).thenAnswer((_) async => false);
      when(() => remote.fetchIsPremium('u1')).thenAnswer((_) async => true);
      when(() => remote.applyEntitlement(
            productId: any(named: 'productId'),
            purchaseToken: any(named: 'purchaseToken'),
          )).thenAnswer((_) async {});

      final stream = repo.watchEntitlement();
      final emissions = <Entitlement>[];
      final sub = stream.listen(emissions.add);

      await repo.hydrate();
      await Future<void>.delayed(Duration.zero);

      expect(emissions.any((e) => e.isPremium), isTrue);

      await sub.cancel();
      await repo.dispose();
    });
  });
}
