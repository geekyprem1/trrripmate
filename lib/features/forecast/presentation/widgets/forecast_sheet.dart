import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/forecast/data/forecast_providers.dart';
import 'package:tripmate/features/forecast/domain/entities/forecast_item.dart';

/// Bottom sheet that lets users plan future spending and see projected
/// remaining budget after planned items are deducted.
class ForecastSheet extends ConsumerStatefulWidget {
  const ForecastSheet({
    required this.tripId,
    required this.currency,
    required this.remainingMinor,
    super.key,
  });

  final String tripId;
  final String currency;

  /// Current actual remaining amount from the budget summary (minor units).
  /// Null when no budget is set.
  final int? remainingMinor;

  @override
  ConsumerState<ForecastSheet> createState() => _ForecastSheetState();
}

class _ForecastSheetState extends ConsumerState<ForecastSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (!_formKey.currentState!.validate()) return;
    final amountMinor = Money.tryParseMajorToMinor(_amountController.text);
    if (amountMinor == null || amountMinor <= 0) return;

    ref.read(forecastRepositoryProvider).addItem(
          tripId: widget.tripId,
          name: _nameController.text.trim(),
          amountMinor: amountMinor,
        );
    _nameController.clear();
    _amountController.clear();
    FocusScope.of(context).unfocus();
  }

  void _deleteItem(ForecastItem item) =>
      ref.read(forecastRepositoryProvider).deleteItem(item.id);

  void _clearAll() {
    ref.read(forecastRepositoryProvider).clearAll(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemsAsync = ref.watch(forecastItemsProvider(widget.tripId));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.xs),
                    ),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(Icons.calculate_outlined,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text('Forecast Calculator',
                          style: theme.textTheme.titleLarge),
                    ),
                    itemsAsync.valueOrNull?.isNotEmpty == true
                        ? TextButton(
                            onPressed: _showClearDialog,
                            child: const Text('Clear all'),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),

              // Projected remaining banner
              itemsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (items) => _ProjectedBanner(
                  remainingMinor: widget.remainingMinor,
                  forecastTotalMinor:
                      items.fold(0, (sum, i) => sum + i.amountMinor),
                  currency: widget.currency,
                ),
              ),

              const Divider(height: 1),

              // Add item form
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Item name',
                            hintText: 'e.g. Hotel',
                            isDense: true,
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _addItem(),
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            hintText: '0',
                            prefixText:
                                _currencySymbol(widget.currency),
                            isDense: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Required';
                            }
                            final parsed = Money.tryParseMajorToMinor(v);
                            if (parsed == null || parsed <= 0) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: IconButton.filledTonal(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          tooltip: 'Add item',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1),

              // Items list
              Expanded(
                child: itemsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) =>
                      const Center(child: Text('Could not load forecast.')),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.playlist_add,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Add planned items above\nto see your projected balance.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            child: Text(
                              item.name.isNotEmpty
                                  ? item.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                  color:
                                      theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                          title: Text(item.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '− ${Money.format(item.amountMinor, widget.currency)}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                tooltip: 'Remove',
                                onPressed: () => _deleteItem(item),
                              ),
                            ],
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
      },
    );
  }

  void _showClearDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear forecast?'),
        content:
            const Text('This will remove all planned items for this trip.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _clearAll();
            },
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }

  String _currencySymbol(String code) {
    const symbols = {
      'INR': '₹',
      'USD': r'$',
      'EUR': '€',
      'GBP': '£',
      'THB': '฿',
      'JPY': '¥',
    };
    return symbols[code] ?? '$code ';
  }
}

// ---------------------------------------------------------------------------
// Projected remaining banner
// ---------------------------------------------------------------------------

class _ProjectedBanner extends StatelessWidget {
  const _ProjectedBanner({
    required this.remainingMinor,
    required this.forecastTotalMinor,
    required this.currency,
  });

  final int? remainingMinor;
  final int forecastTotalMinor;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = remainingMinor;

    if (remaining == null) {
      // No budget set — just show total planned spend
      return Container(
        width: double.infinity,
        color: theme.colorScheme.surfaceContainerHigh,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total planned',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              Money.format(forecastTotalMinor, currency),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: forecastTotalMinor > 0
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
              ),
            ),
            Text('Set a trip budget to see projected balance.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    final projected = remaining - forecastTotalMinor;
    final isNegative = projected < 0;

    return Container(
      width: double.infinity,
      color: isNegative
          ? theme.colorScheme.errorContainer.withOpacity(0.4)
          : theme.colorScheme.primaryContainer.withOpacity(0.35),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remaining now',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                Text(
                  Money.format(remaining, currency),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward,
              color: theme.colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Projected balance',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant),
                ),
                Text(
                  Money.format(projected, currency),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isNegative
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
                if (isNegative)
                  Text(
                    'Over budget by ${Money.format(-projected, currency)}',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
