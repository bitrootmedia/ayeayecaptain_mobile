import 'package:json_annotation/json_annotation.dart';
import 'package:ayeayecaptain_mobile/domain/user/entity/user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final int id;
  final String name;
  final String email;
  final DateTime created;

  UserDto(
    this.id,
    this.name,
    this.email,
    this.created,
  );

  User toDomain() => User(
        id: id,
        name: name,
        email: email,
        created: created,
      );

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
