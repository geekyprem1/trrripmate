import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/trips/data/trip_plan_providers.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';

/// Pre-trip budget planner — plan items + estimate before the trip starts.
class TripPlannerScreen extends ConsumerStatefulWidget {
  const TripPlannerScreen({required this.tripId, super.key});

  final String tripId;

  @override
  ConsumerState<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  static const _categories = [
    'Transport', 'Hotel', 'Food', 'Activities',
    'Shopping', 'Medical', 'Visa', 'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = Money.tryParseMajorToMinor(_amountController.text);
    if (amount == null || amount <= 0) return;
    await ref.read(tripPlanServiceProvider).addItem(
          tripId: widget.tripId,
          name: _nameController.text.trim(),
          estimatedAmountMinor: amount,
          category: _selectedCategory,
        );
    _nameController.clear();
    _amountController.clear();
    setState(() => _selectedCategory = null);
    if (mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripAsync = ref.watch(tripByIdProvider(widget.tripId));
    final itemsAsync = ref.watch(tripPlanItemsProvider(widget.tripId));

    final trip = tripAsync.valueOrNull;
    final currency = trip?.currency ?? 'INR';
    final budgetMinor = trip?.totalBudgetMinor;

    final items = itemsAsync.valueOrNull ?? [];
    final totalEstimated = items.fold<int>(
        0, (sum, i) => sum + i.estimatedAmountMinor);
    final isOverEstimate =
        budgetMinor != null && totalEstimated > budgetMinor;

    return Scaffold(
      appBar: AppBar(
        title: Text(trip != null ? '${trip.name} — Planner' : 'Trip Planner'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context),
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Summary banner
          _SummaryBanner(
            totalEstimatedMinor: totalEstimated,
            budgetMinor: budgetMinor,
            currency: currency,
            isOver: isOverEstimate,
            itemCount: items.length,
          ),

          // Add item form
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Item',
                            hintText: 'e.g. Flight tickets',
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
                            labelText: 'Est. amount',
                            prefixText: _symbol(currency),
                            isDense: true,
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final p = Money.tryParseMajorToMinor(v);
                            return (p == null || p <= 0) ? 'Invalid' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Category (optional)',
                            isDense: true,
                          ),
                          items: _categories
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton.icon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
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
                  const Center(child: Text('Could not load plan.')),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.playlist_add_outlined,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Add planned items above\nto estimate your trip budget.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    return _PlanItemTile(
                      item: item,
                      currency: currency,
                      onDelete: () => ref
                          .read(tripPlanServiceProvider)
                          .deleteItem(item.id),
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

  void _confirmClear(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear plan?'),
        content: const Text('Remove all planned items?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(tripPlanServiceProvider)
                  .clearAll(widget.tripId);
            },
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }

  String _symbol(String code) {
    const m = {'INR': '₹', 'USD': r'$', 'EUR': '€', 'GBP': '£'};
    return m[code] ?? '$code ';
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({
    required this.totalEstimatedMinor,
    required this.currency,
    required this.isOver,
    required this.itemCount,
    this.budgetMinor,
  });

  final int totalEstimatedMinor;
  final int? budgetMinor;
  final String currency;
  final bool isOver;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: isOver
          ? theme.colorScheme.errorContainer.withOpacity(0.5)
          : theme.colorScheme.primaryContainer.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated total',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
                Text(
                  Money.format(totalEstimatedMinor, currency),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isOver
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
                Text('$itemCount item${itemCount == 1 ? '' : 's'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          if (budgetMinor != null) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Trip budget',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  Text(
                    Money.format(budgetMinor!, currency),
                    style: theme.textTheme.titleLarge,
                  ),
                  if (isOver)
                    Text(
                      'Over by ${Money.format(totalEstimatedMinor - budgetMinor!, currency)}',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.error),
                    )
                  else
                    Text(
                      '${Money.format(budgetMinor! - totalEstimatedMinor, currency)} remaining',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.primary),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanItemTile extends StatelessWidget {
  const _PlanItemTile({
    required this.item,
    required this.currency,
    required this.onDelete,
  });

  final TripPlanItemRow item;
  final String currency;
  final VoidCallback onDelete;

  static const _categoryIcons = <String, IconData>{
    'Transport': Icons.directions_car_outlined,
    'Hotel': Icons.hotel_outlined,
    'Food': Icons.restaurant_outlined,
    'Activities': Icons.attractions_outlined,
    'Shopping': Icons.shopping_bag_outlined,
    'Medical': Icons.medical_services_outlined,
    'Visa': Icons.article_outlined,
    'Other': Icons.category_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = _categoryIcons[item.category] ?? Icons.receipt_outlined;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(icon,
            size: 20, color: theme.colorScheme.onSecondaryContainer),
      ),
      title: Text(item.name),
      subtitle: item.category != null ? Text(item.category!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Money.format(item.estimatedAmountMinor, currency),
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onDelete,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
