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
              _partiallyUpdateTask(repository),
              _getTaskAttachments(attachmentRepository),
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
            final request = await repository.getTasks(action.profile);

            if (request.wasSuccessful) {
              yield UpdateTasksAction(request.result!);
            }
          },
        ),
      ).call;

  static Epic<AppState> _partiallyUpdateTask(
    TaskRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<PartiallyUpdateTaskAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            yield ShowLoaderAction();
            final request = await repository.partiallyUpdateTask(
              profile: store.state.profileState.selected!,
              taskId: action.taskId,
              blocks: action.blocks,
            );

            if (request.wasSuccessful) {
              yield UpdateLocalTaskAction(request.result!);
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
            );

            if (request.wasSuccessful) {
              yield AddTaskAttachmentsAction(
                taskId: action.taskId,
                attachmentResults: request.result!,
                shouldReset: action.shouldReset,
              );
            }
          },
        ),
      ).call;
}
