import 'package:ayeayecaptain_mobile/app/utils/error_messages.dart';
import 'package:ayeayecaptain_mobile/app/utils/failure_codes.dart';
import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/task_dto.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
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

  @override
  Future<FailureOrResult<void>> partiallyUpdateTask({
    required Profile profile,
    required String taskId,
    required List<Block> blocks,
  }) async {
    try {
      await _client.patch(
        '${profile.backendUrl}/api/task/$taskId',
        data: {
          'blocks': blocks
              .map((e) => BlockDto.fromDomain(e))
              .map((e) => e.toJson())
              .toList(),
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${profile.token}',
        }),
      );

      return FailureOrResult.success(null);
    } on DioException catch (e) {
      return FailureOrResult.failure(
        code: FailureCodes.unknownError,
        message: getUnknownDioErrorMessage(e),
      );
    }
  }

  @override
  Future<FailureOrResult<String>> createTask({
    required Profile profile,
    required String title,
    required bool addToUserQueue,
    required String queuePosition,
  }) async {
    try {
      final response = await _client.post(
        '${profile.backendUrl}/api/tasks',
        data: {
          'title': title,
          'project': null,
          if (addToUserQueue) 'add_to_user_queue': true,
          if (addToUserQueue) 'queue_position': queuePosition,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${profile.token}',
        }),
      );

      return FailureOrResult.success(response.data['id']);
    } on DioException catch (e) {
      return FailureOrResult.failure(
        code: FailureCodes.unknownError,
        message: getUnknownDioErrorMessage(e),
      );
    }
  }

  @override
  Future<FailureOrResult<Task>> getTask(
    Profile profile,
    String id,
  ) async {
    final response = await _client.get(
      '${profile.backendUrl}/api/task/$id',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    final taskDto = TaskDto.fromJson(response.data as Map<String, dynamic>);
    return FailureOrResult.success(taskDto.toDomain());
  }
}
