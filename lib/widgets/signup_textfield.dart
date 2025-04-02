import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  final Function(String) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  const SignupTextfield({
    Key? key,
    required this.labelText,
    required this.controller,
    this.inputType = TextInputType.text,
    required this.onChanged,
    this.inputFormatters,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Color(0xFFA17956), fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        border: const UnderlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0), // Vertical padding inside TextField
      ),
    );
  }
}