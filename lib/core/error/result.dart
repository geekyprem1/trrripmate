import 'package:tripmate/core/error/failure.dart';

/// A functional result type returned by all repository mutations
/// (Architecture §12/§13, CLAUDE.md §6). Success carries [T]; failure carries a
/// typed [Failure]. Control flow never relies on thrown exceptions across the
/// repository boundary.
sealed class Result<T> {
  const Result();

  /// Wraps a successful value.
  const factory Result.success(T value) = Success<T>;

  /// Wraps a typed failure.
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  /// Whether this result represents success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result represents a failure.
  bool get isFailure => this is ResultFailure<T>;

  /// The success value, or `null` when this is a failure.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        ResultFailure<T>() => null,
      };

  /// The failure, or `null` when this is a success.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        ResultFailure<T>(:final failure) => failure,
      };

  /// Pattern-matches both arms into a single value of type [R].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      ResultFailure<T>(:final failure) => onFailure(failure),
    };
  }

  /// Transforms the success value, preserving any failure.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Result.success(transform(value)),
      ResultFailure<T>(:final failure) => Result.failure(failure),
    };
  }
}

/// Success arm of [Result].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Failure arm of [Result].
final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;
}
