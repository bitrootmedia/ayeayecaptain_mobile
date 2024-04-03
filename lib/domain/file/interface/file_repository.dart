import 'dart:io';

import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';

abstract class FileRepository {
  Future<FailureOrResult<String>> uploadFile({
    required Profile profile,
    required String taskId,
    required File file,
  });
}
