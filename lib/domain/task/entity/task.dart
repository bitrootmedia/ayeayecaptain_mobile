import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:ayeayecaptain_mobile/domain/user/entity/user.dart';
import 'package:flutter/foundation.dart';

const orderByCreatedAt = 'created_at';
const orderByOwner = 'owner';
const orderByProject = 'project';
const orderByTitle = 'title';

@immutable
class Task {
  final String id;
  final String title;
  final String? status;
  final DateTime? etaDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String tag;
  final int progress;
  final String description;
  final List<Block> blocks;
  final Project? project;
  final int position;
  final User responsible;
  final User owner;
  final bool isClosed;
  final bool isUrgent;
  final List<Attachment>? attachments;
  final int? attachmentsTotal;
  final int? attachmentsPageSize;
  final int? attachmentsCurrentPage;
  final int? attachmentsPagesTotal;
  final String attachmentsOrderBy;

  const Task({
    required this.id,
    required this.title,
    this.status,
    this.etaDate,
    required this.createdAt,
    this.updatedAt,
    required this.tag,
    required this.progress,
    required this.description,
    required this.blocks,
    this.project,
    required this.position,
    required this.responsible,
    required this.owner,
    required this.isClosed,
    required this.isUrgent,
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
        status: status,
        etaDate: etaDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        tag: tag,
        progress: progress,
        description: description,
        blocks: blocks.map((e) => e.clone()).toList(),
        project: project,
        position: position,
        responsible: responsible,
        owner: owner,
        isClosed: isClosed,
        isUrgent: isUrgent,
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
        status: status,
        etaDate: etaDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        tag: tag,
        progress: progress,
        description: description,
        blocks: blocks,
        project: project,
        position: position,
        responsible: responsible,
        owner: owner,
        isClosed: isClosed,
        isUrgent: isUrgent,
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
