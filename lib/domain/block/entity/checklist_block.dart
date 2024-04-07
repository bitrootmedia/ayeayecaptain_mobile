import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block_element.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChecklistBlock extends Block {
  final String title;
  final List<ChecklistBlockElement> elements;

  const ChecklistBlock({
    required super.type,
    required this.title,
    required this.elements,
  });

  // ignore: prefer_const_constructors_in_immutables
  ChecklistBlock.empty()
      : title = '',
        elements = [],
        super(type: 'checklist');

  bool get isEmpty => title.isEmpty && elements.isEmpty;

  @override
  ChecklistBlock clone() => ChecklistBlock(
        type: type,
        title: title,
        elements: elements.map((e) => e.clone()).toList(),
      );

  @override
  ChecklistBlock copyWith({
    String? title,
    List<ChecklistBlockElement>? elements,
  }) =>
      ChecklistBlock(
        type: type,
        title: title ?? this.title,
        elements: elements ?? this.elements,
      );
}
