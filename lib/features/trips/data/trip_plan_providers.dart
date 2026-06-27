import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/trips/data/datasources/trip_plan_dao.dart';
import 'package:uuid/uuid.dart';

part 'trip_plan_providers.g.dart';

@Riverpod(keepAlive: true)
TripPlanDao tripPlanDao(Ref ref) =>
    TripPlanDao(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<TripPlanItemRow>> tripPlanItems(Ref ref, String tripId) =>
    ref.watch(tripPlanDaoProvider).watchByTrip(tripId);

class TripPlanService {
  TripPlanService(this._dao);
  final TripPlanDao _dao;
  final _uuid = const Uuid();

  Future<void> addItem({
    required String tripId,
    required String name,
    required int estimatedAmountMinor,
    String? category,
  }) =>
      _dao.insert(TripPlanItemsCompanion.insert(
        id: _uuid.v4(),
        tripId: tripId,
        name: name,
        category: Value(category),
        estimatedAmountMinor: estimatedAmountMinor,
        createdAt: DateTime.now(),
      ));

  Future<void> deleteItem(String id) => _dao.deleteById(id);
  Future<void> clearAll(String tripId) => _dao.deleteAllForTrip(tripId);
}

@Riverpod(keepAlive: true)
TripPlanService tripPlanService(Ref ref) =>
    TripPlanService(ref.watch(tripPlanDaoProvider));
