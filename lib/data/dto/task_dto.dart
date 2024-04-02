import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/checklist_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/image_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/markdown_block_dto.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto {
  final String id;
  final String title;
  @JsonKey(fromJson: _blocksFromJson)
  final List<BlockDto> blocks;

  TaskDto(
    this.id,
    this.title,
    this.blocks,
  );

  Task toDomain() => Task(
        id: id,
        title: title,
        blocks: blocks.map((e) => e.toDomain()).toList(),
      );

  static List<BlockDto> _blocksFromJson(List<dynamic> json) {
    return json.map((e) {
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
    }).toList();
  }

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}
