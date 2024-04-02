import 'package:flutter/foundation.dart';

@immutable
class ChecklistBlockElement {
  final String label;
  final bool checked;

  const ChecklistBlockElement({
    required this.label,
    required this.checked,
  });
}
