import 'package:flutter/services.dart';

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Prevent any changes if the new value is longer than the old value
    if (newValue.text.length > oldValue.text.length) {
      return oldValue;
    }

    // Basic email validation
    if (!_isValidEmail(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }

  bool _isValidEmail(String input) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(input);
  }
}
