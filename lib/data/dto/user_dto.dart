import 'package:ayeayecaptain_mobile/domain/user/entity/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  UserDto(
    this.id,
    this.username,
    this.firstName,
    this.lastName,
  );

  User toDomain() => User(
        id: id,
        username: username,
        firstName: firstName,
        lastName: lastName,
      );

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
