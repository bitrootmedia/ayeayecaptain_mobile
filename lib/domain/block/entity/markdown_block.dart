import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';

class MarkdownBlock extends Block {
  String content;

  MarkdownBlock({
    required super.type,
    required this.content,
  });

  // ignore: prefer_const_constructors_in_immutables
  MarkdownBlock.empty()
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
