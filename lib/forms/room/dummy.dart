import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/forms/accountform/groupconversation.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  @override
  Widget build(BuildContext context) {
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
        flex: 8,
        child: Center(child: Text('Comming soon')),
      ),
      Expanded(
        flex: 4,
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
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                children: [
                  //AppBarActionItems(),
                  /*  Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SvgPicture.asset('assets/alicornName.svg'),
                        ), */
                  GroupConversation(),
                ],
              ),
            ),
          ),
        ),
      ),
    ]));
  }
}
