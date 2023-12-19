import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/forms/contracts/mycontractsview.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyContracts extends StatelessWidget {
  MyContracts({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: const PreferredSize(
          preferredSize: Size.zero,
          child: SizedBox(),
        ),
        body: Background(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              flex: 2,
              child: SideMenu(
                key: null,
                // currentGoogleAccount: loginProvider.currentGoogleUser!,
              ),
            ),
          const Expanded(
            flex: 9,
            child: MyContractsView(),
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
        ])));
  }
}
