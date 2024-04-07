import 'package:flutter/foundation.dart';

@immutable
class Project {
  final String id;
  final String title;
  final String description;
  final String? backgroundImage;
  final int progress;
  final String? tag;
  final bool isClosed;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    this.backgroundImage,
    required this.progress,
    this.tag,
    required this.isClosed,
  });
}
