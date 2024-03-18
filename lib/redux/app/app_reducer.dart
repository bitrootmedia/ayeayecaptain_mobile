import 'package:ayeayecaptain_mobile/redux/app/actions.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/reducer/navigation_reducer.dart';
import 'package:redux/redux.dart';

class AppReducer extends ReducerClass<AppState> {
  final _navigationReducer = NavigationReducer();

  @override
  AppState call(AppState state, action) {
    return combineReducers<AppState>([
      TypedReducer(_reset).call,
      (state, action) => AppState(
            navigationState: _navigationReducer(state.navigationState, action),
          )
    ])(state, action);
  }

  AppState _reset(AppState state, ResetStateAction action) =>
      AppState.initial();
}
