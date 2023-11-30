import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

class CustomIdeaProfileViewer extends StatelessWidget {
  final Account account;

  const CustomIdeaProfileViewer({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.white),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Tooltip(
          textStyle: const TextStyle(color: AppColors.black),
          decoration: tooltipdecoration,
          message: account.fancyname,
          child: Center(
            child: Text(
              account.fancyname,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
