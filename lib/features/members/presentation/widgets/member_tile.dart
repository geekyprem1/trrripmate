import 'package:flutter/material.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';

/// A single roster row (UI/UX §3.12). Role is shown with a labelled chip; the
/// remove action is offered only when [canRemove] is true.
class MemberTile extends StatelessWidget {
  const MemberTile({
    required this.member,
    required this.isCurrentUser,
    this.canRemove = false,
    this.onRemove,
    super.key,
  });

  final Member member;
  final bool isCurrentUser;
  final bool canRemove;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = member.displayName ?? 'Member';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        child: Text(initial),
      ),
      title: Text(isCurrentUser ? '$name (You)' : name),
      subtitle: member.isPendingSync ? const Text('Pending sync') : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(_roleLabel(member.role)),
            visualDensity: VisualDensity.compact,
          ),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.person_remove_outlined),
              tooltip: 'Remove member',
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }

  String _roleLabel(MemberRole role) {
    return switch (role) {
      MemberRole.owner => 'Owner',
      MemberRole.admin => 'Admin',
      MemberRole.member => 'Member',
    };
  }
}
