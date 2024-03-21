import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(label),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
