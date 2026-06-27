import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend.freezed.dart';

@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String friendUserId,
    required String displayName,
    required DateTime addedAt,
    String? username,
    String? avatarUrl,
    String? email,
  }) = _Friend;
}
