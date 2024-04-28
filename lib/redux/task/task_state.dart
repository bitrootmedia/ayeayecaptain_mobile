import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

class TaskState {
  final List<Task>? tasks;
  final bool isAttachmentsLoading;

  TaskState({
    required this.tasks,
    required this.isAttachmentsLoading,
  });

  TaskState.initial()
      : tasks = null,
        isAttachmentsLoading = false;

  TaskState copyWith({
    Nullable<List<Task>>? tasks,
    bool? isAttachmentsLoading,
  }) =>
      TaskState(
        tasks: tasks == null ? this.tasks : tasks.value,
        isAttachmentsLoading: isAttachmentsLoading ?? this.isAttachmentsLoading,
      );
}
