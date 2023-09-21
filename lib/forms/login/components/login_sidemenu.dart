import 'package:advisorapp/config/size_config.dart';

import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

class LoginSideMenu extends StatelessWidget {
  const LoginSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.screenWidth / 7,
        child: Drawer(
            elevation: 0,
            child: Container(
              width: SizeConfig.screenWidth / 7,
              height: SizeConfig.screenHeight,
              decoration: const BoxDecoration(
                  color: AppColors.sidemenu,
                  border: Border(
                      right: BorderSide(color: AppColors.sidemenu, width: 1))),
              /*  child: Align(
                alignment: Alignment
                    .topRight, // Align the icon to the top right corner
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.black,
                  ),
                  onPressed: () {
                    // Add your menu functionality here
                    final lProvider =
                        Provider.of<LoginProvider>(context, listen: false);
                    lProvider.isPanelShrinked = !lProvider.isPanelShrinked;
                  },
                ),
              ), */
            )));
  }
}
