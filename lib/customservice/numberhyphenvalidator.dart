import 'package:flutter/services.dart';

class NumberHyphenValidator {
  static final _regex = RegExp(r'^[0-9-]*$');

  static bool validate(String value) {
    return _regex.hasMatch(value);
  }

  static TextInputFormatter inputFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'));
  }
}
