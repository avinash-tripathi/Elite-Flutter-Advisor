import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

// Icon(
//         Icons.payment,
//         color: Colors.blue[900],
//       ),
class CustomPaymentTextDecoration {
  static InputDecoration textDecoration(
      String labelText, String hintText, String errorText) {
    return InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.white,
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          color: AppColors.hint,
        ),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 10)

        /*  enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 184, 180, 180)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 184, 180, 180)),
      ), */
        );
  }
}

class CustomTextDecoration {
  static InputDecoration emailDecoration(
      String labelText, Icon decorationIcon, bool isValid) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.sidemenu,
      icon: decorationIcon,
      labelText: labelText,
      errorText: isValid ? null : 'Invalid Email',
      labelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: AppColors.hint,
      ),

      /*  enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 184, 180, 180)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 184, 180, 180)),
      ), */
    );
  }

  static InputDecoration textDecoration(String labelText, Icon decorationIcon) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.sidemenu,
      icon: decorationIcon,
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: AppColors.hint,
      ),

      /*  enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 184, 180, 180)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 184, 180, 180)),
      ), */
    );
  }
}

class CustomDropDownDecoration {
  static InputDecoration textDecoration(
      String labelText, Icon decorationIcon, Icon prefix) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.sidemenu,
      icon: decorationIcon,
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: AppColors.hint,
      ),
      /*  enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ), */
    );
  }
}
