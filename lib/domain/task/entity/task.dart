import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:flutter/foundation.dart';

const orderByCreatedAt = 'created_at';
const orderByOwner = 'owner';
const orderByProject = 'project';
const orderByTitle = 'title';

@immutable
class Task {
  final String id;
  final String title;
  final List<Block> blocks;
  final List<Attachment>? attachments;
  final int? attachmentsTotal;
  final int? attachmentsPageSize;
  final int? attachmentsCurrentPage;
  final int? attachmentsPagesTotal;
  final String attachmentsOrderBy;

  const Task({
    required this.id,
    required this.title,
    required this.blocks,
    this.attachments,
    this.attachmentsTotal,
    this.attachmentsPageSize,
    this.attachmentsCurrentPage,
    this.attachmentsPagesTotal,
    this.attachmentsOrderBy = orderByCreatedAt,
  });

  Task clone() => Task(
        id: id,
        title: title,
        blocks: blocks.map((e) => e.clone()).toList(),
        attachments: attachments,
        attachmentsTotal: attachmentsTotal,
        attachmentsPageSize: attachmentsPageSize,
        attachmentsCurrentPage: attachmentsCurrentPage,
        attachmentsPagesTotal: attachmentsPagesTotal,
        attachmentsOrderBy: attachmentsOrderBy,
      );

  Task copyWith({
    List<Attachment>? attachments,
    int? attachmentsTotal,
    int? attachmentsPageSize,
    int? attachmentsCurrentPage,
    int? attachmentsPagesTotal,
    String? attachmentsOrderBy,
  }) =>
      Task(
        id: id,
        title: title,
        blocks: blocks,
        attachments: attachments ?? this.attachments,
        attachmentsTotal: attachmentsTotal ?? this.attachmentsTotal,
        attachmentsPageSize: attachmentsPageSize ?? this.attachmentsPageSize,
        attachmentsCurrentPage:
            attachmentsCurrentPage ?? this.attachmentsCurrentPage,
        attachmentsPagesTotal:
            attachmentsPagesTotal ?? this.attachmentsPagesTotal,
        attachmentsOrderBy: attachmentsOrderBy ?? this.attachmentsOrderBy,
      );
}
