final _emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

bool isEmail(String text) {
  if (_emailRegExp.hasMatch(text.trim())) return true;
  return false;
}

// Form validation functions
String? isEmailValidator(String? text) {
  if (text == null || text.trim().isEmpty) return null;
  if (_emailRegExp.hasMatch(text.trim())) return null;
  return 'Invalid email address';
}

String? isNotEmptyValidator(String? text) {
  if (text == null || text.trim().isEmpty) return 'Required field';
  return null;
}
