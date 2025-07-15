import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isObscure;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isObscure = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon)),
      obscureText: isObscure,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
