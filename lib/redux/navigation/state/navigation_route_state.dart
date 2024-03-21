import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class NavigationRouteState with EquatableMixin {
  final bool isCreateProfilePageOpened;
  final bool isAlertDialogOpened;
  final DialogConfig? dialogConfig;

  const NavigationRouteState({
    this.isCreateProfilePageOpened = false,
    this.isAlertDialogOpened = false,
    this.dialogConfig,
  });

  NavigationRouteState.initial()
      : isCreateProfilePageOpened = false,
        isAlertDialogOpened = false,
        dialogConfig = null;

  NavigationRouteState copyWith({
    bool? isCreateProfilePageOpened,
    bool? isAlertDialogOpened,
    DialogConfig? dialogConfig,
  }) =>
      NavigationRouteState(
        isCreateProfilePageOpened:
            isCreateProfilePageOpened ?? this.isCreateProfilePageOpened,
        isAlertDialogOpened: isAlertDialogOpened ?? this.isAlertDialogOpened,
        dialogConfig: dialogConfig ?? this.dialogConfig,
      );

  @override
  List<Object?> get props => [
        isCreateProfilePageOpened,
        isAlertDialogOpened,
        dialogConfig,
      ];
}
