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
    ])(state, action);
  }

  TaskState _updateTasks(
    TaskState state,
    UpdateTasksAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(action.tasks),
      );

  TaskState _resetTasks(
    TaskState state,
    ResetTasksAction action,
  ) =>
      state.copyWith(
        tasks: Nullable(null),
      );
}
