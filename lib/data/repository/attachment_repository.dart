import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/attachment_results_dto.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment_results.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/interface/attachment_repository.dart'
    as domain;
import 'package:dio/dio.dart';

class AttachmentRepository implements domain.AttachmentRepository {
  final Dio _client;

  AttachmentRepository(this._client);

  @override
  Future<FailureOrResult<AttachmentResults>> getAttachments({
    required Profile profile,
    required String taskId,
    required int page,
    required int pageSize,
    required String orderBy,
  }) async {
    final response = await _client.get(
      '${profile.backendUrl}/api/attachments',
      queryParameters: {
        'task': taskId,
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
      AttachmentResultsDto.fromJson(response.data).toDomain(),
    );
  }

  @override
  Future<FailureOrResult<void>> deleteAttachment({
    required Profile profile,
    required String id,
  }) async {
    await _client.delete(
      '${profile.backendUrl}/api/attachment/$id',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    return FailureOrResult.success(null);
  }
}
