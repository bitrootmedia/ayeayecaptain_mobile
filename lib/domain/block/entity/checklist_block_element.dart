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
}
