import 'package:ayeayecaptain_mobile/app/utils/failure_codes.dart';
import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/attachment_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/task_dto.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
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
  Future<FailureOrResult<Task>> partiallyUpdateTask({
    required Profile profile,
    required String taskId,
    required List<Block> blocks,
  }) async {
    try {
      final response = await _client.patch(
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

      final task = TaskDto.fromJson(response.data as Map<String, dynamic>);
      return FailureOrResult.success(task.toDomain());
    } on DioException catch (e) {
      return FailureOrResult.failure(
        code: FailureCodes.unknownError,
        message:
            'Response status message: ${e.response?.statusMessage}, code ${e.response?.statusCode};\nError message: ${e.message};\nError: ${e.error}',
      );
    }
  }

  @override
  Future<FailureOrResult<List<Attachment>>> getAttachments({
    required Profile profile,
    required String taskId,
    required int page,
    int pageSize = 10,
  }) async {
    final response = await _client.get(
      '${profile.backendUrl}/api/attachments',
      queryParameters: {
        'task': taskId,
        'page': page,
        'page_size': pageSize,
      },
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    final attachmentsDto = (response.data['results'] as List)
        .map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>));
    return FailureOrResult.success(
        attachmentsDto.map((e) => e.toDomain()).toList());
  }
}
