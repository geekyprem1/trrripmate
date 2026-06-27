import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_outcome.freezed.dart';

/// The result of a store purchase or restore (UI/UX §3.19). Billing has its own
/// rich result type because user cancellation is a normal outcome, not an error
/// — so this stands in for `Result` on the billing path (CLAUDE.md §6).
@freezed
sealed class PurchaseOutcome with _$PurchaseOutcome {
  /// Purchase/restore succeeded; carries the store [productId] and the
  /// [purchaseToken]/receipt to verify server-side.
  const factory PurchaseOutcome.success({
    String? productId,
    String? purchaseToken,
  }) = PurchaseSuccess;

  /// The user dismissed the store sheet — no error to show.
  const factory PurchaseOutcome.cancelled() = PurchaseCancelled;

  /// Payment is pending (e.g. awaiting parental approval).
  const factory PurchaseOutcome.pending() = PurchasePending;

  /// Restore found no prior purchase to apply.
  const factory PurchaseOutcome.nothingToRestore() = PurchaseNothingToRestore;

  /// The store/verification failed; [message] is user-facing.
  const factory PurchaseOutcome.failed(String message) = PurchaseFailed;
}
