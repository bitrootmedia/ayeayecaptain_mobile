import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/checklist_block_element_dto.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checklist_block_dto.g.dart';

@JsonSerializable()
class ChecklistBlockDto extends BlockDto {
  final String title;
  final List<ChecklistBlockElementDto> elements;

  ChecklistBlockDto(
    super.type,
    this.title,
    this.elements,
  );

  @override
  ChecklistBlock toDomain() => ChecklistBlock(
        type: type,
        title: title,
        elements: elements.map((e) => e.toDomain()).toList(),
      );

  factory ChecklistBlockDto.fromJson(Map<String, dynamic> json) =>
      _$ChecklistBlockDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChecklistBlockDtoToJson(this);
}
