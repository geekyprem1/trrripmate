import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Structured, level-gated logger (Architecture §14, CLAUDE.md §13).
///
/// Never log PII or secrets — IDs and domain tags only. Tag logs by domain
/// (`auth`, `sync`, `realtime`, `ai`) via the `tag` argument.
class AppLogger {
  AppLogger(String level) : _logger = _build(level);

  final Logger _logger;

  static Logger _build(String level) {
    return Logger(
      level: _levelFromName(level),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 6,
        lineLength: 100,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  static Level _levelFromName(String name) {
    return switch (name.toLowerCase()) {
      'trace' || 'verbose' => Level.trace,
      'debug' => Level.debug,
      'info' => Level.info,
      'warning' || 'warn' => Level.warning,
      'error' => Level.error,
      'off' || 'none' => Level.off,
      _ => Level.debug,
    };
  }

  void debug(String tag, String message) => _logger.d('[$tag] $message');

  void info(String tag, String message) => _logger.i('[$tag] $message');

  void warning(String tag, String message) => _logger.w('[$tag] $message');

  void error(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e('[$tag] $message', error: error, stackTrace: stackTrace);
    Sentry.captureException(
      error ?? Exception(message),
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('domain', tag);
      },
    );
  }
}
