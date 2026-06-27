import 'dart:async';

import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';

/// Drains the offline write queue to the backend (Architecture §6, CLAUDE.md
/// §14). FIFO, retry with exponential backoff; failures never block the UI.
class SyncEngine {
  SyncEngine({
    required SyncQueueDao queueDao,
    required List<SyncHandler> handlers,
    required AppLogger logger,
    Stream<bool>? onlineStream,
    DateTime Function()? clock,
  })  : _queueDao = queueDao,
        _logger = logger,
        _clock = clock ?? DateTime.now,
        _handlers = {for (final h in handlers) h.entityType: h} {
    if (onlineStream != null) {
      _onlineSub = onlineStream.listen((isOnline) {
        if (isOnline) unawaited(requestSync());
      });
    }
  }

  static const _tag = 'sync';
  static const _maxAttempts = 5;

  // Backoff schedule by attempt number (Architecture §6): 2s, 8s, 30s, 2m, 5m.
  static const _backoff = <Duration>[
    Duration(seconds: 2),
    Duration(seconds: 8),
    Duration(seconds: 30),
    Duration(minutes: 2),
    Duration(minutes: 5),
  ];

  final SyncQueueDao _queueDao;
  final Map<String, SyncHandler> _handlers;
  final AppLogger _logger;
  final DateTime Function() _clock;

  StreamSubscription<bool>? _onlineSub;
  bool _isDraining = false;
  bool _rerunRequested = false;

  /// Requests a queue drain. Safe to call frequently — concurrent calls
  /// collapse into a single pass with a follow-up if needed.
  Future<void> requestSync() async {
    if (_isDraining) {
      _rerunRequested = true;
      return;
    }
    _isDraining = true;
    try {
      await _drainOnce();
      while (_rerunRequested) {
        _rerunRequested = false;
        await _drainOnce();
      }
    } finally {
      _isDraining = false;
    }
  }

  Future<void> _drainOnce() async {
    final now = _clock();
    final items = await _queueDao.dueItems(now);
    for (final item in items) {
      final handler = _handlers[item.entityType];
      if (handler == null) {
        _logger.warning(_tag, 'no handler for ${item.entityType}; skipping');
        continue;
      }
      try {
        await handler.push(item);
        await _queueDao.remove(item.id);
      } catch (error, stackTrace) {
        await _scheduleRetry(item.id, item.attemptCount, error, stackTrace);
      }
    }
  }

  Future<void> _scheduleRetry(
    String id,
    int previousAttempts,
    Object error,
    StackTrace stackTrace,
  ) async {
    final attempts = previousAttempts + 1;
    if (attempts >= _maxAttempts) {
      _logger.error(
        _tag,
        'permanent failure after $attempts attempts ($id)',
        error: error,
        stackTrace: stackTrace,
      );
      // Park far in the future; surfaced to the user via pending/failed badge.
      await _queueDao.markFailed(
        id: id,
        attemptCount: attempts,
        nextAttemptAt: _clock().add(const Duration(days: 3650)),
      );
      return;
    }
    final delay = _backoff[(attempts - 1).clamp(0, _backoff.length - 1)];
    _logger.warning(_tag, 'retry $attempts for $id in ${delay.inSeconds}s');
    await _queueDao.markFailed(
      id: id,
      attemptCount: attempts,
      nextAttemptAt: _clock().add(delay),
    );
  }

  Future<void> dispose() async {
    await _onlineSub?.cancel();
  }
}
