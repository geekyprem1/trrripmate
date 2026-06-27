import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/premium/data/premium_providers.dart';

/// Settings / Profile screen (UI/UX §3.18, Sprint 7).
///
/// Shows account info, theme preference, subscription status, and sign-out.
/// The subscription section surfaces the current tier and a "Go Premium" entry
/// for free-tier users.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const _ProfileSection(),
          const Divider(),
          const _QrSection(),
          const Divider(),
          const _SubscriptionSection(),
          const Divider(),
          const _AppearanceSection(),
          const Divider(),
          const _AccountSection(),
          const Divider(),
          const _AboutSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile section
// ---------------------------------------------------------------------------

class _ProfileSection extends ConsumerWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);
    final theme = Theme.of(context);

    final profile = profileAsync.valueOrNull;
    final displayName = profile?.displayName ?? '…';
    final username = profile?.username;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.person_rounded,
              size: 32,
              color: theme.colorScheme.onPrimaryContainer,
              semanticLabel: 'Profile photo',
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (username != null)
                  Text(
                    '@$username',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QR section
// ---------------------------------------------------------------------------

class _QrSection extends ConsumerWidget {
  const _QrSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);
    final theme = Theme.of(context);
    final username = profileAsync.valueOrNull?.username;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
          child: Text(
            'My QR Code',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        if (username == null)
          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Text('Set a username to generate your QR code.'),
          )
        else
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share this QR so friends can add you to a trip.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withAlpha(20),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: QrImageView(
                      data: 'tripmate://user/$username',
                      version: QrVersions.auto,
                      size: 200,
                      semanticsLabel: 'QR code for @$username',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: 'tripmate://user/$username'),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text('Username link copied')),
                        );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text('@$username'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Subscription section
// ---------------------------------------------------------------------------

class _SubscriptionSection extends ConsumerWidget {
  const _SubscriptionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlementAsync = ref.watch(entitlementProvider);
    final isPremium = entitlementAsync.valueOrNull?.isPremium ?? false;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
          child: Text(
            'Subscription',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            isPremium
                ? Icons.workspace_premium_rounded
                : Icons.star_border_rounded,
            color: isPremium
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onSurfaceVariant,
          ),
          title: Text(isPremium ? 'TripMate Premium' : 'Free Plan'),
          subtitle: Text(
            isPremium
                ? 'Unlimited trips · PDF export · Priority support'
                : 'Up to 3 active trips',
          ),
          trailing: isPremium
              ? Chip(
                  label: const Text('Active'),
                  backgroundColor: theme.colorScheme.tertiaryContainer,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        if (!isPremium)
          ListTile(
            leading: const Icon(Icons.upgrade_rounded),
            title: const Text('Go Premium'),
            subtitle: const Text('Unlock unlimited trips and more'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoutes.paywallName),
          ),
        if (isPremium)
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: const Text('Manage subscription'),
            subtitle: const Text('Restore or manage via App Store / Play'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoutes.paywallName),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Appearance section
// ---------------------------------------------------------------------------

class _AppearanceSection extends StatefulWidget {
  const _AppearanceSection();

  @override
  State<_AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<_AppearanceSection> {
  // Theme preference is stored in-memory for v1.0; persistent storage is a
  // v1.5 enhancement.
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
          child: Text(
            'Appearance',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Semantics(
          label:
              'Theme: ${_modeLabel(_themeMode)}. Tap to change between system, light, and dark.',
          child: ListTile(
            leading: Icon(_modeIcon(_themeMode)),
            title: const Text('Theme'),
            subtitle: Text(_modeLabel(_themeMode)),
            trailing: DropdownButton<ThemeMode>(
              value: _themeMode,
              underline: const SizedBox.shrink(),
              onChanged: (mode) {
                if (mode != null) setState(() => _themeMode = mode);
              },
              items: const [
                DropdownMenuItem(
                    value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(
                    value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _modeIcon(ThemeMode mode) => switch (mode) {
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.system => Icons.brightness_auto_rounded,
      };

  String _modeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'Follow system',
      };
}

// ---------------------------------------------------------------------------
// Account section
// ---------------------------------------------------------------------------

class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
          child: Text(
            'Account',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: const Text('Sign out'),
          onTap: () => _signOut(context, ref),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Any unsynced changes will be uploaded next time you sign in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      await ref.read(authRepositoryProvider).signOut();
    }
  }
}

// ---------------------------------------------------------------------------
// About section
// ---------------------------------------------------------------------------

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
          child: Text(
            'About',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text('TripMate'),
          subtitle: Text('v1.0'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () {/* v1.5: launch URL */},
        ),
        ListTile(
          leading: const Icon(Icons.gavel_rounded),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () {/* v1.5: launch URL */},
        ),
        const SizedBox(height: AppSpacing.huge),
      ],
    );
  }
}
