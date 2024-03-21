import 'package:flutter/material.dart';

class MaterialDialog extends Page {
  final WidgetBuilder builder;
  final bool dismissible;

  const MaterialDialog({
    required this.builder,
    this.dismissible = true,
  });

  @override
  Route createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      builder: builder,
      settings: this,
      barrierDismissible: dismissible,
    );
  }
}
