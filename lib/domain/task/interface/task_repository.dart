import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

abstract class TaskRepository {
  Future<FailureOrResult<List<Task>>> getTasks(Profile profile);
}
