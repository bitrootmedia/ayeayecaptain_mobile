import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Function(String)? onChanged;
  final bool autocorrect;
  final String? initialValue;

  const CustomTextField({
    super.key,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.onChanged,
    this.autocorrect = true,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(label),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      onChanged: onChanged,
      autocorrect: autocorrect,
      initialValue: initialValue,
    );
  }
}
