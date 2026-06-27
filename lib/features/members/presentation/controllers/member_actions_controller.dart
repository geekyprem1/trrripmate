import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/members/data/member_providers.dart';

part 'member_actions_controller.g.dart';

/// Member management actions (UI/UX §3.12, PRD REQ-MEM-03). Returns the
/// [Failure] on error (null on success) so the screen can show a targeted
/// message (e.g. dues-blocked removal) while the roster updates reactively.
@riverpod
class MemberActionsController extends _$MemberActionsController {
  @override
  Future<void> build() async {}

  Future<Failure?> remove({
    required String tripId,
    required String memberId,
  }) async {
    final result = await ref
        .read(memberRepositoryProvider)
        .removeMember(tripId: tripId, memberId: memberId);
    return result.failureOrNull;
  }
}
