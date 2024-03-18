import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/ui/home/page/home_page.dart';
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
        return Navigator(
          key: navigatorKey,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            return true;
          },
          pages: const [
            // if (viewModel.route.isPageOpened)
            MaterialPage(
              key: ValueKey('homePage'),
              child: HomePage(),
            ),
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

  _ViewModel(Store<AppState> store)
      : route = store.state.navigationState.currentRoute;

  @override
  List<Object?> get props => [route];
}
