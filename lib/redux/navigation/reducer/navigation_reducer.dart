import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:redux/redux.dart';

class NavigationReducer extends ReducerClass<NavigationState> {
  @override
  NavigationState call(NavigationState state, action) =>
      combineReducers<NavigationState>([
        TypedReducer(_closePage).call,
      ])(state, action);

  NavigationState _closePage(
    NavigationState state,
    ClosePageAction action,
  ) =>
      state.copyWith(
        previousRoutes:
            state.previousRoutes.sublist(0, state.previousRoutes.length - 1),
        currentRoute: state.previousRoutes.last,
      );
}
