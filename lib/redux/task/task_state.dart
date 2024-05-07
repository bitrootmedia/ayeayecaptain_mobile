import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

class TaskState {
  final List<Task>? tasks;
  final bool isAttachmentsLoading;
  final bool dataWasChanged;
  final Task? editingTask;
  final int? tasksTotal;
  final int? pagesTotal;
  final int? pageSize;
  final int? page;
  final bool isTasksLoading;

  TaskState({
    required this.tasks,
    required this.isAttachmentsLoading,
    required this.dataWasChanged,
    required this.editingTask,
    required this.pagesTotal,
    required this.tasksTotal,
    required this.pageSize,
    required this.page,
    required this.isTasksLoading,
  });

  TaskState.initial()
      : tasks = null,
        isAttachmentsLoading = false,
        dataWasChanged = false,
        editingTask = null,
        pagesTotal = null,
        tasksTotal = null,
        pageSize = null,
        page = null,
        isTasksLoading = false;

  TaskState copyWith({
    Nullable<List<Task>>? tasks,
    bool? isAttachmentsLoading,
    bool? dataWasChanged,
    Task? editingTask,
    int? tasksTotal,
    int? pagesTotal,
    int? pageSize,
    int? page,
    bool? isTasksLoading,
  }) =>
      TaskState(
        tasks: tasks == null ? this.tasks : tasks.value,
        isAttachmentsLoading: isAttachmentsLoading ?? this.isAttachmentsLoading,
        dataWasChanged: dataWasChanged ?? this.dataWasChanged,
        editingTask: editingTask ?? this.editingTask,
        tasksTotal: tasksTotal ?? this.tasksTotal,
        pagesTotal: pagesTotal ?? this.pagesTotal,
        pageSize: pageSize ?? this.pageSize,
        page: page ?? this.page,
        isTasksLoading: isTasksLoading ?? this.isTasksLoading,
      );
}
