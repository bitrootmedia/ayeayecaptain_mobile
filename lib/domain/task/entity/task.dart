import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:flutter/foundation.dart';

@immutable
class Task {
  final String id;
  final String title;
  final List<Block> blocks;

  const Task({
    required this.id,
    required this.title,
    required this.blocks,
  });
}
