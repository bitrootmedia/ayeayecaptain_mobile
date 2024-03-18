import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_route_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class NavigationState with EquatableMixin {
  final List<NavigationRouteState> previousRoutes;
  final NavigationRouteState currentRoute;

  const NavigationState({
    required this.previousRoutes,
    required this.currentRoute,
  });

  NavigationState.initial()
      : previousRoutes = [],
        currentRoute = NavigationRouteState.initial();

  NavigationState copyWith({
    List<NavigationRouteState>? previousRoutes,
    NavigationRouteState? currentRoute,
  }) =>
      NavigationState(
        previousRoutes: previousRoutes ?? this.previousRoutes,
        currentRoute: currentRoute ?? this.currentRoute,
      );

  @override
  List<Object?> get props => [
        previousRoutes,
        currentRoute,
      ];
}
