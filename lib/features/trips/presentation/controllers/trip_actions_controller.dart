import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';

part 'trip_actions_controller.g.dart';

/// Archive / unarchive / delete actions for a trip (UI/UX §3.5/§3.7/§3.17).
/// Returns the [Failure] on error (null on success) so callers can show a
/// targeted message while the list updates reactively.
@riverpod
class TripActionsController extends _$TripActionsController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> setArchived(String id, {required bool archived}) async {
    final result = await ref
        .read(tripRepositoryProvider)
        .setArchived(id: id, archived: archived);
    return result.failureOrNull;
  }

  Future<Failure?> delete(String id) async {
    final result = await ref.read(tripRepositoryProvider).deleteTrip(id);
    return result.failureOrNull;
  }
}
