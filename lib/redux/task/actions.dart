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
  final String title;
  final List<Block> blocks;

  PartiallyUpdateTaskAction({
    required this.taskId,
    required this.title,
    required this.blocks,
  });
}

class UpdateLocalTaskAction {
  final Task task;

  UpdateLocalTaskAction(this.task);
}

class UpdateTaskDataWasChangedAction {
  final bool wasChanged;
  final Task editingTask;

  UpdateTaskDataWasChangedAction(
    this.wasChanged,
    this.editingTask,
  );
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

class CreateTaskAction {
  final String title;
  final bool addToUserQueue;
  final String queuePosition;

  CreateTaskAction({
    required this.title,
    required this.addToUserQueue,
    required this.queuePosition,
  });
}

class GetNewTaskAction {
  final String id;

  GetNewTaskAction(this.id);
}

class GetUpdatedTaskAction {
  final String id;

  GetUpdatedTaskAction(this.id);
}

class AddLocalTaskAction {
  final Task task;

  AddLocalTaskAction(this.task);
}
