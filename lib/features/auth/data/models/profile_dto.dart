import 'package:json_annotation/json_annotation.dart';
import 'package:tripmate/features/auth/domain/entities/user_profile.dart';

part 'profile_dto.g.dart';

/// Wire model for the `profiles` table (Data Design §4.1). Field names are
/// snake_case to match PostgREST (CLAUDE.md §2).
@JsonSerializable()
class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.displayName,
    required this.tier,
    this.avatarUrl,
    this.email,
    this.phone,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  final String id;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String tier;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);

  /// Maps the wire model to a domain [UserProfile].
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      displayName: displayName,
      tier: tier == 'premium' ? UserTier.premium : UserTier.free,
      avatarUrl: avatarUrl,
      email: email,
      phone: phone,
    );
  }
}
