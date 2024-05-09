import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:ayeayecaptain_mobile/domain/user/entity/user.dart';
import 'package:flutter/foundation.dart';

@immutable
class TaskListItem {
  final String id;
  final String title;
  final String? status;
  final DateTime? etaDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? tag;
  final int progress;
  final Project? project;
  final int? position;
  final User? responsible;
  final User owner;
  final bool isClosed;
  final bool isUrgent;
  final int page;

  const TaskListItem({
    required this.id,
    required this.title,
    this.status,
    this.etaDate,
    required this.createdAt,
    this.updatedAt,
    required this.tag,
    required this.progress,
    this.project,
    required this.position,
    required this.responsible,
    required this.owner,
    required this.isClosed,
    required this.isUrgent,
    required this.page,
  });
}
