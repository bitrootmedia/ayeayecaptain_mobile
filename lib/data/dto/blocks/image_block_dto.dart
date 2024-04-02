import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_block_dto.g.dart';

@JsonSerializable()
class ImageBlockDto extends BlockDto {
  final String path;

  ImageBlockDto(
    super.type,
    this.path,
  );

  @override
  ImageBlock toDomain() => ImageBlock(
        type: type,
        path: path,
      );

  factory ImageBlockDto.fromJson(Map<String, dynamic> json) =>
      _$ImageBlockDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ImageBlockDtoToJson(this);
}
