import 'package:flutter/foundation.dart';

@immutable
class Project {
  final String id;
  final String title;

  const Project({
    required this.id,
    required this.title,
  });
}
