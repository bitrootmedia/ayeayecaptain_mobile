import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/attachment_dto.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/interface/attachment_repository.dart'
    as domain;
import 'package:dio/dio.dart';

class AttachmentRepository implements domain.AttachmentRepository {
  final Dio _client;

  AttachmentRepository(this._client);

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
