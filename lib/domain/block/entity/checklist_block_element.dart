class ChecklistBlockElement {
  String label;
  bool checked;

  ChecklistBlockElement({
    required this.label,
    required this.checked,
  });

  ChecklistBlockElement.empty()
      : label = '',
        checked = false;

  ChecklistBlockElement clone() => ChecklistBlockElement(
        label: label,
        checked: checked,
      );

  @override
  String toString() {
    return 'ChecklistBlockElement {label: $label, checked: $checked}';
  }
}
