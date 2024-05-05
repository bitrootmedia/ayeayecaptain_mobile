import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

class TaskState {
  final List<Task>? tasks;
  final bool isAttachmentsLoading;
  final bool dataWasChanged;
  final Task? editingTask;

  TaskState({
    required this.tasks,
    required this.isAttachmentsLoading,
    required this.dataWasChanged,
    required this.editingTask,
  });

  TaskState.initial()
      : tasks = null,
        isAttachmentsLoading = false,
        dataWasChanged = false,
        editingTask = null;

  TaskState copyWith({
    Nullable<List<Task>>? tasks,
    bool? isAttachmentsLoading,
    bool? dataWasChanged,
    Task? editingTask,
  }) =>
      TaskState(
        tasks: tasks == null ? this.tasks : tasks.value,
        isAttachmentsLoading: isAttachmentsLoading ?? this.isAttachmentsLoading,
        dataWasChanged: dataWasChanged ?? this.dataWasChanged,
        editingTask: editingTask ?? this.editingTask,
      );
}
