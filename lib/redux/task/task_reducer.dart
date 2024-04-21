import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/task_state.dart';
import 'package:redux/redux.dart';

class TaskReducer extends ReducerClass<TaskState> {
  @override
  TaskState call(TaskState state, action) {
    return combineReducers<TaskState>([
      TypedReducer(_updateTasks).call,
      TypedReducer(_resetTasks).call,
      TypedReducer(_updateLocalTask).call,
      TypedReducer(_addTaskAttachments).call,
      TypedReducer(_updateTaskAttachmentsPage).call,
    ])(state, action);
  }

  TaskState _updateTasks(
    TaskState state,
    UpdateTasksAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(action.tasks),
      );

  TaskState _updateLocalTask(
    TaskState state,
    UpdateLocalTaskAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(state.tasks!
            .map((e) => e.id == action.task.id ? action.task : e)
            .toList()),
      );

  TaskState _resetTasks(
    TaskState state,
    ResetTasksAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(null),
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
                  )
                : e)
            .toList()),
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
