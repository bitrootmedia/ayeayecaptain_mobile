import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

class TaskState {
  final List<Task>? tasks;

  TaskState({
    required this.tasks,
  });

  TaskState.initial() : tasks = null;

  TaskState copyWith({
    Nullable<List<Task>>? tasks,
  }) =>
      TaskState(
        tasks: tasks == null ? this.tasks : tasks.value,
      );
}
