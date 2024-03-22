import 'package:ayeayecaptain_mobile/domain/project/interface/project_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/project/actions.dart';
import 'package:redux_epics/redux_epics.dart';

class ProjectMiddleware extends EpicMiddleware<AppState> {
  ProjectMiddleware(
    ProjectRepository repository,
  ) : super(
          combineEpics(
            [
              _getProjects(repository),
            ],
          ),
        );

  static Epic<AppState> _getProjects(
    ProjectRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<GetProjectsAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.getProjects(action.profile);

            if (request.wasSuccessful) {
              yield UpdateProjectsAction(request.result!);
            }
          },
        ),
      ).call;
}
