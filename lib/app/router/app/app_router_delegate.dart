import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/ui/components/loader.dart';
import 'package:ayeayecaptain_mobile/ui/components/material_dialog.dart';
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:ayeayecaptain_mobile/ui/home/page/home_page.dart';
import 'package:ayeayecaptain_mobile/ui/profile/page/create_profile_page.dart';
import 'package:ayeayecaptain_mobile/ui/profile/page/profile_list_page.dart';
import 'package:ayeayecaptain_mobile/ui/project/page/project_list_page.dart';
import 'package:ayeayecaptain_mobile/ui/task/page/task_list_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_route_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';

import 'package:redux/redux.dart';

class AppRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> _store;

  AppRouterDelegate(this._store) : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store),
      builder: (context, viewModel) {
        return Stack(
          children: [
            Navigator(
              key: navigatorKey,
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }
                if (viewModel.route.isAlertDialogOpened) {
                  _store.dispatch(ClosePageAction());
                }
                return true;
              },
              pages: [
                if (viewModel.route.isHomePageOpened)
                  const MaterialPage(
                    key: ValueKey('homePage'),
                    child: HomePage(),
                  ),
                if (viewModel.route.isProjectListPageOpened)
                  const MaterialPage(
                    key: ValueKey('projectListPage'),
                    child: ProjectListPage(),
                  ),
                if (viewModel.route.isTaskListPageOpened)
                  const MaterialPage(
                    key: ValueKey('taskListPage'),
                    child: TaskListPage(),
                  ),
                if (viewModel.route.isProfileListPageOpened)
                  const MaterialPage(
                    key: ValueKey('profileListPage'),
                    child: ProfileListPage(),
                  ),
                if (viewModel.route.isCreateProfilePageOpened)
                  const MaterialPage(
                    key: ValueKey('createProfilePage'),
                    child: CreateProfilePage(),
                  ),
                if (viewModel.route.isAlertDialogOpened)
                  MaterialDialog(
                    builder: (context) => CustomAlertDialog(
                      dialogConfig: viewModel.route.dialogConfig!,
                    ),
                    dismissible: true,
                  ),
              ],
            ),
            if (viewModel.isLoading) const Loader(),
          ],
        );
      },
    );
  }

  @override
  Future<bool> popRoute() {
    if (navigatorKey.currentState!.widget.pages.length > 1) {
      _store.dispatch(ClosePageAction());
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {}
}

class _ViewModel with EquatableMixin {
  final NavigationRouteState route;
  final bool isLoading;

  _ViewModel(Store<AppState> store)
      : route = store.state.navigationState.currentRoute,
        isLoading = store.state.loaderState.isLoading;

  @override
  List<Object?> get props => [
        route,
        isLoading,
      ];
}
