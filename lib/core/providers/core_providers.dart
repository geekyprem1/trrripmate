import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/core/analytics/analytics_service.dart';
import 'package:tripmate/core/config/app_config.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/logging/app_logger.dart';

part 'core_providers.g.dart';

/// The local offline-first database (Architecture §6). Single instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

/// Compile-time application configuration (Architecture §19).
///
/// Overridden in [ProviderScope] at bootstrap so it is available synchronously
/// everywhere.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) {
  throw UnimplementedError('appConfig must be overridden in ProviderScope');
}

/// Structured application logger (Architecture §14).
@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) {
  final config = ref.watch(appConfigProvider);
  return AppLogger(config.logLevel);
}

/// Product analytics sink (PRD §14). Defaults to the logging implementation.
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return LoggingAnalyticsService(ref.watch(appLoggerProvider));
}

/// Encrypted key-value storage for tokens and secrets (CLAUDE.md §13).
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
}

/// The initialized Supabase client.
///
/// `Supabase.initialize` runs once in `bootstrap.dart`; this exposes the
/// singleton client to the data layer only (CLAUDE.md §12).
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}
