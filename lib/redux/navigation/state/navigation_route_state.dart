import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class NavigationRouteState with EquatableMixin {
  final bool isProfileListPageOpened;
  final bool isCreateProfilePageOpened;
  final bool isAlertDialogOpened;
  final DialogConfig? dialogConfig;
  final bool isHomePageOpened;
  final bool isProjectListPageOpened;
  final bool isTaskListPageOpened;
  final bool isEditTaskPageOpened;
  final Task? task;
  final bool isViewImagePageOpened;
  final String? imagePath;
  final bool isCreateTaskPageOpened;

  const NavigationRouteState({
    this.isProfileListPageOpened = false,
    this.isCreateProfilePageOpened = false,
    this.isAlertDialogOpened = false,
    this.dialogConfig,
    this.isHomePageOpened = false,
    this.isProjectListPageOpened = false,
    this.isTaskListPageOpened = false,
    this.isEditTaskPageOpened = false,
    this.task,
    this.isViewImagePageOpened = false,
    this.imagePath,
    this.isCreateTaskPageOpened = false,
  });

  NavigationRouteState.initial()
      : isProfileListPageOpened = false,
        isCreateProfilePageOpened = false,
        isAlertDialogOpened = false,
        dialogConfig = null,
        isHomePageOpened = false,
        isProjectListPageOpened = false,
        isTaskListPageOpened = false,
        isEditTaskPageOpened = false,
        task = null,
        isViewImagePageOpened = false,
        imagePath = null,
        isCreateTaskPageOpened = false;

  NavigationRouteState copyWith({
    bool? isProfileListPageOpened,
    bool? isCreateProfilePageOpened,
    bool? isAlertDialogOpened,
    DialogConfig? dialogConfig,
    bool? isHomePageOpened,
    bool? isProjectListPageOpened,
    bool? isTaskListPageOpened,
    bool? isEditTaskPageOpened,
    Task? task,
    bool? isViewImagePageOpened,
    String? imagePath,
    bool? isCreateTaskPageOpened,
  }) =>
      NavigationRouteState(
        isProfileListPageOpened:
            isProfileListPageOpened ?? this.isProfileListPageOpened,
        isCreateProfilePageOpened:
            isCreateProfilePageOpened ?? this.isCreateProfilePageOpened,
        isAlertDialogOpened: isAlertDialogOpened ?? this.isAlertDialogOpened,
        dialogConfig: dialogConfig ?? this.dialogConfig,
        isHomePageOpened: isHomePageOpened ?? this.isHomePageOpened,
        isProjectListPageOpened:
            isProjectListPageOpened ?? this.isProjectListPageOpened,
        isTaskListPageOpened: isTaskListPageOpened ?? this.isTaskListPageOpened,
        isEditTaskPageOpened: isEditTaskPageOpened ?? this.isEditTaskPageOpened,
        task: task ?? this.task,
        isViewImagePageOpened:
            isViewImagePageOpened ?? this.isViewImagePageOpened,
        imagePath: imagePath ?? this.imagePath,
        isCreateTaskPageOpened:
            isCreateTaskPageOpened ?? this.isCreateTaskPageOpened,
      );

  @override
  List<Object?> get props => [
        isProfileListPageOpened,
        isCreateProfilePageOpened,
        isAlertDialogOpened,
        dialogConfig,
        isHomePageOpened,
        isProjectListPageOpened,
        isTaskListPageOpened,
        isEditTaskPageOpened,
        task,
        isViewImagePageOpened,
        imagePath,
        isCreateTaskPageOpened,
      ];
}
