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
  final bool shouldReset;

  AddTaskAttachmentsAction({
    required this.taskId,
    required this.attachmentResults,
    this.shouldReset = false,
  });
}

class GetTaskAttachmentsAction {
  final String taskId;
  final int page;
  final int pageSize;
  final bool shouldReset;

  GetTaskAttachmentsAction({
    required this.taskId,
    required this.page,
    required this.pageSize,
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
