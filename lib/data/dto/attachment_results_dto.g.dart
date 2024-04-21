// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_results_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentResultsDto _$AttachmentResultsDtoFromJson(
        Map<String, dynamic> json) =>
    AttachmentResultsDto(
      json['count'] as int,
      json['total'] as int,
      json['page_size'] as int,
      json['current'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttachmentResultsDtoToJson(
        AttachmentResultsDto instance) =>
    <String, dynamic>{
      'count': instance.count,
      'total': instance.total,
      'page_size': instance.pageSize,
      'current': instance.current,
      'results': instance.results,
    };
