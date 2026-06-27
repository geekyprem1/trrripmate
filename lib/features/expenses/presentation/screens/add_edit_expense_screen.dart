import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/expenses/domain/repositories/expense_repository.dart';
import 'package:tripmate/features/expenses/presentation/category_icons.dart';
import 'package:tripmate/features/expenses/presentation/controllers/expense_form_controller.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';

/// Add / Edit Expense (UI/UX §3.9, PRD REQ-EXP-01/02/05/06).
class AddEditExpenseScreen extends ConsumerStatefulWidget {
  const AddEditExpenseScreen({
    required this.tripId,
    required this.currency,
    this.expense,
    super.key,
  });

  final String tripId;
  final String currency;
  final Expense? expense;

  @override
  ConsumerState<AddEditExpenseScreen> createState() =>
      _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.food;
  String? _payerMemberId;
  final Set<String> _splitMemberIds = {};
  DateTime _date = DateTime.now();
  String? _receiptLocalPath;
  bool _initialised = false;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    if (expense != null) {
      _amountController.text = (expense.amountMinor / 100).toStringAsFixed(2);
      final desc = expense.description ?? '';
      final parts = desc.split('\n---\n');
      if (parts.isNotEmpty) {
        _titleController.text = parts[0];
        if (parts.length > 1) {
          _notesController.text = parts.sublist(1).join('\n---\n');
        }
      }
      _category = expense.category;
      _payerMemberId = expense.paidByMemberId;
      _splitMemberIds.addAll(expense.splits.map((s) => s.memberId));
      _date = expense.date;
      _initialised = true;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initialiseDefaults(List<Member> members) {
    if (_initialised) return;
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    final self = members.where((m) => m.userId == userId).firstOrNull;
    setState(() {
      _payerMemberId = self?.id ?? members.firstOrNull?.id;
      _splitMemberIds.clear();
      _initialised = true;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _attachReceipt() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await ref.read(receiptCaptureServiceProvider).capture(source);
    if (path != null) setState(() => _receiptLocalPath = path);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amountMinor = Money.tryParseMajorToMinor(_amountController.text);
    if (amountMinor == null || amountMinor <= 0) return;
    if (_payerMemberId == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Could not determine payer.')),
        );
      return;
    }

    String? description;
    final title = _titleController.text.trim();
    final notes = _notesController.text.trim();
    if (title.isNotEmpty && notes.isNotEmpty) {
      description = '$title\n---\n$notes';
    } else if (title.isNotEmpty) {
      description = title;
    } else if (notes.isNotEmpty) {
      description = '\n---\n$notes';
    }

    final draft = ExpenseDraft(
      amountMinor: amountMinor,
      category: _category,
      paidByMemberId: _payerMemberId!,
      splitMemberIds: _splitMemberIds.toList(),
      date: _date,
      description: description,
      receiptLocalPath: _receiptLocalPath,
    );

    final ok = await ref.read(expenseFormControllerProvider.notifier).submit(
          tripId: widget.tripId,
          currency: widget.currency,
          draft: draft,
          expenseId: widget.expense?.id,
        );
    if (ok && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(tripMembersProvider(widget.tripId));
    final formState = ref.watch(expenseFormControllerProvider);

    ref.listen(expenseFormControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        final message =
            error is Failure ? error.displayMessage : 'Could not save.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    ref.listen(tripMembersProvider(widget.tripId), (_, next) {
      next.whenData((members) {
        if (!_initialised) {
          // Defer state mutation until after the current build phase completes
          Future.microtask(() => _initialiseDefaults(members));
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit expense' : 'Add expense')),
      body: membersAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
        ),
        data: (members) {
          return _buildForm(context, members, formState.isLoading);
        },
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<Member> members,
    bool isLoading,
  ) {
    final theme = Theme.of(context);
    final currentUserId = ref.read(authStateProvider).valueOrNull?.id;
    final isOwner = members.any((m) => m.userId == currentUserId && m.role == MemberRole.owner);

    // Find creator name
    String creatorName = 'Current User';
    if (_isEditing) {
      final creatorId = widget.expense?.createdBy;
      final creator = members.where((m) => m.userId == creatorId).firstOrNull;
      if (creator != null) creatorName = creator.displayName ?? 'Unknown';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: !_isEditing,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '${widget.currency} ',
                border: InputBorder.none,
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
              validator: (value) {
                final minor = Money.tryParseMajorToMinor(value ?? '');
                if (minor == null || minor <= 0) {
                  return 'Enter an amount greater than zero.';
                }
                return null;
              },
            ),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title (Recommended)',
                hintText: 'Petrol Indian Oil, Dinner at Thalassa...',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('${_date.day}/${_date.month}/${_date.year}'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Category', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final category in ExpenseCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        avatar: Icon(categoryIcon(category), size: 18),
                        label: Text(category.label),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ReceiptPicker(
              localPath: _receiptLocalPath,
              onAttach: _attachReceipt,
              onRemove: () => setState(() => _receiptLocalPath = null),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Status Info Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Added by: $creatorName', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Status: ${_isEditing ? widget.expense!.status.name : (isOwner ? "Approved" : "Pending Admin Approval")}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Advanced Options
            if (isOwner)
              ExpansionTile(
                title: const Text('Advanced Options'),
                childrenPadding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  DropdownButtonFormField<String>(
                    value: members.any((m) => m.id == _payerMemberId)
                        ? _payerMemberId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Paid by',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    items: [
                      for (final m in members)
                        DropdownMenuItem(
                          value: m.id,
                          child: Text(m.displayName ?? 'Member'),
                        ),
                    ],
                    onChanged: (value) => setState(() => _payerMemberId = value),
                  ),
                ],
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
                  : Text(_isEditing ? 'Save changes' : 'Add expense'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptPicker extends StatelessWidget {
  const _ReceiptPicker({
    required this.localPath,
    required this.onAttach,
    required this.onRemove,
  });

  final String? localPath;
  final VoidCallback onAttach;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (localPath == null) {
      return OutlinedButton.icon(
        onPressed: onAttach,
        icon: const Icon(Icons.receipt_long_outlined),
        label: const Text('Attach receipt'),
      );
    }
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: Image.file(
            File(localPath!),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(child: Text('Receipt attached')),
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Remove receipt',
          onPressed: onRemove,
        ),
      ],
    );
  }
}
