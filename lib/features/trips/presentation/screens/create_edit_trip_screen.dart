import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/domain/repositories/trip_repository.dart';
import 'package:tripmate/features/trips/presentation/controllers/trip_form_controller.dart';

/// Loads a trip by id for editing, then shows the form (handles deep links).
class EditTripLoader extends ConsumerWidget {
  const EditTripLoader({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripByIdProvider(tripId));
    return tripAsync.when(
      loading: () => const Scaffold(body: AppLoadingView()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
        ),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppEmptyView(message: 'Trip not found.'),
          );
        }
        return CreateEditTripScreen(trip: trip);
      },
    );
  }
}

/// Create / Edit Trip form (UI/UX §3.6, PRD REQ-TRIP-01/02).
class CreateEditTripScreen extends ConsumerStatefulWidget {
  const CreateEditTripScreen({this.trip, super.key});

  /// Non-null when editing an existing trip.
  final Trip? trip;

  @override
  ConsumerState<CreateEditTripScreen> createState() =>
      _CreateEditTripScreenState();
}

class _CreateEditTripScreenState extends ConsumerState<CreateEditTripScreen> {
  static const _currencies = ['INR', 'USD', 'EUR', 'GBP', 'THB', 'JPY', 'AUD'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _destinationController;
  late final TextEditingController _budgetController;

  late String _currency;
  DateTimeRange? _dateRange;

  bool get _isEditing => widget.trip != null;

  @override
  void initState() {
    super.initState();
    final trip = widget.trip;
    _nameController = TextEditingController(text: trip?.name ?? '');
    _destinationController =
        TextEditingController(text: trip?.destination ?? '');
    _budgetController = TextEditingController(
      text: trip?.totalBudgetMinor != null
          ? (trip!.totalBudgetMinor! / 100).toStringAsFixed(2)
          : '',
    );
    _currency = trip?.currency ?? 'INR';
    if (trip?.startDate != null && trip?.endDate != null) {
      _dateRange = DateTimeRange(start: trip!.startDate!, end: trip.endDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _dateRange,
    );
    if (range != null) setState(() => _dateRange = range);
  }

  String? _validateBudget(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final minor = Money.tryParseMajorToMinor(value);
    if (minor == null) return 'Enter a valid amount.';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final draft = TripDraft(
      name: _nameController.text.trim(),
      currency: _currency,
      destination: _destinationController.text.trim().isEmpty
          ? null
          : _destinationController.text.trim(),
      startDate: _dateRange?.start,
      endDate: _dateRange?.end,
      totalBudgetMinor: Money.tryParseMajorToMinor(_budgetController.text),
    );
    final ok = await ref
        .read(tripFormControllerProvider.notifier)
        .submit(tripId: widget.trip?.id, draft: draft);
    if (ok && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(tripFormControllerProvider);
    final isLoading = state.isLoading;

    ref.listen(tripFormControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        final failure = error is Failure ? error : null;
        // Quota limit: navigate to paywall rather than showing a plain snackbar
        // (Sprint 7 acceptance criterion — 4th active trip blocked → paywall).
        if (failure is QuotaFailure) {
          context.pushNamed(AppRoutes.paywallName);
          return;
        }
        final message = failure?.displayMessage ?? 'Could not save trip.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit trip' : 'New trip')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      labelText: 'Trip name',
                      prefixIcon: Icon(Icons.luggage_outlined),
                      counterText: '',
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Trip name is required.'
                            : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _destinationController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Destination (optional)',
                      prefixIcon: Icon(Icons.place_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: _pickDates,
                    icon: const Icon(Icons.date_range),
                    label: Text(_dateRangeLabel()),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    items: [
                      for (final code in _currencies)
                        DropdownMenuItem(value: code, child: Text(code)),
                    ],
                    onChanged: (value) =>
                        setState(() => _currency = value ?? _currency),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Total budget (optional)',
                      prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    ),
                    validator: _validateBudget,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(_isEditing ? 'Save changes' : 'Create trip'),
                  ),
                  if (!_isEditing) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Free plan includes up to 3 active trips.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _dateRangeLabel() {
    final range = _dateRange;
    if (range == null) return 'Add dates (optional)';
    String fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
    return '${fmt(range.start)} – ${fmt(range.end)}';
  }
}
