import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';

abstract class BlockDto {
  final String type;

  BlockDto(this.type);

  Block toDomain();
  Map<String, dynamic> toJson();
}
