import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/task_dto.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/task/interface/task_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:dio/dio.dart';

class TaskRepository implements domain.TaskRepository {
  final Dio _client;

  TaskRepository(this._client);

  @override
  Future<FailureOrResult<List<Task>>> getTasks(Profile profile) async {
    final response = await _client.get(
      '${profile.backendUrl}/api/tasks',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    final tasksDto = (response.data['results'] as List)
        .map((e) => TaskDto.fromJson(e as Map<String, dynamic>));
    return FailureOrResult.success(tasksDto.map((e) => e.toDomain()).toList());
  }
}
