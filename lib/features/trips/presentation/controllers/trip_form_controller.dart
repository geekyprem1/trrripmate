import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';
import 'package:tripmate/features/trips/domain/repositories/trip_repository.dart';

part 'trip_form_controller.g.dart';

/// Drives the Create / Edit Trip form (UI/UX §3.6). Holds the submit
/// [AsyncValue]; returns `true` so the screen can pop on success.
@riverpod
class TripFormController extends _$TripFormController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({required TripDraft draft, String? tripId}) async {
    state = const AsyncValue.loading();
    final repo = ref.read(tripRepositoryProvider);
    final result = tripId == null
        ? await repo.createTrip(draft)
        : await repo.updateTrip(tripId, draft);
    return result.fold(
      onSuccess: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      onFailure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
    );
  }
}
