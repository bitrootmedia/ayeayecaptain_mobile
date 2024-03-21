import 'package:flutter/material.dart';

class Unfocusable extends StatelessWidget {
  final Widget child;

  const Unfocusable({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: child,
          );
        },
      ),
    );
  }
}
