import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/members/presentation/controllers/member_actions_controller.dart';
import 'package:tripmate/features/members/presentation/widgets/invite_sheet.dart';
import 'package:tripmate/features/members/presentation/widgets/member_tile.dart';

/// Members & Invite screen (UI/UX §3.12, PRD REQ-MEM-01/03).
class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({required this.tripId, super.key});

  final String tripId;

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(memberRepositoryProvider).refreshMembers(widget.tripId),
    );
  }

  void _openInvite() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => InviteSheet(tripId: widget.tripId),
    );
  }

  Future<void> _confirmRemove(Member member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text(
          '${member.displayName ?? 'This member'} will lose access to the trip.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;

    final failure = await ref
        .read(memberActionsControllerProvider.notifier)
        .remove(tripId: widget.tripId, memberId: member.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(failure?.displayMessage ?? 'Member removed')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(tripMembersProvider(widget.tripId));
    final currentUserId = ref.watch(authStateProvider).valueOrNull?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: membersAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
          onRetry: () =>
              ref.read(memberRepositoryProvider).refreshMembers(widget.tripId),
        ),
        data: (members) {
          final isOwner = members.any(
            (m) => m.userId == currentUserId && m.isOwner,
          );
          return Column(
            children: [
              Expanded(
                child: members.isEmpty
                    ? const AppEmptyView(
                        icon: Icons.group_outlined,
                        message: 'No members yet.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          final isSelf = member.userId == currentUserId;
                          final canRemove =
                              isOwner && !isSelf && !member.isOwner;
                          return MemberTile(
                            member: member,
                            isCurrentUser: isSelf,
                            canRemove: canRemove,
                            onRemove: () => _confirmRemove(member),
                          );
                        },
                      ),
              ),
              if (isOwner)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: FilledButton.icon(
                    onPressed: _openInvite,
                    icon: const Icon(Icons.person_add_alt),
                    label: const Text('Invite member'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
