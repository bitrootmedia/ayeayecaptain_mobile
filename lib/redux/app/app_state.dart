import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';

class AppState {
  final NavigationState navigationState;

  AppState({
    required this.navigationState,
  });

  AppState.initial() : navigationState = NavigationState.initial();

  AppState copyWith({
    NavigationState? navigationState,
  }) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
      );
}
