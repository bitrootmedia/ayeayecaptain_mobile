import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';

abstract class NavigationAction {}

class ClosePageAction implements NavigationAction {}

class OpenCreateProfilePageAction implements NavigationAction {}

class OpenAlertDialogAction implements NavigationAction {
  final DialogConfig dialogConfig;

  OpenAlertDialogAction(this.dialogConfig);
}
