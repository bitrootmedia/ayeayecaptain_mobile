import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:redux/redux.dart';

class NavigationReducer extends ReducerClass<NavigationState> {
  @override
  NavigationState call(NavigationState state, action) =>
      combineReducers<NavigationState>([
        TypedReducer(_closePage).call,
        TypedReducer(_openCreateProfilePage).call,
        TypedReducer(_openAlertDialog).call,
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

  NavigationState _openCreateProfilePage(
    NavigationState state,
    OpenCreateProfilePageAction action,
  ) =>
      state.copyWith(
        previousRoutes: [
          ...state.previousRoutes,
          state.currentRoute,
        ],
        currentRoute: state.currentRoute.copyWith(
          isCreateProfilePageOpened: true,
        ),
      );

  NavigationState _openAlertDialog(
    NavigationState state,
    OpenAlertDialogAction action,
  ) =>
      state.copyWith(
        previousRoutes: [
          ...state.previousRoutes,
          state.currentRoute,
        ],
        currentRoute: state.currentRoute.copyWith(
          isAlertDialogOpened: true,
          dialogConfig: action.dialogConfig,
        ),
      );
}
