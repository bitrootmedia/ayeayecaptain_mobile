import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:flutter/material.dart';

class AppRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  // Currently not in use
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    return NavigationState.initial();
  }
}
