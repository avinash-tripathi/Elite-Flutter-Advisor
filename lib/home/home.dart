import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/size_config.dart';

import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/forms/room/myroom.dart';
import 'package:advisorapp/providers/login_provider.dart';

import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final rProv = Provider.of<RoomsProvider>(context, listen: false);
    if (rProv.employers.isEmpty) {
      rProv.getInitialLaunchPack(
          loginProvider.logedinUser.accountcode, '', 'Individual');
      rProv.readRooms(loginProvider.logedinUser.workemail);
    } */

    SizeConfig().init(context);

    return Background(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Expanded(
        flex: 2,
        child: SideMenu(
          key: null,
          // currentGoogleAccount: loginProvider.currentGoogleUser!,
        ),
      ),
      const Expanded(
        flex: 9,
        child: MyRoom(),
      ),
      Consumer<LoginProvider>(
        builder: (context, prvRead, child) {
          int flexValue = prvRead.isPanelShrinked ? 1 : 2;
          return Expanded(
            flex: flexValue,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: SizeConfig.screenHeight,
                decoration: const BoxDecoration(
                  color: AppColors.conversation,
                  border: Border(
                    left: BorderSide(
                      color: AppColors.conversation,
                      width: 1,
                    ),
                  ),
                ),
                child: const SingleChildScrollView(
                  child: Column(
                    children: [EmployerInRoom()],
                  ),
                ),
              ),
            ),
          );
        },
      )
    ]));
  }
}
