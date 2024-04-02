import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';
import 'package:json_annotation/json_annotation.dart';

part 'markdown_block_dto.g.dart';

@JsonSerializable()
class MarkdownBlockDto extends BlockDto {
  final String content;

  MarkdownBlockDto(
    super.type,
    this.content,
  );

  @override
  MarkdownBlock toDomain() => MarkdownBlock(
        type: type,
        content: content,
      );

  factory MarkdownBlockDto.fromJson(Map<String, dynamic> json) =>
      _$MarkdownBlockDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MarkdownBlockDtoToJson(this);
}
