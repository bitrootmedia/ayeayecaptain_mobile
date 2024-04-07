import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:flutter/foundation.dart';

@immutable
class ImageBlock extends Block {
  final String path;

  const ImageBlock({
    required super.type,
    required this.path,
  });

  // ignore: prefer_const_constructors_in_immutables
  ImageBlock.empty()
      : path = '',
        super(type: 'image');

  @override
  ImageBlock clone() => ImageBlock(
        type: type,
        path: path,
      );

  @override
  ImageBlock copyWith({
    String? path,
  }) =>
      ImageBlock(
        type: type,
        path: path ?? this.path,
      );
}
