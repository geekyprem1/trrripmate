import 'package:tripmate/core/config/app_flavor.dart';

/// Typed, compile-time application configuration (Technical Architecture §19).
///
/// All values are injected via `--dart-define`; the rest of the app depends on
/// [AppConfig] and never reads raw environment values (CLAUDE.md §13).
///
/// Example:
/// ```text
/// flutter run \
///   --dart-define=FLAVOR=dev \
///   --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=public-anon-key
/// ```
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.googleServerClientId,
    required this.logLevel,
    required this.sentryDsn,
  });

  /// Builds the configuration from compile-time `--dart-define` values.
  factory AppConfig.fromEnvironment() {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final flavor = AppFlavor.fromName(flavorName);
    return AppConfig(
      flavor: flavor,
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      googleServerClientId:
          const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
      logLevel: String.fromEnvironment(
        'LOG_LEVEL',
        defaultValue: flavor.isProd ? 'warning' : 'debug',
      ),
      sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
    );
  }

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;

  final String googleServerClientId;
  final String logLevel;
  final String sentryDsn;

  /// Whether the backend credentials required to reach Supabase are present.
  ///
  /// When `false`, the app still boots (offline-first, CLAUDE.md §14) but any
  /// network-bound action surfaces a configuration error instead of crashing.
  bool get hasBackendCredentials =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
