import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment_results.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

class GetTasksAction {
  final Profile profile;

  GetTasksAction(this.profile);
}

class UpdateTasksAction {
  final List<Task> tasks;

  UpdateTasksAction(this.tasks);
}

class ResetTasksAction {}

class PartiallyUpdateTaskAction {
  final String taskId;
  final List<Block> blocks;

  PartiallyUpdateTaskAction(this.taskId, this.blocks);
}

class UpdateLocalTaskAction {
  final Task task;

  UpdateLocalTaskAction(this.task);
}

class AddTaskAttachmentsAction {
  final String taskId;
  final AttachmentResults attachmentResults;
  final String orderBy;
  final bool shouldReset;

  AddTaskAttachmentsAction({
    required this.taskId,
    required this.attachmentResults,
    required this.orderBy,
    this.shouldReset = false,
  });
}

class GetTaskAttachmentsAction {
  final String taskId;
  final int page;
  final int pageSize;
  final String orderBy;
  final bool shouldReset;

  GetTaskAttachmentsAction({
    required this.taskId,
    required this.page,
    required this.pageSize,
    required this.orderBy,
    this.shouldReset = false,
  });
}

class UpdateTaskAttachmentsPageAction {
  final String taskId;
  final int page;

  UpdateTaskAttachmentsPageAction({
    required this.taskId,
    required this.page,
  });
}

class DeleteTaskAttachmentAction {
  final String id;
  final Task task;

  DeleteTaskAttachmentAction(
    this.id,
    this.task,
  );
}
