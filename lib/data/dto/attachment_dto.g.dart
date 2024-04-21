// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) =>
    AttachmentDto(
      json['id'] as String,
      json['title'] as String,
      DateTime.parse(json['created_at'] as String),
      json['file_path'] as String,
      json['thumbnail_path'] as String?,
      UserDto.fromJson(json['owner'] as Map<String, dynamic>),
      json['project'] == null
          ? null
          : ProjectDto.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttachmentDtoToJson(AttachmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt.toIso8601String(),
      'file_path': instance.filePath,
      'thumbnail_path': instance.thumbnailPath,
      'owner': instance.owner,
      'project': instance.project,
    };
