import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:flutter/foundation.dart';

@immutable
class TaskResults {
  final int tasksTotal;
  final int pagesTotal;
  final int pageSize;
  final int page;
  final List<Task> tasks;

  const TaskResults({
    required this.tasksTotal,
    required this.pagesTotal,
    required this.pageSize,
    required this.page,
    required this.tasks,
  });
}
