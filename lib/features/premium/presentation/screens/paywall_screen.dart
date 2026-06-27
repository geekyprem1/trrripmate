import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/premium/data/premium_providers.dart';
import 'package:tripmate/features/premium/domain/entities/premium_plan.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';
import 'package:tripmate/features/premium/presentation/controllers/paywall_controller.dart';

/// Paywall / Premium screen (UI/UX §3.19, PRD §12, Sprint 7).
///
/// Shows a Free vs Premium comparison, purchasable plan cards, a purchase CTA
/// and a restore option. Purchase/restore are disabled when the store is
/// unavailable (offline).
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String? _selectedPlanId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plansAsync = ref.watch(premiumPlansProvider);
    final controllerState = ref.watch(paywallControllerProvider);
    final isBusy = controllerState.isLoading;
    final entitlementAsync = ref.watch(entitlementProvider);
    final isPremium = entitlementAsync.valueOrNull?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Premium'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: plansAsync.when(
          loading: () => const AppLoadingView(),
          error: (error, _) => AppErrorView(
            message: 'Could not load plans. Check your connection and retry.',
            onRetry: () => ref.invalidate(premiumPlansProvider),
          ),
          data: (plans) {
            if (_selectedPlanId == null && plans.isNotEmpty) {
              // Pre-select the yearly plan (best value) or fallback to first.
              final yearly =
                  plans.where((p) => p.isYearly).firstOrNull ?? plans.first;
              _selectedPlanId = yearly.id;
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.huge,
              ),
              children: [
                if (isPremium) ...[
                  _AlreadyPremiumBanner(theme: theme),
                  const SizedBox(height: AppSpacing.xl),
                ],
                _HeroSection(theme: theme),
                const SizedBox(height: AppSpacing.xl),
                const _FeatureComparison(),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Choose your plan',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final plan in plans) ...[
                  _PlanCard(
                    plan: plan,
                    isSelected: plan.id == _selectedPlanId,
                    onTap: () => setState(() => _selectedPlanId = plan.id),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.lg),
                _PurchaseButton(
                  isBusy: isBusy,
                  isPremium: isPremium,
                  planId: _selectedPlanId,
                  onPurchase: _purchase,
                ),
                const SizedBox(height: AppSpacing.md),
                _RestoreButton(
                  isBusy: isBusy,
                  onRestore: _restore,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Purchases managed by the App Store / Google Play. '
                  'Subscriptions auto-renew unless cancelled.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _purchase() async {
    final planId = _selectedPlanId;
    if (planId == null) return;

    final isAvailable =
        await ref.read(premiumRepositoryProvider).isStoreAvailable();
    if (!isAvailable) {
      _showMessage('Connect to the internet to upgrade.');
      return;
    }

    final outcome = await ref
        .read(paywallControllerProvider.notifier)
        .purchase(planId);
    if (!mounted) return;
    _handleOutcome(outcome);
  }

  Future<void> _restore() async {
    final isAvailable =
        await ref.read(premiumRepositoryProvider).isStoreAvailable();
    if (!isAvailable) {
      _showMessage('Connect to the internet to restore purchases.');
      return;
    }

    final outcome =
        await ref.read(paywallControllerProvider.notifier).restore();
    if (!mounted) return;
    _handleOutcome(outcome);
  }

  void _handleOutcome(PurchaseOutcome outcome) {
    switch (outcome) {
      case PurchaseSuccess():
        _showMessage('Welcome to Premium! 🎉');
        if (mounted) context.pop();
      case PurchaseCancelled():
        // User dismissed the store sheet — no message needed.
        break;
      case PurchasePending():
        _showMessage('Your purchase is pending. '
            "We'll update your account once confirmed.");
      case PurchaseNothingToRestore():
        _showMessage('No previous purchase found for this account.');
      case PurchaseFailed(:final message):
        _showMessage(message);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          size: 72,
          color: theme.colorScheme.primary,
          semanticLabel: 'Premium',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'TripMate Premium',
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Unlimited trips, PDF exports, and more.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AlreadyPremiumBanner extends StatelessWidget {
  const _AlreadyPremiumBanner({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                "You're already a Premium member!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureComparison extends StatelessWidget {
  const _FeatureComparison();

  static const _rows = [
    (feature: 'Active trips', free: 'Up to 3', premium: 'Unlimited'),
    (feature: 'Members per trip', free: 'Unlimited', premium: 'Unlimited'),
    (feature: 'Expense tracking', free: '✓', premium: '✓'),
    (feature: 'Settlement', free: '✓', premium: '✓'),
    (feature: 'PDF export', free: '—', premium: '✓'),
    (feature: 'AI Insights (v1.5)', free: '—', premium: '✓'),
    (feature: 'Priority support', free: '—', premium: '✓'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Feature',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Free',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Premium',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
          for (final row in _rows)
            Semantics(
              label:
                  '${row.feature}: Free — ${row.free}, Premium — ${row.premium}',
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child:
                          Text(row.feature, style: theme.textTheme.bodyMedium),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(row.free,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(row.premium,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final PremiumPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label:
          '${plan.title} plan, ${plan.priceLabel}${plan.tagline != null ? ', ${plan.tagline}' : ''}',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(plan.title,
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        if (plan.tagline != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Chip(
                            label: Text(plan.tagline!),
                            labelStyle: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                            backgroundColor:
                                theme.colorScheme.tertiaryContainer,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      plan.priceLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  const _PurchaseButton({
    required this.isBusy,
    required this.isPremium,
    required this.planId,
    required this.onPurchase,
  });

  final bool isBusy;
  final bool isPremium;
  final String? planId;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isPremium
          ? 'Already subscribed'
          : 'Upgrade to Premium — recurring subscription',
      child: FilledButton(
        onPressed: (isBusy || isPremium || planId == null) ? null : onPurchase,
        child: isBusy
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(isPremium ? 'Already subscribed' : 'Upgrade now'),
      ),
    );
  }
}

class _RestoreButton extends StatelessWidget {
  const _RestoreButton({required this.isBusy, required this.onRestore});

  final bool isBusy;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isBusy ? null : onRestore,
      child: const Text('Restore purchases'),
    );
  }
}
