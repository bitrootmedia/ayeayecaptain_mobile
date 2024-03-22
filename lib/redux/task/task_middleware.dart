import 'package:ayeayecaptain_mobile/domain/task/interface/task_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:redux_epics/redux_epics.dart';

class TaskMiddleware extends EpicMiddleware<AppState> {
  TaskMiddleware(
    TaskRepository repository,
  ) : super(
          combineEpics(
            [
              _getTasks(repository),
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
}
