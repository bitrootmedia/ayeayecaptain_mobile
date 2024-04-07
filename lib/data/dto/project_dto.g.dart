// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDto _$ProjectDtoFromJson(Map<String, dynamic> json) => ProjectDto(
      json['id'] as String,
      json['title'] as String,
      json['description'] as String?,
      json['background_image'] as String?,
      json['progress'] as int,
      json['tag'] as String?,
      json['is_closed'] as bool,
    );

Map<String, dynamic> _$ProjectDtoToJson(ProjectDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'background_image': instance.backgroundImage,
      'progress': instance.progress,
      'tag': instance.tag,
      'is_closed': instance.isClosed,
    };
