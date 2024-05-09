import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/checklist_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/image_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/markdown_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/project_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/user_dto.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto {
  final String id;
  final String title;
  final String? status;
  @JsonKey(name: 'eta_date')
  final DateTime? etaDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String? tag;
  final int progress;
  final String description;
  @JsonKey(fromJson: _blocksFromJson)
  final List<BlockDto> blocks;
  final ProjectDto? project;
  final int? position;
  final UserDto? responsible;
  final UserDto owner;
  @JsonKey(name: 'is_closed')
  final bool isClosed;
  @JsonKey(name: 'is_urgent')
  final bool isUrgent;

  TaskDto(
    this.id,
    this.title,
    this.status,
    this.etaDate,
    this.createdAt,
    this.updatedAt,
    this.tag,
    this.progress,
    this.description,
    this.blocks,
    this.project,
    this.position,
    this.responsible,
    this.owner,
    this.isClosed,
    this.isUrgent,
  );

  Task toDomain() => Task(
        id: id,
        title: title,
        status: status,
        etaDate: etaDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        tag: tag,
        progress: progress,
        description: description,
        blocks: blocks.map((e) => e.toDomain()).toList(),
        project: project?.toDomain(),
        position: position,
        responsible: responsible?.toDomain(),
        owner: owner.toDomain(),
        isClosed: isClosed,
        isUrgent: isUrgent,
      );

  static List<BlockDto> _blocksFromJson(dynamic json) {
    return json is List
        ? json.map((e) {
            switch (e['type']) {
              case 'markdown':
                return MarkdownBlockDto.fromJson(e);
              case 'image':
                return ImageBlockDto.fromJson(e);
              case 'checklist':
                return ChecklistBlockDto.fromJson(e);
              default:
                throw ArgumentError('Unknown block type: ${e['type']}');
            }
          }).toList()
        : throw ArgumentError('This task has error: invalid json blocks');
  }

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}
