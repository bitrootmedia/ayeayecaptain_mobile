import 'package:ayeayecaptain_mobile/redux/loader/loader_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:ayeayecaptain_mobile/redux/profile/profile_state.dart';

class AppState {
  final NavigationState navigationState;
  final ProfileState profileState;
  final LoaderState loaderState;

  AppState({
    required this.navigationState,
    required this.profileState,
    required this.loaderState,
  });

  AppState.initial()
      : navigationState = NavigationState.initial(),
        profileState = ProfileState.initial(),
        loaderState = LoaderState.initial();

  AppState copyWith({
    NavigationState? navigationState,
    ProfileState? profileState,
    LoaderState? loaderState,
  }) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
        profileState: profileState ?? this.profileState,
        loaderState: loaderState ?? this.loaderState,
      );
}
