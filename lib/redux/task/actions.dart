import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

class GetTasksAction {
  final Profile profile;

  GetTasksAction(this.profile);
}

class UpdateTasksAction {
  final List<Task> tasks;

  UpdateTasksAction(this.tasks);
}

class ResetTasksAction {}
