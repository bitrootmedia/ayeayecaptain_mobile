import 'package:flutter/foundation.dart';

@immutable
class Task {
  final String id;
  final String title;

  const Task({
    required this.id,
    required this.title,
  });
}
