import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class NavigationRouteState with EquatableMixin {
  const NavigationRouteState();

  NavigationRouteState.initial();

  @override
  List<Object?> get props => [];
}
