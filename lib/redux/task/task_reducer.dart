import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/task_state.dart';
import 'package:redux/redux.dart';

class TaskReducer extends ReducerClass<TaskState> {
  @override
  TaskState call(TaskState state, action) {
    return combineReducers<TaskState>([
      TypedReducer(_getTasks).call,
      TypedReducer(_addTask).call,
      TypedReducer(_addTasks).call,
      TypedReducer(_updateTasksPage).call,
      TypedReducer(_resetTasks).call,
      TypedReducer(_getTaskAttachments).call,
      TypedReducer(_addTaskAttachments).call,
      TypedReducer(_updateTaskAttachmentsPage).call,
      TypedReducer(_updateTaskDataWasChanged).call,
    ])(state, action);
  }

  TaskState _getTasks(
    TaskState state,
    GetTasksAction action,
  ) =>
      state.copyWith(
        isTasksLoading: true,
      );

  TaskState _addTask(
    TaskState state,
    AddTaskAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(
          [
            ...?state.tasks,
            action.task,
          ],
        ),
      );

  TaskState _addTasks(
    TaskState state,
    AddTasksAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(
          action.shouldReset
              ? action.taskResults.tasks
              : [
                  ...?state.tasks,
                  ...action.taskResults.tasks,
                ],
        ),
        tasksTotal: action.taskResults.tasksTotal,
        pageSize: action.taskResults.pageSize,
        page: action.taskResults.page,
        pagesTotal: action.taskResults.pagesTotal,
        isTasksLoading: false,
      );

  TaskState _updateTasksPage(
    TaskState state,
    UpdateTasksPageAction action,
  ) =>
      state.copyWith(
        page: action.page,
      );

  TaskState _resetTasks(
    TaskState state,
    ResetTasksAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(null),
      );

  TaskState _updateTaskDataWasChanged(
    TaskState state,
    UpdateTaskDataWasChangedAction action,
  ) =>
      state.copyWith(
        dataWasChanged: action.wasChanged,
        editingTask: action.editingTask,
      );

  TaskState _getTaskAttachments(
    TaskState state,
    GetTaskAttachmentsAction action,
  ) =>
      state.copyWith(
        isAttachmentsLoading: true,
      );

  TaskState _addTaskAttachments(
    TaskState state,
    AddTaskAttachmentsAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(state.tasks
            ?.map((e) => e.id == action.taskId
                ? e.copyWith(
                    attachments: action.shouldReset
                        ? action.attachmentResults.attachments
                        : [
                            ...?e.attachments,
                            ...action.attachmentResults.attachments,
                          ],
                    attachmentsTotal: action.attachmentResults.attachmentsTotal,
                    attachmentsPageSize: action.attachmentResults.pageSize,
                    attachmentsCurrentPage: action.attachmentResults.page,
                    attachmentsPagesTotal: action.attachmentResults.pagesTotal,
                    attachmentsOrderBy: action.orderBy,
                  )
                : e)
            .toList()),
        isAttachmentsLoading: false,
      );

  TaskState _updateTaskAttachmentsPage(
    TaskState state,
    UpdateTaskAttachmentsPageAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(state.tasks
            ?.map((e) => e.id == action.taskId
                ? e.copyWith(
                    attachmentsCurrentPage: action.page,
                  )
                : e)
            .toList()),
      );
}
