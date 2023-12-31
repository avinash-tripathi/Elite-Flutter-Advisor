// ignore_for_file: file_names

import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:advisorapp/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoCard extends StatelessWidget {
  final String icon;
  final String label;
  final String amount;

  const InfoCard(
      {super.key,
      required this.icon,
      required this.label,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minWidth: Responsive.isDesktop(context)
              ? 100
              : SizeConfig.screenWidth / 2 - 40),
      padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
          right: Responsive.isMobile(context) ? 20 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, width: 35),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          PrimaryText(text: label, color: AppColors.secondary, size: 16),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          PrimaryText(
            text: amount,
            size: 18,
            fontWeight: FontWeight.w700,
          )
        ],
      ),
    );
  }
}
