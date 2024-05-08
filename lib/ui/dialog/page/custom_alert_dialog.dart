import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CustomAlertDialog extends StatelessWidget {
  final DialogConfig dialogConfig;

  const CustomAlertDialog({
    super.key,
    required this.dialogConfig,
  });

  VoidCallback _onPressed({
    required Store<AppState> store,
    dynamic action,
    VoidCallback? onPressed,
  }) {
    return () {
      onPressed?.call();
      if (action != null) {
        store.dispatch(action);
      }
      store.dispatch(ClosePageAction());
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: dialogConfig.title == null ? null : Text(dialogConfig.title!),
      content: SingleChildScrollView(
        child: Text(dialogConfig.content),
      ),
      actions: dialogConfig.actions == null
          ? [
              TextButton(
                onPressed: _onPressed(
                  store: StoreProvider.of<AppState>(context),
                ),
                child: const Text('Dismiss'),
              ),
            ]
          : dialogConfig.actions!
              .map(
                (e) => TextButton(
                  onPressed: _onPressed(
                    store: StoreProvider.of<AppState>(context),
                    action: e.action,
                    onPressed: e.onPressed,
                  ),
                  child: Text(e.label),
                ),
              )
              .toList(),
      contentPadding: dialogConfig.title == null
          ? const EdgeInsets.fromLTRB(24, 32, 24, 16)
          : null,
      actionsPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    );
  }
}

class DialogConfig {
  final String? title;
  final String content;
  final List<DialogAction>? actions;
  final bool dismissible;

  DialogConfig({
    this.title,
    required this.content,
    this.actions,
    this.dismissible = true,
  });
}

class DialogAction {
  final String label;
  final VoidCallback? onPressed;
  final dynamic action;

  DialogAction({
    required this.label,
    this.onPressed,
    this.action,
  });
}
