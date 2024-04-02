// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_block_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistBlockDto _$ChecklistBlockDtoFromJson(Map<String, dynamic> json) =>
    ChecklistBlockDto(
      json['type'] as String,
      json['title'] as String,
      (json['elements'] as List<dynamic>)
          .map((e) =>
              ChecklistBlockElementDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChecklistBlockDtoToJson(ChecklistBlockDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'elements': instance.elements,
    };
