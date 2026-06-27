import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Supabase Storage access for receipts (Architecture §10). Objects are pathed
/// `trip_id/expense_id/<uuid>.<ext>` so Storage RLS aligns with trip
/// membership. Reads use short-lived signed URLs only (CLAUDE.md §13).
class ReceiptRemoteDataSource {
  ReceiptRemoteDataSource(this._client, {Uuid uuid = const Uuid()})
      : _uuid = uuid;

  static const _bucket = 'receipts';
  static const _signedUrlTtlSeconds = 3600;

  final SupabaseClient _client;
  final Uuid _uuid;

  /// Uploads [localPath] and returns the bucket-relative object path.
  Future<String> upload({
    required String tripId,
    required String expenseId,
    required String localPath,
  }) async {
    final ext =
        p.extension(localPath).isEmpty ? '.jpg' : p.extension(localPath);
    final objectPath = '$tripId/$expenseId/${_uuid.v4()}$ext';
    await _client.storage.from(_bucket).upload(
          objectPath,
          File(localPath),
          fileOptions: const FileOptions(upsert: true),
        );
    return objectPath;
  }

  /// Creates a short-lived signed URL for an uploaded receipt.
  Future<String> signedUrl(String objectPath) {
    return _client.storage
        .from(_bucket)
        .createSignedUrl(objectPath, _signedUrlTtlSeconds);
  }
}
