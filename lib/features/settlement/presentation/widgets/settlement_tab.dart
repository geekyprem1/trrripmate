import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_colors.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/settlement/data/settlement_providers.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement_summary.dart';
import 'package:tripmate/features/settlement/presentation/controllers/settlement_actions_controller.dart';

/// The Settlement tab inside the trip dashboard (UI/UX §3.14): net-balance
/// summary, outstanding "who pays who" list with mark-paid, and settled/empty
/// states. The graph recomputes reactively as expenses change.
class SettlementTab extends ConsumerWidget {
  const SettlementTab({
    required this.tripId,
    required this.currency,
    this.isArchived = false,
    super.key,
  });

  final String tripId;
  final String currency;
  final bool isArchived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The approved-expenses stream is the primary async source; the summary is
    // derived synchronously from it (plus members + completed payments).
    final expensesAsync = ref.watch(approvedExpensesDetailedProvider(tripId));

    return expensesAsync.when(
      loading: () => const AppLoadingView(),
      error: (error, _) => AppErrorView(
        message: error is Failure ? error.displayMessage : 'Failed to load.',
        onRetry: () => ref.invalidate(approvedExpensesDetailedProvider(tripId)),
      ),
      data: (_) {
        final summary = ref.watch(tripSettlementSummaryProvider(tripId));
        final members = ref.watch(tripMembersProvider(tripId)).valueOrNull ?? [];
        final userId = ref.watch(authStateProvider).valueOrNull?.id;
        final names = {
          for (final m in members) m.id: m.displayName ?? 'Member',
        };
        final myMember = _memberForUser(members, userId);
        final isOwner = myMember?.isOwner ?? false;

        if (summary.isEmpty) {
          return const AppEmptyView(
            icon: Icons.handshake_outlined,
            message: 'Nothing to settle yet.\nAdd expenses to see who owes who.',
          );
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.huge),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _NetSummaryCard(
                netMinor: summary.yourNetMinor,
                currency: currency,
                hasMembership: myMember != null,
              ),
            ),
            if (summary.isAllSettled)
              const _AllSettledBanner()
            else
              ..._transactionList(
                context,
                summary: summary,
                names: names,
                currentMemberId: myMember?.id,
                isOwner: isOwner,
              ),
          ],
        );
      },
    );
  }

  Member? _memberForUser(List<Member> members, String? userId) {
    if (userId == null) return null;
    for (final member in members) {
      if (member.userId == userId) return member;
    }
    return null;
  }

  List<Widget> _transactionList(
    BuildContext context, {
    required SettlementSummary summary,
    required Map<String, String> names,
    required String? currentMemberId,
    required bool isOwner,
  }) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
        child: Text(
          'Who pays who',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      for (final txn in summary.transactions)
        _SettlementTile(
          transaction: txn,
          fromName: names[txn.fromMemberId] ?? 'Member',
          toName: names[txn.toMemberId] ?? 'Member',
          currency: currency,
          // Permission (UX): the debtor (payer) or trip owner may mark paid.
          canMarkPaid: !isArchived &&
              (isOwner || currentMemberId == txn.fromMemberId),
        ),
    ];
  }
}

class _NetSummaryCard extends StatelessWidget {
  const _NetSummaryCard({
    required this.netMinor,
    required this.currency,
    required this.hasMembership,
  });

  final int netMinor;
  final String currency;
  final bool hasMembership;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;

    final (label, color, icon) = switch (netMinor) {
      > 0 => (
          "You're owed ${Money.format(netMinor, currency)}",
          semantic.moneyPositive,
          Icons.trending_up,
        ),
      < 0 => (
          'You owe ${Money.format(netMinor.abs(), currency)}',
          semantic.moneyNegative,
          Icons.trending_down,
        ),
      _ => (
          hasMembership ? "You're all settled" : 'Trip balances',
          semantic.moneyNeutral,
          Icons.check_circle_outline,
        ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Semantics(
          label: label,
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettlementTile extends ConsumerWidget {
  const _SettlementTile({
    required this.transaction,
    required this.fromName,
    required this.toName,
    required this.currency,
    required this.canMarkPaid,
  });

  final Settlement transaction;
  final String fromName;
  final String toName;
  final String currency;
  final bool canMarkPaid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final amount = Money.format(transaction.amountMinor, currency);
    final isMarking = ref.watch(settlementActionsControllerProvider).isLoading;

    return Semantics(
      label: '$fromName pays $toName $amount, pending',
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(fromName, overflow: TextOverflow.ellipsis)),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm),
                          child: Icon(Icons.arrow_forward, size: 16),
                        ),
                        Flexible(child: Text(toName, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      amount,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              if (canMarkPaid)
                FilledButton.tonal(
                  onPressed: isMarking ? null : () => _markPaid(context, ref),
                  child: const Text('Mark paid'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markPaid(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final failure = await ref
        .read(settlementActionsControllerProvider.notifier)
        .markPaid(transaction);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            failure?.displayMessage ?? 'Marked as paid',
          ),
        ),
      );
  }
}

class _AllSettledBanner extends StatelessWidget {
  const _AllSettledBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Semantics(
        label: 'All settled. Everyone is squared up.',
        child: Column(
          children: [
            Icon(Icons.celebration_outlined, size: 48, color: semantic.success),
            const SizedBox(height: AppSpacing.md),
            Text(
              'All settled 🎉',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Everyone is squared up.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
