import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:flutter/foundation.dart';

@immutable
class AttachmentResults {
  final int attachmentsTotal;
  final int pagesTotal;
  final int pageSize;
  final int page;
  final List<Attachment> attachments;

  const AttachmentResults({
    required this.attachmentsTotal,
    required this.pagesTotal,
    required this.pageSize,
    required this.page,
    required this.attachments,
  });
}
