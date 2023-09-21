import 'package:advisorapp/component/background.dart';

import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/forms/workspace/actionitemtable.dart';
import 'package:advisorapp/forms/workspace/workspaceheader.dart';
import 'package:advisorapp/forms/workspace/workspacelist.dart';
import 'package:advisorapp/models/activeworkspace.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:advisorapp/style/style.dart';
import 'package:flutter/material.dart';

class WorkSpaceForm extends StatefulWidget {
  const WorkSpaceForm({Key? key}) : super(key: key);

  @override
  State<WorkSpaceForm> createState() => _WorkSpaceFormState();
}

class _WorkSpaceFormState extends State<WorkSpaceForm> {
  late String loggedinAccountCode = '';
  late List<ActiveWorkSpace> workspacelist = [];
  late ActiveWorkSpace selectedWorkSpace;
  late List<dynamic> actionitemlist = [];
  late bool isInitiater = false;
  @override
  void initState() {
    super.initState();

    workspacelist.add(ActiveWorkSpace(
        accountcode: '',
        accountname: '',
        employerlegalname: '',
        employercode: '',
        formcode: '',
        formname: '',
        fileextension: ''));
  }

  /*  getLoggedInUser() async {
    await HttpService().getLoggedInAccountCode().then((value) => {
          loggedinAccountCode = value!,
          if (loggedinAccountCode.split('-')[0] == 'AC') {isInitiater = true},
          getWorkSpaceUser()
        });
  } */

  getWorkSpaceUser() async {
    await HttpService().getWorkSpace(loggedinAccountCode).then((value) => {
          workspacelist = value,
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
                flex: 10,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WorkspaceHeader(),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 4,
                        ),
                        /* Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          PrimaryText(
                              text: 'Action Items',
                              size: 20,
                              fontWeight: FontWeight.w400),
                          PrimaryText(
                            text: 'List of action items!',
                            size: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondary,
                          ),
                        ],
                      ), */
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Visibility(
                          visible: isInitiater,
                          child: SizedBox(
                            width: SizeConfig.screenWidth - 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: (actionitemlist.isNotEmpty)
                                      ? '${actionitemlist[0]['daysleft']} DAYS TO LAUNCH'
                                      : '',
                                  size: 14,
                                  fontWeight: FontWeight.w200,
                                  color: AppColors.light,
                                ),
                                ElevatedButton(
                                  child: const Text('SEND LAUNCH PACK'),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        ActionItemTable(
                          actionitems:
                              (actionitemlist.isNotEmpty) ? actionitemlist : [],
                        ),
                        if (!Responsive.isDesktop(context))
                          WorkSpaceList(
                            workspacelist: workspacelist,
                            onWorkSpaceSelected: (p0) {},
                          )
                      ],
                    ),
                  ),
                )),
          if (Responsive.isDesktop(context))
            Expanded(
              flex: 4,
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: SizeConfig.screenHeight,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    child: Column(
                      children: [
                        // AppBarActionItems(),
                        //PaymentDetailList(),

                        WorkSpaceList(
                          workspacelist: workspacelist,
                          onWorkSpaceSelected: (p0) async {
                            selectedWorkSpace = p0;
                            actionitemlist.clear();
                            actionitemlist = [];
                            await HttpService()
                                .getInitialLaunchPack(
                                    selectedWorkSpace.accountcode,
                                    selectedWorkSpace.employercode)
                                .then((value) => {actionitemlist = value});
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
