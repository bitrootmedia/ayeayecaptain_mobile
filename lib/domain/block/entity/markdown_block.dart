import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:flutter/foundation.dart';

@immutable
class MarkdownBlock extends Block {
  final String content;

  const MarkdownBlock({
    required super.type,
    required this.content,
  });

  const MarkdownBlock.empty()
      : content = '',
        super(type: 'markdown');

  @override
  MarkdownBlock clone() => MarkdownBlock(
        type: type,
        content: content,
      );

  @override
  MarkdownBlock copyWith({
    String? content,
  }) =>
      MarkdownBlock(
        type: type,
        content: content ?? this.content,
      );
}
