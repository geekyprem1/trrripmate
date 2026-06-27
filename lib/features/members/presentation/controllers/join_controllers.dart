import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/entities/invitation.dart';

part 'join_controllers.g.dart';

/// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
/// carries the typed `Failure` for display.
@riverpod
Future<InvitePreview> invitePreview(Ref ref, String code) async {
  final result = await ref.watch(memberRepositoryProvider).previewInvite(code);
  return result.fold(
    onSuccess: (preview) => preview,
    // Surfaced as AsyncError; the screen renders the typed failure's message.
    // ignore: only_throw_errors
    onFailure: (failure) => throw failure,
  );
}

/// Accept / reject actions for the Join screen (PRD REQ-MEM-02).
@riverpod
class JoinController extends _$JoinController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Accepts the invite; returns the joined trip id (null on failure).
  Future<String?> accept(String code) async {
    state = const AsyncValue.loading();
    final result = await ref.read(memberRepositoryProvider).acceptInvite(code);
    return result.fold(
      onSuccess: (tripId) {
        state = const AsyncValue.data(null);
        return tripId;
      },
      onFailure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }

  Future<bool> reject(String code) async {
    state = const AsyncValue.loading();
    final result = await ref.read(memberRepositoryProvider).rejectInvite(code);
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
