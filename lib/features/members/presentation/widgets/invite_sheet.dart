import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/validators.dart';
import 'package:tripmate/features/members/domain/repositories/member_repository.dart';
import 'package:tripmate/features/members/presentation/controllers/invite_controller.dart';

/// Modal sheet to generate and share an invitation (UI/UX §3.12).
class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({required this.tripId, super.key});

  final String tripId;

  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Generate a shareable link invite as soon as the sheet opens.
    Future.microtask(
      () => ref.read(inviteControllerProvider.notifier).generate(widget.tripId),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _copy(String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Invite link copied')));
  }

  void _inviteByEmail() {
    final email = _emailController.text.trim();
    if (Validators.email(email) != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Enter a valid email.')));
      return;
    }
    ref
        .read(inviteControllerProvider.notifier)
        .generate(widget.tripId, target: InviteTarget(email: email));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(inviteControllerProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Invite to trip', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Anyone with the link can request to join. Links expire in 7 days.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            state.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text(
                error is Failure
                    ? error.displayMessage
                    : 'Could not create invite.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              data: (invitation) {
                if (invitation == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      child: Text(
                        invitation.deepLink,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: () => _copy(invitation.deepLink),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy link'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Or invite by email', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filledTonal(
                  onPressed: state.isLoading ? null : _inviteByEmail,
                  icon: const Icon(Icons.send),
                  tooltip: 'Send invite',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
