import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task_list_item.dart';

class TaskState {
  final List<TaskListItem>? tasks;
  final bool isAttachmentsLoading;
  final bool dataWasChanged;
  final Task? editingTask;
  final int? tasksTotal;
  final int? pagesTotal;
  final int pageSize;
  final int page;
  final bool isTasksLoading;
  final Task? task;

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
    required this.task,
  });

  TaskState.initial()
      : tasks = null,
        isAttachmentsLoading = false,
        dataWasChanged = false,
        editingTask = null,
        pagesTotal = null,
        tasksTotal = null,
        pageSize = tasksPageSize,
        page = 1,
        isTasksLoading = false,
        task = null;

  TaskState copyWith({
    Nullable<List<TaskListItem>>? tasks,
    bool? isAttachmentsLoading,
    bool? dataWasChanged,
    Task? editingTask,
    int? tasksTotal,
    int? pagesTotal,
    int? pageSize,
    int? page,
    bool? isTasksLoading,
    Task? task,
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
        task: task ?? this.task,
      );
}
