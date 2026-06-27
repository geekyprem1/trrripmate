import 'package:freezed_annotation/freezed_annotation.dart';

part 'entitlement.freezed.dart';

/// The user's current Premium entitlement (PRD §12). Source of truth is
/// `profiles.tier` on the server; cached locally for offline gating.
@freezed
class Entitlement with _$Entitlement {
  const factory Entitlement({
    @Default(false) bool isPremium,

    /// The store product that granted entitlement, when known.
    String? productId,
  }) = _Entitlement;

  const Entitlement._();

  /// The default free-tier entitlement.
  static const free = Entitlement();
}
