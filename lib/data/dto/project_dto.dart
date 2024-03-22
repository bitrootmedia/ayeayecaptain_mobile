import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_dto.g.dart';

@JsonSerializable()
class ProjectDto {
  final String id;
  final String title;

  ProjectDto(
    this.id,
    this.title,
  );

  Project toDomain() => Project(
        id: id,
        title: title,
      );

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDtoToJson(this);
}
