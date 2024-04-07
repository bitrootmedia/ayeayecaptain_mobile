import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_dto.g.dart';

@JsonSerializable()
class ProjectDto {
  final String id;
  final String title;
  final String description;
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  final int progress;
  final String? tag;
  @JsonKey(name: 'is_closed')
  final bool isClosed;

  ProjectDto(
    this.id,
    this.title,
    this.description,
    this.backgroundImage,
    this.progress,
    this.tag,
    this.isClosed,
  );

  Project toDomain() => Project(
        id: id,
        title: title,
        description: description,
        backgroundImage: backgroundImage,
        progress: progress,
        tag: tag,
        isClosed: isClosed,
      );

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDtoToJson(this);
}
