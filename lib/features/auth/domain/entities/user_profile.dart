import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Account subscription tier (Data Design §7.1).
enum UserTier { free, premium }

/// App-level user profile extending the auth identity (Data Design §4.1).
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String displayName,
    @Default(UserTier.free) UserTier tier,
    String? avatarUrl,
    String? email,
    String? phone,
  }) = _UserProfile;
}
