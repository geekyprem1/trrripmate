import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';

class _MockSyncQueueDao extends Mock implements SyncQueueDao {}

class _FakeHandler implements SyncHandler {
  _FakeHandler(this._onPush);

  final Future<void> Function(SyncQueueRow item) _onPush;

  @override
  String get entityType => 'trip';

  @override
  Future<void> push(SyncQueueRow item) => _onPush(item);
}

SyncQueueRow _item({int attemptCount = 0}) {
  return SyncQueueRow(
    id: 'q1',
    entityType: 'trip',
    entityId: 't1',
    operation: 'create',
    payload: '{}',
    attemptCount: attemptCount,
    status: 'queued',
    createdAt: DateTime(2026, 7),
  );
}

void main() {
  late _MockSyncQueueDao queueDao;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    queueDao = _MockSyncQueueDao();
    when(() => queueDao.remove(any())).thenAnswer((_) async {});
    when(
      () => queueDao.markFailed(
        id: any(named: 'id'),
        attemptCount: any(named: 'attemptCount'),
        nextAttemptAt: any(named: 'nextAttemptAt'),
      ),
    ).thenAnswer((_) async {});
  });

  SyncEngine engineWith(SyncHandler handler) {
    return SyncEngine(
      queueDao: queueDao,
      handlers: [handler],
      logger: AppLogger('off'),
      clock: () => DateTime(2026, 7),
    );
  }

  test('removes the item from the queue on successful push', () async {
    when(() => queueDao.dueItems(any())).thenAnswer((_) async => [_item()]);
    final engine = engineWith(_FakeHandler((_) async {}));

    await engine.requestSync();

    verify(() => queueDao.remove('q1')).called(1);
    verifyNever(
      () => queueDao.markFailed(
        id: any(named: 'id'),
        attemptCount: any(named: 'attemptCount'),
        nextAttemptAt: any(named: 'nextAttemptAt'),
      ),
    );
  });

  test('schedules a retry with incremented attempt on failure', () async {
    when(() => queueDao.dueItems(any())).thenAnswer((_) async => [_item()]);
    final engine = engineWith(
      _FakeHandler((_) async => throw Exception('network')),
    );

    await engine.requestSync();

    verify(
      () => queueDao.markFailed(
        id: 'q1',
        attemptCount: 1,
        nextAttemptAt: any(named: 'nextAttemptAt'),
      ),
    ).called(1);
    verifyNever(() => queueDao.remove(any()));
  });
}
