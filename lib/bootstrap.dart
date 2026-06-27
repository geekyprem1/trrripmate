import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/app/app.dart';
import 'package:tripmate/core/config/app_config.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/core/storage/secure_local_storage.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/settlement/data/settlement_providers.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';

/// Composition root (Architecture §1). Initializes infrastructure inside a
/// guarded zone, then runs the app with [AppConfig] injected into Riverpod.
Future<void> bootstrap() async {
  final config = AppConfig.fromEnvironment();
  final logger = AppLogger(config.logLevel);

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Global Flutter error sink (CLAUDE.md §6).
      FlutterError.onError = (details) {
        logger.error(
          'flutter',
          details.exceptionAsString(),
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      await _initSupabase(config);

      void runTripMateApp() => runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            // Register feature sync handlers with the engine (Architecture §6).
            syncHandlersProvider.overrideWith(
              (ref) => <SyncHandler>[
                ref.watch(tripSyncHandlerProvider),
                ref.watch(expenseSyncHandlerProvider),
                ref.watch(settlementSyncHandlerProvider),
              ],
            ),
          ],
          child: const TripMateApp(),
        ),
      );

      if (config.sentryDsn.isNotEmpty) {
        await SentryFlutter.init(
          (options) => options
            ..dsn = config.sentryDsn
            ..environment = config.flavor.name,
          appRunner: runTripMateApp,
        );
      } else {
        runTripMateApp();
      }
    },
    (error, stack) {
      logger.error('zone', 'Uncaught error', error: error, stackTrace: stack);
    },
  );
}

Future<void> _initSupabase(AppConfig config) async {
  // Offline-first: when credentials are absent (e.g. local widget runs) the app
  // still boots; network-bound actions surface a configuration failure.
  if (!config.hasBackendCredentials) return;

  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  await Supabase.initialize(
    url: config.supabaseUrl,
    // The Supabase anon key is the client-side publishable key.
    publishableKey: config.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      // PKCE is the default flow; storage adapters keep tokens encrypted.
      localStorage: SecureLocalStorage(storage),
      pkceAsyncStorage: SecureGotrueAsyncStorage(storage),
    ),
  );
}
