import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_route_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:redux/redux.dart';

class NavigationReducer extends ReducerClass<NavigationState> {
  @override
  NavigationState call(NavigationState state, action) =>
      combineReducers<NavigationState>([
        TypedReducer(_closePage).call,
        TypedReducer(_openProfileListPage).call,
        TypedReducer(_openCreateProfilePage).call,
        TypedReducer(_openAlertDialog).call,
        TypedReducer(_openHomePage).call,
        TypedReducer(_openProjectListPage).call,
        TypedReducer(_openTaskListPage).call,
        TypedReducer(_openEditTaskPage).call,
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

  NavigationState _openProfileListPage(
    NavigationState state,
    OpenProfileListPageAction action,
  ) =>
      state.copyWith(
        previousRoutes: [
          ...state.previousRoutes,
          state.currentRoute,
        ],
        currentRoute: state.currentRoute.copyWith(
          isProfileListPageOpened: true,
        ),
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

  NavigationState _openHomePage(
    NavigationState state,
    OpenHomePageAction action,
  ) =>
      state.copyWith(
        previousRoutes: [],
        currentRoute: const NavigationRouteState(
          isHomePageOpened: true,
        ),
      );

  NavigationState _openProjectListPage(
    NavigationState state,
    OpenProjectListPageAction action,
  ) =>
      state.copyWith(
        previousRoutes: [
          ...state.previousRoutes,
          state.currentRoute,
        ],
        currentRoute: state.currentRoute.copyWith(
          isProjectListPageOpened: true,
        ),
      );

  NavigationState _openTaskListPage(
    NavigationState state,
    OpenTaskListPageAction action,
  ) =>
      state.copyWith(
        previousRoutes: [
          ...state.previousRoutes,
          state.currentRoute,
        ],
        currentRoute: state.currentRoute.copyWith(
          isTaskListPageOpened: true,
        ),
      );

  NavigationState _openEditTaskPage(
    NavigationState state,
    OpenEditTaskPageAction action,
  ) =>
      state.copyWith(
        previousRoutes: [
          ...state.previousRoutes,
          state.currentRoute,
        ],
        currentRoute: state.currentRoute.copyWith(
          isEditTaskPageOpened: true,
          task: action.task,
        ),
      );
}
