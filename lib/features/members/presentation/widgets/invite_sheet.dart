import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/validators.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/auth/domain/entities/user_profile.dart';
import 'package:tripmate/features/members/domain/repositories/member_repository.dart';
import 'package:tripmate/features/members/presentation/controllers/invite_controller.dart';

/// Modal sheet to invite members to a trip (UI/UX §3.12).
///
/// Tabs: Scan QR · Email · Username search.
class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({required this.tripId, super.key});

  final String tripId;

  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    super.dispose();
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
            const SizedBox(height: AppSpacing.md),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Scan QR'),
                Tab(text: 'Email'),
                Tab(text: 'Username'),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _QrScanTab(tripId: widget.tripId),
                  _EmailTab(
                    controller: _emailController,
                    isLoading: state.isLoading,
                    onSend: _inviteByEmail,
                  ),
                  _UsernameSearchTab(tripId: widget.tripId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QR Scan tab
// ---------------------------------------------------------------------------

class _QrScanTab extends ConsumerStatefulWidget {
  const _QrScanTab({required this.tripId});

  final String tripId;

  @override
  ConsumerState<_QrScanTab> createState() => _QrScanTabState();
}

class _QrScanTabState extends ConsumerState<_QrScanTab> {
  final _scannerController = MobileScannerController();
  bool _processing = false;
  UserProfile? _scannedUser;
  String? _error;
  bool _invited = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing || _scannedUser != null) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final uri = Uri.tryParse(raw);
    if (uri == null ||
        uri.scheme != 'tripmate' ||
        uri.host != 'user' ||
        uri.pathSegments.isEmpty) {
      setState(() => _error = 'Not a valid TripMate QR code.');
      return;
    }

    final username = uri.pathSegments.first;
    setState(() {
      _processing = true;
      _error = null;
    });

    final result =
        await ref.read(authRepositoryProvider).findUserByUsername(username);
    if (!mounted) return;

    result.fold(
      onSuccess: (profile) {
        setState(() {
          _processing = false;
          _scannedUser = profile;
          if (profile == null) _error = 'No user found with @$username.';
        });
      },
      onFailure: (failure) {
        setState(() {
          _processing = false;
          _error = failure.displayMessage;
        });
      },
    );
  }

  Future<void> _sendRequest(UserProfile profile) async {
    final email = profile.email;
    if (email == null) {
      setState(
          () => _error = 'This user has no email. Ask them to join via link.');
      return;
    }
    setState(() => _processing = true);
    await ref
        .read(inviteControllerProvider.notifier)
        .generate(widget.tripId, target: InviteTarget(email: email));
    if (!mounted) return;
    setState(() {
      _processing = false;
      _invited = true;
    });
  }

  void _rescan() {
    setState(() {
      _scannedUser = null;
      _error = null;
      _invited = false;
      _processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // After scan: show user card
    if (_scannedUser != null && !_invited) {
      return _UserFoundCard(
        profile: _scannedUser!,
        isLoading: _processing,
        onSend: () => _sendRequest(_scannedUser!),
        onRescan: _rescan,
        error: _error,
      );
    }

    if (_invited) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded,
                size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Request sent!',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.primary)),
            const SizedBox(height: AppSpacing.sm),
            Text('They\'ll see it in their notifications.',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.lg),
            TextButton(onPressed: _rescan, child: const Text('Scan another')),
          ],
        ),
      );
    }

    // Scanner view
    return Column(
      children: [
        Text(
          'Point camera at a friend\'s QR code.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onDetect,
                ),
                // scan frame overlay
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: theme.colorScheme.primary, width: 2.5),
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                ),
                if (_processing)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  ),
                if (_error != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      color: theme.colorScheme.errorContainer,
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// User found card (shown after QR scan resolves)
// ---------------------------------------------------------------------------

class _UserFoundCard extends StatelessWidget {
  const _UserFoundCard({
    required this.profile,
    required this.isLoading,
    required this.onSend,
    required this.onRescan,
    this.error,
  });

  final UserProfile profile;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onRescan;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            (profile.displayName.isNotEmpty ? profile.displayName[0] : '?')
                .toUpperCase(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(profile.displayName, style: theme.textTheme.titleLarge),
        if (profile.username != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '@${profile.username}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(error!,
              style: TextStyle(color: theme.colorScheme.error),
              textAlign: TextAlign.center),
        ],
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: onRescan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Rescan'),
            ),
            const SizedBox(width: AppSpacing.md),
            FilledButton.icon(
              onPressed: isLoading ? null : onSend,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.person_add_rounded),
              label: const Text('Send Request'),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Email tab
// ---------------------------------------------------------------------------

class _EmailTab extends StatelessWidget {
  const _EmailTab({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Send an invite directly to their email address.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filledTonal(
              onPressed: isLoading ? null : onSend,
              icon: const Icon(Icons.send),
              tooltip: 'Send invite',
            ),
          ],
        ),
        if (isLoading) ...[
          const SizedBox(height: AppSpacing.md),
          const LinearProgressIndicator(),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Username search tab
// ---------------------------------------------------------------------------

class _UsernameSearchTab extends ConsumerStatefulWidget {
  const _UsernameSearchTab({required this.tripId});

  final String tripId;

  @override
  ConsumerState<_UsernameSearchTab> createState() => _UsernameSearchTabState();
}

class _UsernameSearchTabState extends ConsumerState<_UsernameSearchTab> {
  final _controller = TextEditingController();
  bool _searching = false;
  bool _sending = false;
  UserProfile? _found;
  String? _error;
  bool _invited = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final username = _controller.text.trim();
    if (Validators.username(username) != null) {
      setState(() => _error = 'Enter a valid username (3–20 chars).');
      return;
    }
    setState(() {
      _searching = true;
      _found = null;
      _error = null;
      _invited = false;
    });
    final result =
        await ref.read(authRepositoryProvider).findUserByUsername(username);
    if (!mounted) return;
    result.fold(
      onSuccess: (profile) => setState(() {
        _searching = false;
        _found = profile;
        if (profile == null) _error = 'No user found with @$username.';
      }),
      onFailure: (failure) => setState(() {
        _searching = false;
        _error = failure.displayMessage;
      }),
    );
  }

  Future<void> _sendRequest(UserProfile profile) async {
    final email = profile.email;
    if (email == null) {
      setState(() => _error = 'No email on file. Ask them to join via link.');
      return;
    }
    setState(() => _sending = true);
    await ref
        .read(inviteControllerProvider.notifier)
        .generate(widget.tripId, target: InviteTarget(email: email));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _invited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Search by their TripMate username.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email),
                  hintText: 'e.g. rahul_travels',
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
              tooltip: 'Search',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (_error != null)
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        if (_invited)
          Row(
            children: [
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Request sent! They\'ll see it in notifications.',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        if (_found != null && !_invited)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    (_found!.displayName.isNotEmpty
                            ? _found!.displayName[0]
                            : '?')
                        .toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_found!.displayName,
                          style: theme.textTheme.titleSmall),
                      if (_found!.username != null)
                        Text('@${_found!.username}',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: _sending ? null : () => _sendRequest(_found!),
                  icon: _sending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.person_add_rounded, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
