import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/network/connectivity_service.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';

part 'sync_providers.g.dart';

@Riverpod(keepAlive: true)
SyncQueueDao syncQueueDao(Ref ref) {
  return SyncQueueDao(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  return ConnectivityService();
}

/// Extension point for feature sync handlers (Architecture §6). Core declares
/// it empty; the composition root (bootstrap) overrides it to register each
/// feature's handler — keeping `core/` independent of `features/`.
@Riverpod(keepAlive: true)
List<SyncHandler> syncHandlers(Ref ref) => const [];

/// The single sync engine instance, wired with the registered handlers and a
/// connectivity-driven retry trigger.
@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final engine = SyncEngine(
    queueDao: ref.watch(syncQueueDaoProvider),
    handlers: ref.watch(syncHandlersProvider),
    logger: ref.watch(appLoggerProvider),
    onlineStream: ref.watch(connectivityServiceProvider).onlineChanges,
  );
  ref.onDispose(engine.dispose);
  return engine;
}
