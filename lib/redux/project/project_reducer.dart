import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/redux/project/actions.dart';
import 'package:ayeayecaptain_mobile/redux/project/project_state.dart';
import 'package:redux/redux.dart';

class ProjectReducer extends ReducerClass<ProjectState> {
  @override
  ProjectState call(ProjectState state, action) {
    return combineReducers<ProjectState>([
      TypedReducer(_updateProjects).call,
      TypedReducer(_resetProjects).call,
    ])(state, action);
  }

  ProjectState _updateProjects(
    ProjectState state,
    UpdateProjectsAction action,
  ) =>
      state.copyWith(
        projects: Nullable(action.projects),
      );

  ProjectState _resetProjects(
    ProjectState state,
    ResetProjectsAction action,
  ) =>
      state.copyWith(
        projects: Nullable(null),
      );
}
