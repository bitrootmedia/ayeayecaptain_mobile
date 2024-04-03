import 'dart:io';

import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/file/interface/file_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:dio/dio.dart';

class FileRepository implements domain.FileRepository {
  final Dio _client;

  FileRepository(this._client);

  @override
  Future<FailureOrResult<String>> uploadFile({
    required Profile profile,
    required String taskId,
    required File file,
  }) async {
    final fileName = file.path.split('/').last;
    final response = await _client.post(
      '${profile.backendUrl}/api/upload',
      data: FormData.fromMap({
        'task_id': taskId,
        fileName: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      }),
      options: Options(headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    final path = (response.data as Map<String, dynamic>)['attachments']
        .first['file_path'];
    return FailureOrResult.success(path);
  }
}
