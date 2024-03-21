import 'package:json_annotation/json_annotation.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  final String backendUrl;
  final String name;
  final String password;
  final String token;
  final bool isSelected;

  ProfileDto(
    this.backendUrl,
    this.name,
    this.password,
    this.token,
    this.isSelected,
  );

  Profile toDomain() => Profile(
        backendUrl: backendUrl,
        name: name,
        password: password,
        token: token,
        isSelected: isSelected,
      );

  factory ProfileDto.fromDomain(Profile domain) => ProfileDto(
        domain.backendUrl,
        domain.name,
        domain.password,
        domain.token,
        domain.isSelected,
      );

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
