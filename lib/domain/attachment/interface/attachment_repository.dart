import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment_results.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';

abstract class AttachmentRepository {
  Future<FailureOrResult<AttachmentResults>> getAttachments({
    required Profile profile,
    required String taskId,
    required int page,
    required int pageSize,
    required String orderBy,
  });
}
