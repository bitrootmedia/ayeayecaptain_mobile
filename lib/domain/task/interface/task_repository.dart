import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task_results.dart';

abstract class TaskRepository {
  Future<FailureOrResult<TaskResults>> getTasks({
    required Profile profile,
    required int page,
    required int pageSize,
    required String orderBy,
  });

  Future<FailureOrResult<void>> saveTaskDetails({
    required Profile profile,
    required String taskId,
    required String title,
    required List<Block> blocks,
  });

  Future<FailureOrResult<String>> createTask({
    required Profile profile,
    required String title,
    required bool addToUserQueue,
    required String queuePosition,
  });

  Future<FailureOrResult<Task>> getTask(
    Profile profile,
    String id,
  );
}
