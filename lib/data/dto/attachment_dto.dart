import 'package:ayeayecaptain_mobile/data/dto/project_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/user_dto.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment_dto.g.dart';

@JsonSerializable()
class AttachmentDto {
  final String id;
  final String title;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'file_path')
  final String filePath;
  @JsonKey(name: 'thumbnail_path')
  final String thumbnailPath;
  final UserDto owner;
  final ProjectDto project;

  AttachmentDto(
    this.id,
    this.title,
    this.createdAt,
    this.filePath,
    this.thumbnailPath,
    this.owner,
    this.project,
  );

  Attachment toDomain() => Attachment(
        id: id,
        title: title,
        createdAt: createdAt,
        filePath: filePath,
        thumbnailPath: thumbnailPath,
        owner: owner.toDomain(),
        project: project.toDomain(),
      );

  factory AttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentDtoToJson(this);
}
