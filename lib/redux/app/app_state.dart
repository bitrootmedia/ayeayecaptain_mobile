import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';

class AppState {
  final NavigationState navigationState;
  final List<Profile>? profiles;

  AppState({
    required this.navigationState,
    required this.profiles,
  });

  AppState.initial()
      : navigationState = NavigationState.initial(),
        profiles = null;

  AppState copyWith({
    NavigationState? navigationState,
    List<Profile>? profiles,
  }) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
        profiles: profiles ?? this.profiles,
      );
}
