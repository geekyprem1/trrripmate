import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/settlement/data/settlement_providers.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';

part 'settlement_actions_controller.g.dart';

/// Mark-settlement-paid action (UI/UX §3.14). Returns the [Failure] on error
/// (null on success); the settlement view updates reactively. While the build
/// is loading the row's action is disabled, preventing double-marking.
@riverpod
class SettlementActionsController extends _$SettlementActionsController {
  @override
  Future<void> build() async {}

  Future<Failure?> markPaid(Settlement transaction) async {
    state = const AsyncLoading();
    final result =
        await ref.read(settlementRepositoryProvider).markPaid(transaction);
    state = const AsyncData(null);
    return result.failureOrNull;
  }
}
