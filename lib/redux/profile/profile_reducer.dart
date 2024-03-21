import 'package:ayeayecaptain_mobile/redux/profile/actions.dart';
import 'package:ayeayecaptain_mobile/redux/profile/profile_state.dart';
import 'package:redux/redux.dart';

class ProfileReducer extends ReducerClass<ProfileState> {
  @override
  ProfileState call(ProfileState state, action) {
    return combineReducers<ProfileState>([
      TypedReducer(_updateProfiles).call,
    ])(state, action);
  }

  ProfileState _updateProfiles(
    ProfileState state,
    UpdateProfilesAction action,
  ) =>
      state.copyWith(
        profiles: action.profiles,
      );
}
