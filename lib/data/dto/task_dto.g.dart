// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
      json['id'] as String,
      json['title'] as String,
      json['status'] as String?,
      json['eta_date'] == null
          ? null
          : DateTime.parse(json['eta_date'] as String),
      DateTime.parse(json['created_at'] as String),
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      json['tag'] as String?,
      json['progress'] as int,
      json['description'] as String,
      TaskDto._blocksFromJson(json['blocks']),
      json['project'] == null
          ? null
          : ProjectDto.fromJson(json['project'] as Map<String, dynamic>),
      json['position'] as int?,
      json['responsible'] == null
          ? null
          : UserDto.fromJson(json['responsible'] as Map<String, dynamic>),
      UserDto.fromJson(json['owner'] as Map<String, dynamic>),
      json['is_closed'] as bool,
      json['is_urgent'] as bool,
    );

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'eta_date': instance.etaDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'tag': instance.tag,
      'progress': instance.progress,
      'description': instance.description,
      'blocks': instance.blocks,
      'project': instance.project,
      'position': instance.position,
      'responsible': instance.responsible,
      'owner': instance.owner,
      'is_closed': instance.isClosed,
      'is_urgent': instance.isUrgent,
    };
