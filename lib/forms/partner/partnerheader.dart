import 'package:advisorapp/style/style.dart';
import 'package:flutter/material.dart';

class PartnerHeader extends StatelessWidget {
  const PartnerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                  text: 'Partner', size: 30, fontWeight: FontWeight.w800),
              /*  PrimaryText(
                text: 'Partner',
                size: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ) */
            ]),
      ),
      Spacer(
        flex: 1,
      ),
    ]);
  }
}
