import 'package:tripmate/core/utils/money.dart';

/// Wire model for a `expense_splits` row (DB Design §4.6). Money crosses as
/// numeric major units; locally we use integer minor units.
class ExpenseSplitDto {
  const ExpenseSplitDto({required this.memberId, required this.shareMinor});

  factory ExpenseSplitDto.fromJson(Map<String, dynamic> json) {
    return ExpenseSplitDto(
      memberId: json['member_id'] as String,
      shareMinor: Money.majorToMinor(json['share_amount']) ?? 0,
    );
  }

  final String memberId;
  final int shareMinor;
}

/// Wire model for an `expenses` row with embedded splits (DB Design §4.5).
class ExpenseDto {
  const ExpenseDto({
    required this.id,
    required this.tripId,
    required this.paidByMemberId,
    required this.amountMinor,
    required this.currency,
    required this.category,
    required this.expenseDate,
    required this.status,
    required this.splitType,
    required this.createdBy,
    required this.version,
    required this.updatedAt,
    required this.splits,
    this.description,
    this.receiptStoragePath,
    this.deletedAt,
  });

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    final rawSplits = json['expense_splits'];
    final splits = rawSplits is List
        ? rawSplits
            .cast<Map<String, dynamic>>()
            .map(ExpenseSplitDto.fromJson)
            .toList()
        : <ExpenseSplitDto>[];
    return ExpenseDto(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      paidByMemberId: json['paid_by'] as String,
      amountMinor: Money.majorToMinor(json['amount']) ?? 0,
      currency: json['currency'] as String,
      category: json['category'] as String,
      expenseDate: DateTime.parse(json['expense_date'] as String),
      status: json['status'] as String? ?? 'approved',
      splitType: json['split_type'] as String? ?? 'equal',
      createdBy: json['created_by'] as String,
      version: (json['version'] as num?)?.toInt() ?? 1,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      splits: splits,
      description: json['description'] as String?,
      receiptStoragePath: json['receipt_storage_path'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.tryParse(json['deleted_at'].toString()),
    );
  }

  final String id;
  final String tripId;
  final String paidByMemberId;
  final int amountMinor;
  final String currency;
  final String category;
  final DateTime expenseDate;
  final String status;
  final String splitType;
  final String createdBy;
  final int version;
  final DateTime updatedAt;
  final List<ExpenseSplitDto> splits;
  final String? description;
  final String? receiptStoragePath;
  final DateTime? deletedAt;
}
