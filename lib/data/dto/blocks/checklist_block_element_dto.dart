import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block_element.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checklist_block_element_dto.g.dart';

@JsonSerializable()
class ChecklistBlockElementDto {
  final String label;
  final bool checked;

  ChecklistBlockElementDto(
    this.label,
    this.checked,
  );

  ChecklistBlockElement toDomain() => ChecklistBlockElement(
        label: label,
        checked: checked,
      );

  factory ChecklistBlockElementDto.fromDomain(ChecklistBlockElement domain) =>
      ChecklistBlockElementDto(
        domain.label,
        domain.checked,
      );

  factory ChecklistBlockElementDto.fromJson(Map<String, dynamic> json) =>
      _$ChecklistBlockElementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistBlockElementDtoToJson(this);
}
