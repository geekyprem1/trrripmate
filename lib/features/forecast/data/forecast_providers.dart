import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/forecast/data/datasources/forecast_dao.dart';
import 'package:tripmate/features/forecast/data/repositories/forecast_repository_impl.dart';
import 'package:tripmate/features/forecast/domain/entities/forecast_item.dart';
import 'package:tripmate/features/forecast/domain/repositories/forecast_repository.dart';

part 'forecast_providers.g.dart';

@Riverpod(keepAlive: true)
ForecastDao forecastDao(Ref ref) => ForecastDao(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ForecastRepository forecastRepository(Ref ref) =>
    ForecastRepositoryImpl(ref.watch(forecastDaoProvider));

@riverpod
Stream<List<ForecastItem>> forecastItems(Ref ref, String tripId) =>
    ref.watch(forecastRepositoryProvider).watchItems(tripId);
