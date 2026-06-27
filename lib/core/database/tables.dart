import 'package:drift/drift.dart';

/// Local mirror of the server `trips` table (DB Design §4.2) plus offline sync
/// metadata (DB Design §8). Money is stored in integer minor units — never a
/// float (CLAUDE.md §13).
@DataClassName('TripRow')
class Trips extends Table {
  /// Client-generated UUID = durable id (offline-first, DB Design §8).
  TextColumn get id => text()();

  TextColumn get ownerId => text()();

  TextColumn get name => text().withLength(min: 1, max: 60)();

  TextColumn get destination => text().nullable()();

  DateTimeColumn get startDate => dateTime().nullable()();

  DateTimeColumn get endDate => dateTime().nullable()();

  TextColumn get currency => text().withLength(min: 3, max: 3)();

  /// Total budget in minor units (e.g. paise/cents). Null = no budget set.
  IntColumn get totalBudgetMinor => integer().nullable()();

  /// `active` | `archived` | `deleted` (DB Design §4.2).
  TextColumn get status => text().withDefault(const Constant('active'))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Optimistic-concurrency counter (DB Design §8).
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// Local sync bookkeeping: `synced` | `pending` | `failed` (Drift-only).
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local mirror of `trip_members` (DB Design §4.3) with the member's profile
/// display fields denormalized for roster rendering, plus sync metadata.
@DataClassName('MemberRow')
class Members extends Table {
  TextColumn get id => text()();

  TextColumn get tripId => text()();

  TextColumn get userId => text()();

  /// `owner` | `member` | `admin` (admin reserved, v1.5).
  TextColumn get role => text().withDefault(const Constant('member'))();

  /// `active` | `removed`.
  TextColumn get status => text().withDefault(const Constant('active'))();

  TextColumn get displayName => text().nullable()();

  TextColumn get avatarUrl => text().nullable()();

  DateTimeColumn get joinedAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local mirror of the server `expenses` table (DB Design §4.5) plus offline
/// sync + receipt-upload metadata. Money is stored in integer minor units.
@DataClassName('ExpenseRow')
class Expenses extends Table {
  TextColumn get id => text()();

  TextColumn get tripId => text()();

  /// The member who paid (DB Design §4.5 paid_by).
  TextColumn get paidByMemberId => text()();

  IntColumn get amountMinor => integer()();

  TextColumn get currency => text().withLength(min: 3, max: 3)();

  /// Category enum value (DB Design §4.5).
  TextColumn get category => text()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get expenseDate => dateTime()();

  /// `pending` | `approved` | `rejected` (DB Design §4.5).
  TextColumn get status => text().withDefault(const Constant('approved'))();

  /// `equal` | `custom` | `percentage` (equal only in v1.0).
  TextColumn get splitType => text().withDefault(const Constant('equal'))();

  /// Local cached receipt path before upload (Architecture §10).
  TextColumn get receiptLocalPath => text().nullable()();

  /// Storage object path once uploaded.
  TextColumn get receiptStoragePath => text().nullable()();

  /// `pending` | `uploaded` | `failed`, or null when there is no receipt.
  TextColumn get receiptUploadStatus => text().nullable()();

  TextColumn get createdBy => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get version => integer().withDefault(const Constant(1))();

  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local mirror of `expense_splits` (DB Design §4.6). One share per member.
@DataClassName('ExpenseSplitRow')
class ExpenseSplits extends Table {
  TextColumn get id => text()();

  TextColumn get expenseId => text()();

  TextColumn get memberId => text()();

  IntColumn get shareMinor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {expenseId, memberId},
      ];
}

/// Local mirror of the server `settlements` table (DB Design §4.7) plus offline
/// sync metadata. Only **completed** payments are persisted here — the
/// outstanding who-pays-who graph is computed on the fly from approved expenses
/// (Settlement is a deterministic projection, recomputed locally). Money is in
/// integer minor units.
@DataClassName('SettlementRow')
class Settlements extends Table {
  TextColumn get id => text()();

  TextColumn get tripId => text()();

  /// The debtor — `from_member` (DB Design §4.7).
  TextColumn get fromMemberId => text()();

  /// The creditor — `to_member` (DB Design §4.7).
  TextColumn get toMemberId => text()();

  IntColumn get amountMinor => integer()();

  /// `pending` | `completed` (DB Design §4.7). The client only ever writes
  /// `completed`; pending is reserved for the server `compute_settlement` RPC.
  TextColumn get status => text().withDefault(const Constant('completed'))();

  /// `trip_members.id` of whoever marked it paid (DB Design §4.7).
  TextColumn get markedByMemberId => text().nullable()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get version => integer().withDefault(const Constant(1))();

  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local cache of accepted friends (offline-first, no server sync needed for MVP).
@DataClassName('FriendRow')
class Friends extends Table {
  TextColumn get id => text()();

  /// The friend's Supabase auth uid.
  TextColumn get friendUserId => text()();

  TextColumn get displayName => text()();

  TextColumn get username => text().nullable()();

  TextColumn get avatarUrl => text().nullable()();

  TextColumn get email => text().nullable()();

  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {friendUserId},
      ];
}

/// Pre-trip budget planning items (local-only, per trip).
@DataClassName('TripPlanItemRow')
class TripPlanItems extends Table {
  TextColumn get id => text()();

  TextColumn get tripId => text()();

  TextColumn get name => text().withLength(min: 1, max: 80)();

  TextColumn get category => text().nullable()();

  IntColumn get estimatedAmountMinor => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local-only forecast/planning items for a trip (never synced to server).
/// Lets users plan future spending and see projected remaining budget.
@DataClassName('ForecastItemRow')
class ForecastItems extends Table {
  TextColumn get id => text()();

  TextColumn get tripId => text()();

  TextColumn get name => text().withLength(min: 1, max: 80)();

  /// Planned amount in minor units (paise/cents).
  IntColumn get amountMinor => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Durable offline write queue (DB Design §7.10 SyncQueueItem). Drained by the
/// sync engine in dependency order (Architecture §6).
@DataClassName('SyncQueueRow')
class SyncQueueItems extends Table {
  TextColumn get id => text()();

  /// e.g. `trip` (Architecture §6 dependency ordering key).
  TextColumn get entityType => text()();

  TextColumn get entityId => text()();

  /// `create` | `update` | `delete`.
  TextColumn get operation => text()();

  /// JSON-encoded payload for the operation.
  TextColumn get payload => text()();

  IntColumn get attemptCount => integer().withDefault(const Constant(0))();

  /// `queued` | `failed`.
  TextColumn get status => text().withDefault(const Constant('queued'))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
