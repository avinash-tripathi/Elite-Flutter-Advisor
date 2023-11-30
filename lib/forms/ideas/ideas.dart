import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/forms/ideas/newidea.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/providers/idea_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';

import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/idea.dart';

class Ideas extends StatelessWidget {
  const Ideas({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final iProvider = Provider.of<IdeaProvider>(context, listen: false);
    return Background(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (Responsive.isDesktop(context))
          const Expanded(
            flex: 2,
            child: SideMenu(
              key: null,
              // currentGoogleAccount: loginProvider.currentGoogleUser!,
            ),
          ),
        Expanded(
          flex: 9,
          child: SizedBox(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          iProvider.addNewIdea = true;
                        },
                        child: const Text(
                          '+Make the advisor platform better. Share your idea anonymously and vote on other user’s ideas',
                          style: appstyle,
                        )),
                    const SizedBox(height: 20),
                    Consumer<IdeaProvider>(builder: (context, prvMode, child) {
                      return prvMode.addNewIdea
                          ? NewIdea(
                              idea: Idea(
                                  filebase64: '',
                                  fileextension: '',
                                  ideafilename: ''),
                              isReadOnly: false)
                          : const Text('');
                    }),
                    SizedBox(
                        height: SizeConfig.screenHeight * 3 / 4,
                        child: Consumer<IdeaProvider>(
                            builder: (context, prvRead, child) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: prvRead.ideas.length,
                              itemBuilder: (context, index) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      NewIdea(
                                        idea: prvRead.ideas[index],
                                        isReadOnly: true,
                                      )
                                    ]);
                              });
                        }))
                  ],
                ),
              ),
            ),
          ),
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
      ]),
    );
  }
}
