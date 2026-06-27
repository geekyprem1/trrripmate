import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Typed failure hierarchy crossing the repository boundary (Architecture §13,
/// CLAUDE.md §6). No exceptions cross repositories — every mutation returns a
/// `Result` whose error arm is one of these variants.
@freezed
sealed class Failure with _$Failure {
  /// No connectivity / transport error. Offline is NOT a failure on its own;
  /// this is for genuine network errors during an online operation.
  const factory Failure.network({
    @Default('No internet connection.') String message,
  }) = NetworkFailure;

  /// Authentication problem (invalid credentials, expired session, bad OTP).
  const factory Failure.auth({
    required String message,
    String? code,
  }) = AuthFailure;

  /// The caller lacks permission for the action (RLS/role denied).
  const factory Failure.permission({
    @Default('You do not have permission for this action.') String message,
  }) = PermissionFailure;

  /// Input failed validation before or after hitting the backend.
  const factory Failure.validation({
    required String message,
    String? field,
  }) = ValidationFailure;

  /// Optimistic-concurrency / sync conflict.
  const factory Failure.conflict({
    @Default('This item changed elsewhere. Please retry.') String message,
  }) = ConflictFailure;

  /// Object storage error (receipt upload/download).
  const factory Failure.storage({
    required String message,
  }) = StorageFailure;

  /// Free-tier / plan quota exceeded.
  const factory Failure.quota({
    required String message,
  }) = QuotaFailure;

  /// AI subsystem failure (v1.5). Always falls back gracefully.
  const factory Failure.ai({
    @Default('AI is unavailable right now.') String message,
  }) = AiFailure;

  /// Backend configuration missing (e.g. no Supabase credentials).
  const factory Failure.configuration({
    required String message,
  }) = ConfigurationFailure;

  /// Unexpected, unclassified error.
  const factory Failure.unknown({
    @Default('Something went wrong. Please try again.') String message,
  }) = UnknownFailure;
}

/// Convenience accessor for the user-facing message of any [Failure].
extension FailureMessage on Failure {
  String get displayMessage => switch (this) {
        NetworkFailure(:final message) => message,
        AuthFailure(:final message) => message,
        PermissionFailure(:final message) => message,
        ValidationFailure(:final message) => message,
        ConflictFailure(:final message) => message,
        StorageFailure(:final message) => message,
        QuotaFailure(:final message) => message,
        AiFailure(:final message) => message,
        ConfigurationFailure(:final message) => message,
        UnknownFailure(:final message) => message,
      };
}
