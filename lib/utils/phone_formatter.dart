import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted;
    if (text.length <= 3) {
      formatted = text;
    } else if (text.length <= 7) {
      formatted = '${text.substring(0, 3)}-${text.substring(3)}';
    } else {
      formatted =
      '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}