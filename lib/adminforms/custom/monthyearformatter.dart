import 'package:flutter/services.dart';

class MonthYearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = _format(newValue.text);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _format(String text) {
    final strippedText = text.replaceAll(RegExp(r'\D'), '');
    final length = strippedText.length;

    if (length <= 2) {
      return strippedText;
    } else {
      final month = strippedText.substring(0, 2);
      final year = strippedText.substring(2, length);

      return '$month/$year';
    }
  }

  bool isValidDate(String month, String year) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    int inputYear = int.tryParse(year) ?? 0;
    int inputMonth = int.tryParse(month) ?? 0;

    if (inputYear > currentYear) {
      return true;
    } else if (inputYear == currentYear && inputMonth >= currentMonth) {
      return false;
    }

    return true;
  }
}
