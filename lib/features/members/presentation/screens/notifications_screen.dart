import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/members/data/datasources/notifications_remote_data_source.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/repositories/member_repository.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';

/// Full-screen notifications list. Shows pending trip invites with
/// Accept / Decline buttons; other notification types render as read-only cards.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(unreadNotificationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(notificationsRemoteDataSourceProvider)
                  .markAllRead();
              ref.invalidate(unreadNotificationsProvider);
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load notifications.')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No new notifications',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = notifications[index];
              if (n.type == 'trip_invite' && n.inviteCode != null) {
                return _InviteNotificationTile(notification: n);
              }
              return _GenericNotificationTile(notification: n);
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Invite notification tile — Accept / Decline
// ---------------------------------------------------------------------------

class _InviteNotificationTile extends ConsumerStatefulWidget {
  const _InviteNotificationTile({required this.notification});

  final NotificationRow notification;

  @override
  ConsumerState<_InviteNotificationTile> createState() =>
      _InviteNotificationTileState();
}

class _InviteNotificationTileState
    extends ConsumerState<_InviteNotificationTile> {
  bool _loading = false;
  bool _done = false;
  String? _result;

  Future<void> _accept() async {
    setState(() => _loading = true);
    final code = widget.notification.inviteCode!;
    final result = await ref.read(memberRepositoryProvider).acceptInvite(code);
    if (!mounted) return;
    result.fold(
      onSuccess: (_) async {
        // Refresh trips so the new trip appears immediately.
        await ref.read(tripRepositoryProvider).refreshFromRemote();
        await ref
            .read(notificationsRemoteDataSourceProvider)
            .markRead(widget.notification.id);
        ref.invalidate(unreadNotificationsProvider);
        setState(() {
          _loading = false;
          _done = true;
          _result = 'Joined! Check your trips.';
        });
      },
      onFailure: (failure) {
        setState(() {
          _loading = false;
          _result = failure.displayMessage;
        });
      },
    );
  }

  Future<void> _decline() async {
    setState(() => _loading = true);
    final code = widget.notification.inviteCode!;
    await ref.read(memberRepositoryProvider).rejectInvite(code);
    await ref
        .read(notificationsRemoteDataSourceProvider)
        .markRead(widget.notification.id);
    ref.invalidate(unreadNotificationsProvider);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _done = true;
      _result = 'Invite declined.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.group_add_rounded,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(widget.notification.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.notification.body),
          if (_result != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _result!,
              style: TextStyle(
                color: _done
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (!_done) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                FilledButton(
                  onPressed: _loading ? null : _accept,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Accept'),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton(
                  onPressed: _loading ? null : _decline,
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ],
      ),
      isThreeLine: true,
    );
  }
}

// ---------------------------------------------------------------------------
// Generic notification tile (read-only)
// ---------------------------------------------------------------------------

class _GenericNotificationTile extends ConsumerWidget {
  const _GenericNotificationTile({required this.notification});

  final NotificationRow notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.notifications_rounded,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(notification.title),
      subtitle: Text(notification.body),
      onTap: () async {
        await ref
            .read(notificationsRemoteDataSourceProvider)
            .markRead(notification.id);
        ref.invalidate(unreadNotificationsProvider);
      },
    );
  }
}
