import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/interface/attachment_repository.dart';
import 'package:ayeayecaptain_mobile/domain/task/interface/task_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/loader/actions.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:redux_epics/redux_epics.dart';

class TaskMiddleware extends EpicMiddleware<AppState> {
  TaskMiddleware(
    TaskRepository repository,
    AttachmentRepository attachmentRepository,
  ) : super(
          combineEpics(
            [
              _getTasks(repository),
              _getTask(repository),
              _saveTaskDetails(repository),
              _createTask(repository),
              _getTaskAttachments(attachmentRepository),
              _deleteAttachment(attachmentRepository),
            ],
          ),
        );

  static Epic<AppState> _getTasks(
    TaskRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<GetTasksAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.getTasks(
              profile: store.state.profileState.selected!,
              page: action.page,
              pageSize: action.pageSize,
              orderBy: action.orderBy,
            );

            if (request.wasSuccessful) {
              yield AddTasksAction(
                taskResults: request.result!,
                shouldReset: action.shouldReset,
              );
            }
          },
        ),
      ).call;

  static Epic<AppState> _getTask(
    TaskRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<GetTaskAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.getTask(
              store.state.profileState.selected!,
              action.id,
            );

            if (request.wasSuccessful) {
              yield AddTaskAction(request.result!);
              yield ClosePageAction();
              yield OpenEditTaskPageAction(request.result!);
            }

            yield HideLoaderAction();
          },
        ),
      ).call;

  static Epic<AppState> _saveTaskDetails(
    TaskRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<SaveTaskDetailsAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            yield ShowLoaderAction();
            final request = await repository.saveTaskDetails(
              profile: store.state.profileState.selected!,
              taskId: action.taskId,
              title: action.title,
              blocks: action.blocks,
            );

            if (request.wasSuccessful) {
              yield GetTasksAction(
                page: store.state.taskState.page!,
                pageSize: store.state.taskState.pageSize!,
                orderBy: tasksOrderBy,
                shouldReset: true,
              );
              yield ClosePageAction();
            } else {
              yield OpenAlertDialogAction(
                DialogConfig(content: request.failure!.message),
              );
            }
            yield HideLoaderAction();
          },
        ),
      ).call;

  static Epic<AppState> _createTask(
    TaskRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<CreateTaskAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            yield ShowLoaderAction();

            final request = await repository.createTask(
              profile: store.state.profileState.selected!,
              title: action.title,
              addToUserQueue: action.addToUserQueue,
              queuePosition: action.queuePosition,
            );

            if (request.wasSuccessful) {
              yield GetTaskAction(request.result!);
            } else {
              yield HideLoaderAction();
              yield OpenAlertDialogAction(
                DialogConfig(content: request.failure!.message),
              );
            }
          },
        ),
      ).call;

  static Epic<AppState> _getTaskAttachments(
    AttachmentRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<GetTaskAttachmentsAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.getAttachments(
              profile: store.state.profileState.selected!,
              taskId: action.taskId,
              page: action.page,
              pageSize: action.pageSize,
              orderBy: action.orderBy,
            );

            if (request.wasSuccessful) {
              yield AddTaskAttachmentsAction(
                taskId: action.taskId,
                attachmentResults: request.result!,
                orderBy: action.orderBy,
                shouldReset: action.shouldReset,
              );
            }
          },
        ),
      ).call;

  static Epic<AppState> _deleteAttachment(
    AttachmentRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<DeleteTaskAttachmentAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.deleteAttachment(
              profile: store.state.profileState.selected!,
              id: action.id,
            );

            if (request.wasSuccessful) {
              yield GetTaskAttachmentsAction(
                taskId: action.task.id,
                page: action.task.attachmentsCurrentPage ?? 1,
                pageSize:
                    action.task.attachmentsPageSize ?? attachmentsPageSize,
                orderBy: action.task.attachmentsOrderBy,
                shouldReset: true,
              );
            }
          },
        ),
      ).call;
}
