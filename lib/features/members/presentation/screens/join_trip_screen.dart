import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/members/domain/entities/invitation.dart';
import 'package:tripmate/features/members/presentation/controllers/join_controllers.dart';
import 'package:tripmate/features/members/presentation/controllers/pending_invite.dart';

/// Join Trip / invite-accept screen reached via deep link (UI/UX §3.13).
class JoinTripScreen extends ConsumerStatefulWidget {
  const JoinTripScreen({required this.code, super.key});

  final String code;

  @override
  ConsumerState<JoinTripScreen> createState() => _JoinTripScreenState();
}

class _JoinTripScreenState extends ConsumerState<JoinTripScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_syncPendingState);
  }

  void _syncPendingState() {
    final isAuthed = ref.read(authStateProvider).valueOrNull != null;
    final pending = ref.read(pendingInviteProvider.notifier);
    // Remember the code across sign-in; clear it once we've arrived signed in.
    if (isAuthed) {
      pending.clear();
    } else {
      pending.set(widget.code);
    }
  }

  Future<void> _accept() async {
    final tripId =
        await ref.read(joinControllerProvider.notifier).accept(widget.code);
    if (tripId == null || !mounted) return;
    ref.read(pendingInviteProvider.notifier).clear();
    context.goNamed(
      AppRoutes.tripDashboardName,
      pathParameters: {'id': tripId},
    );
  }

  Future<void> _reject() async {
    final ok =
        await ref.read(joinControllerProvider.notifier).reject(widget.code);
    if (ok && mounted) {
      ref.read(pendingInviteProvider.notifier).clear();
      context.goNamed(AppRoutes.homeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewAsync = ref.watch(invitePreviewProvider(widget.code));
    final isAuthed = ref.watch(authStateProvider).valueOrNull != null;
    final joinState = ref.watch(joinControllerProvider);

    ref.listen(joinControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        final message =
            error is Failure ? error.displayMessage : 'Something went wrong.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Trip invitation')),
      body: previewAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message:
              error is Failure ? error.displayMessage : 'Invitation not found.',
        ),
        data: (preview) => _buildPreview(
          context,
          preview,
          isAuthed: isAuthed,
          isBusy: joinState.isLoading,
        ),
      ),
    );
  }

  Widget _buildPreview(
    BuildContext context,
    InvitePreview preview, {
    required bool isAuthed,
    required bool isBusy,
  }) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.luggage_outlined,
                  size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                preview.tripName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${preview.ownerName ?? 'Someone'} invited you · '
                '${preview.memberCount} member(s)',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (!preview.isOpen)
                _ExpiredNotice(theme: theme)
              else if (!isAuthed)
                FilledButton(
                  onPressed: () => context.goNamed(AppRoutes.signInName),
                  child: const Text('Sign in to join'),
                )
              else ...[
                FilledButton(
                  onPressed: isBusy ? null : _accept,
                  child: isBusy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Text('Accept invitation'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: isBusy ? null : _reject,
                  child: const Text('Decline'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpiredNotice extends StatelessWidget {
  const _ExpiredNotice({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.timer_off_outlined, color: theme.colorScheme.error),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This invitation has expired.\nAsk the trip owner for a new link.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
