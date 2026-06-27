import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/auth/domain/entities/user_profile.dart';
import 'package:tripmate/features/friends/data/friends_providers.dart';
import 'package:tripmate/features/friends/domain/entities/friend.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  final _searchController = TextEditingController();
  bool _searching = false;
  UserProfile? _found;
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _searching = true;
      _found = null;
      _searchError = null;
    });
    final result =
        await ref.read(authRepositoryProvider).findUserByUsername(query);
    if (!mounted) return;
    result.fold(
      onSuccess: (profile) => setState(() {
        _searching = false;
        _found = profile;
        if (profile == null) _searchError = 'No user found with @$query.';
      }),
      onFailure: (f) => setState(() {
        _searching = false;
        _searchError = f.displayMessage;
      }),
    );
  }

  Future<void> _addFriend(UserProfile profile) async {
    await ref.read(friendsRepositoryProvider).addFriend(
          friendUserId: profile.id,
          displayName: profile.displayName,
          username: profile.username,
          email: profile.email,
          avatarUrl: profile.avatarUrl,
        );
    if (!mounted) return;
    setState(() {
      _found = null;
      _searchController.clear();
      _searchError = null;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${profile.displayName} added to friends!')),
      );
  }

  Future<void> _removeFriend(Friend friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove friend?'),
        content: Text('Remove ${friend.displayName} from your friends list?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(friendsRepositoryProvider)
          .removeFriend(friend.friendUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friendsAsync = ref.watch(friendsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _search(),
                        decoration: const InputDecoration(
                          labelText: 'Search by username',
                          hintText: 'e.g. rahul_travels',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filledTonal(
                      onPressed: _searching ? null : _search,
                      icon: _searching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.search),
                    ),
                  ],
                ),
                if (_searchError != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(_searchError!,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
                // Search result card
                if (_found != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _SearchResultCard(
                    profile: _found!,
                    onAdd: () => _addFriend(_found!),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // Friends list
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
            child: Text('Friends',
                style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          ),

          Expanded(
            child: friendsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Could not load friends.')),
              data: (friends) {
                if (friends.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group_outlined,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No friends yet.\nSearch by username to add someone.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: friends.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final friend = friends[i];
                    return ListTile(
                      leading: _Avatar(
                          name: friend.displayName, url: friend.avatarUrl),
                      title: Text(friend.displayName),
                      subtitle: friend.username != null
                          ? Text('@${friend.username}')
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.person_remove_outlined),
                        tooltip: 'Remove friend',
                        onPressed: () => _removeFriend(friend),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends ConsumerWidget {
  const _SearchResultCard({required this.profile, required this.onAdd});

  final UserProfile profile;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final alreadyFriend = ref
        .watch(friendsListProvider)
        .valueOrNull
        ?.any((f) => f.friendUserId == profile.id) ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        children: [
          _Avatar(name: profile.displayName, url: profile.avatarUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.displayName,
                    style: theme.textTheme.titleSmall),
                if (profile.username != null)
                  Text('@${profile.username}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          if (alreadyFriend)
            Chip(
              label: const Text('Added'),
              avatar: const Icon(Icons.check, size: 16),
            )
          else
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_rounded, size: 18),
              label: const Text('Add'),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.url});
  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (url != null) {
      return CircleAvatar(backgroundImage: NetworkImage(url!));
    }
    return CircleAvatar(
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
