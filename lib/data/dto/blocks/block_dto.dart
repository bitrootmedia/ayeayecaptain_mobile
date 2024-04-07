import 'package:ayeayecaptain_mobile/data/dto/blocks/checklist_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/checklist_block_element_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/image_block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/markdown_block_dto.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';

abstract class BlockDto {
  final String type;

  BlockDto(this.type);

  Block toDomain();
  Map<String, dynamic> toJson();

  factory BlockDto.fromDomain(Block domain) {
    if (domain is MarkdownBlock) {
      return MarkdownBlockDto(
        'markdown',
        domain.content,
      );
    } else if (domain is ImageBlock) {
      return ImageBlockDto(
        'image',
        domain.path,
      );
    } else {
      return ChecklistBlockDto(
        'checklist',
        (domain as ChecklistBlock).title,
        domain.elements
            .map((e) => ChecklistBlockElementDto.fromDomain(e))
            .toList(),
      );
    }
  }
}
