import 'package:supabase_flutter/supabase_flutter.dart';

/// A single notification row from the `notifications` table.
class NotificationRow {
  const NotificationRow({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.tripId,
    this.payload,
  });

  factory NotificationRow.fromJson(Map<String, dynamic> json) {
    return NotificationRow(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      tripId: json['trip_id'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }

  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? tripId;
  final Map<String, dynamic>? payload;

  String? get inviteCode => payload?['invite_code'] as String?;
}

/// Reads and updates the `notifications` table (RLS: user sees only own rows).
class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource(this._client);

  static const _table = 'notifications';
  final SupabaseClient _client;

  /// Returns all unread notifications for the current user, newest first.
  Future<List<NotificationRow>> fetchUnread() async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('is_read', false)
        .order('created_at', ascending: false)
        .limit(50);
    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(NotificationRow.fromJson)
        .toList();
  }

  /// Marks a single notification as read.
  Future<void> markRead(String notificationId) async {
    await _client
        .from(_table)
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Marks all unread notifications as read.
  Future<void> markAllRead() async {
    await _client
        .from(_table)
        .update({'is_read': true})
        .eq('is_read', false);
  }
}
