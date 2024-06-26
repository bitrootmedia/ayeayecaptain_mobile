import 'package:ayeayecaptain_mobile/app/utils/error_messages.dart';
import 'package:ayeayecaptain_mobile/app/utils/failure_codes.dart';
import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/task_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/task_results_dto.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task_results.dart';
import 'package:ayeayecaptain_mobile/domain/task/interface/task_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:dio/dio.dart';

class TaskRepository implements domain.TaskRepository {
  final Dio _client;

  TaskRepository(this._client);

  @override
  Future<FailureOrResult<TaskResults>> getTasks({
    required Profile profile,
    required int page,
    required int pageSize,
    required String orderBy,
  }) async {
    final response = await _client.get(
      '${profile.backendUrl}/api/tasks',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        'ordering': orderBy,
      },
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    return FailureOrResult.success(
      TaskResultsDto.fromJson(response.data).toDomain(),
    );
  }

  @override
  Future<FailureOrResult<void>> saveTaskDetails({
    required Profile profile,
    required String taskId,
    required String title,
    required List<Block> blocks,
  }) async {
    try {
      await _client.patch(
        '${profile.backendUrl}/api/task/$taskId',
        data: {
          'title': title,
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
    try {
      final response = await _client.get(
        '${profile.backendUrl}/api/task/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${profile.token}',
        }),
      );

      final taskDto = TaskDto.fromJson(response.data as Map<String, dynamic>);
      return FailureOrResult.success(taskDto.toDomain());
    } on ArgumentError catch (e) {
      return FailureOrResult.failure(message: e.message);
    }
  }
}
