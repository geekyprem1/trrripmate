import 'package:tripmate/core/logging/app_logger.dart';

/// Product analytics sink (Architecture §14, PRD §14). Distinct from logging
/// (diagnostics) and crash reporting. Events carry IDs/enums only — NEVER PII
/// (CLAUDE.md §13).
abstract interface class AnalyticsService {
  /// Records a named event with optional non-PII properties.
  void logEvent(String name, {Map<String, Object?> properties});
}

/// Default v1.0 implementation: routes events to the structured logger. A
/// production pipeline (e.g. a hosted analytics SDK) plugs in behind this
/// interface without touching callers.
class LoggingAnalyticsService implements AnalyticsService {
  const LoggingAnalyticsService(this._logger);

  static const _tag = 'analytics';

  final AppLogger _logger;

  @override
  void logEvent(String name, {Map<String, Object?> properties = const {}}) {
    _logger.info(_tag, 'event=$name props=$properties');
  }
}

/// Canonical event names (PRD §14). Centralized so call sites can't drift.
abstract final class AnalyticsEvents {
  static const premiumViewed = 'premium_viewed';
  static const subscriptionPurchased = 'subscription_purchased';
}
