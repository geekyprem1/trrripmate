import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/entities/invitation.dart';
import 'package:tripmate/features/members/domain/repositories/member_repository.dart';

part 'invite_controller.g.dart';

/// Generates an invitation for the Invite sheet (UI/UX §3.12, PRD REQ-MEM-01).
@riverpod
class InviteController extends _$InviteController {
  @override
  AsyncValue<Invitation?> build() => const AsyncValue.data(null);

  Future<void> generate(String tripId, {InviteTarget? target}) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(memberRepositoryProvider)
        .createInvite(tripId: tripId, target: target);
    state = result.fold(
      onSuccess: AsyncValue.data,
      onFailure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
