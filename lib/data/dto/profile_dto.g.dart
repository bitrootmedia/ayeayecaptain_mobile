// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
      json['backendUrl'] as String,
      json['name'] as String,
      json['password'] as String,
      json['token'] as String,
      json['isSelected'] as bool,
    );

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'backendUrl': instance.backendUrl,
      'name': instance.name,
      'password': instance.password,
      'token': instance.token,
      'isSelected': instance.isSelected,
    };
