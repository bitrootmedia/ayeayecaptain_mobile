import 'package:ayeayecaptain_mobile/redux/loader/loader_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:ayeayecaptain_mobile/redux/profile/profile_state.dart';
import 'package:ayeayecaptain_mobile/redux/project/project_state.dart';
import 'package:ayeayecaptain_mobile/redux/task/task_state.dart';

class AppState {
  final NavigationState navigationState;
  final ProfileState profileState;
  final LoaderState loaderState;
  final ProjectState projectState;
  final TaskState taskState;

  AppState({
    required this.navigationState,
    required this.profileState,
    required this.loaderState,
    required this.projectState,
    required this.taskState,
  });

  AppState.initial()
      : navigationState = NavigationState.initial(),
        profileState = ProfileState.initial(),
        loaderState = LoaderState.initial(),
        projectState = ProjectState.initial(),
        taskState = TaskState.initial();

  AppState copyWith({
    NavigationState? navigationState,
    ProfileState? profileState,
    LoaderState? loaderState,
    ProjectState? projectState,
    TaskState? taskState,
  }) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
        profileState: profileState ?? this.profileState,
        loaderState: loaderState ?? this.loaderState,
        projectState: projectState ?? this.projectState,
        taskState: taskState ?? this.taskState,
      );
}
