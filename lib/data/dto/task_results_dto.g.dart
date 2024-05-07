// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_results_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskResultsDto _$TaskResultsDtoFromJson(Map<String, dynamic> json) =>
    TaskResultsDto(
      json['count'] as int,
      json['total'] as int,
      json['page_size'] as int,
      json['current'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskResultsDtoToJson(TaskResultsDto instance) =>
    <String, dynamic>{
      'count': instance.count,
      'total': instance.total,
      'page_size': instance.pageSize,
      'current': instance.current,
      'results': instance.results,
    };
