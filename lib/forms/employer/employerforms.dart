// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/custom/custom_logoviewer.dart';
import 'package:advisorapp/custom/custom_tooltip.dart';

import 'package:advisorapp/forms/employer/sl_employerform.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';

import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/employer.dart';
import '../../component/sidemenu.dart';

class EmployerForms extends StatelessWidget {
  EmployerForms({super.key});

  //late String buttonText = "Send";
  //late dynamic itemtoedit;
  List<Partner> allPartners = [];
  List<Partner> selectedPartners = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final prvPartner = Provider.of<PartnerProvider>(context, listen: false);
    final prvEmp = Provider.of<EmployerProvider>(context, listen: false);
    final prvMaster = Provider.of<MasterProvider>(context, listen: false);

    return Background(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: SideMenu(
              key: null,
              // currentGoogleAccount: loginProvider.currentGoogleUser!,
            ),
          ),
          Expanded(
              flex: 9,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          prvEmp.addNew = true;
                          prvEmp.edit = false;
                          selectedPartners.clear();
                          prvPartner.selectedPartners = selectedPartners;
                          prvEmp.selectedEmployer = Employer(partners: []);
                          prvEmp.clearInvitation();
                          prvEmp.companydomainnameController.clear();
                          prvEmp.decisionmakerController.clear();
                          prvEmp.contractsignatoryController.clear();
                          prvEmp.daytodaycontactController.clear();
                          prvEmp.planeffectivedateController.clear();
                          prvMaster.selectedEmployerCompanyType = prvMaster
                              .companytypes
                              .firstWhere((e) => e.typecode == 'select');
                        },
                        child: const Text(
                          '+ Add a new Employer client',
                          style: appstyle,
                        )),
                    Consumer<EmployerProvider>(
                        builder: (context, prvEntryForm, child) {
                      if (prvEntryForm.edit || prvEntryForm.addNew) {
                        //return dataEntryForm();
                        return const SLEmployerForm();
                      } else {
                        return const Text('');
                      }
                    }),
                    SizedBox(
                        width: SizeConfig.screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Consumer<EmployerProvider>(
                              builder: (context, prvEmployer, child) {
                            return prvEmployer.reading
                                ? displaySpin()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: prvEmployer.employers.length,
                                    itemBuilder: (context, index) {
                                      bool isLoading =
                                          prvEmployer.isLoading(index);
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible: (!prvEmployer.addNew &&
                                                !prvEmployer.edit),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth /
                                                            5,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              prvEmployer.edit =
                                                                  true;
                                                              prvEmployer
                                                                      .addNew =
                                                                  false;

                                                              final prvMaster =
                                                                  Provider.of<
                                                                          MasterProvider>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                              try {
                                                                prvEmployer
                                                                        .selectedEmployer =
                                                                    prvEmployer
                                                                            .employers[
                                                                        index];
                                                                var objType = prvMaster
                                                                    .companytypes
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .typecode ==
                                                                        prvEmployer
                                                                            .employers[index]
                                                                            .companytype);

                                                                prvMaster
                                                                    .selectedEmployerCompanyType = (objType
                                                                        .typecode
                                                                        .isEmpty)
                                                                    ? prvMaster
                                                                        .companytypes[0]
                                                                    : objType;

                                                                selectedPartners
                                                                    .clear();

                                                                List<Partner>
                                                                    partners =
                                                                    prvEmployer
                                                                        .employers[
                                                                            index]
                                                                        .partners;

                                                                for (var element
                                                                    in prvPartner
                                                                        .partners) {
                                                                  {
                                                                    for (var ele
                                                                        in partners) {
                                                                      {
                                                                        if (element.partnercode ==
                                                                            ele.partnercode) {
                                                                          selectedPartners
                                                                              .add(element);
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                                prvPartner
                                                                        .selectedPartners =
                                                                    selectedPartners;
                                                              } on StateError catch (e) {
                                                                // Handle the exception
                                                                prvMaster
                                                                        .selectedEmployerCompanyType =
                                                                    prvMaster
                                                                        .companytypes[0];
                                                                if (selectedPartners
                                                                    .isEmpty) {
                                                                  selectedPartners.add(
                                                                      prvPartner
                                                                          .partners[0]);
                                                                  prvPartner
                                                                          .selectedPartners =
                                                                      selectedPartners;
                                                                }
                                                              }
                                                            },
                                                            child:
                                                                CustomLogoViewer(
                                                              employer: prvEmployer
                                                                      .employers[
                                                                  index],
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: TooltipWithCopy(
                                                                  employer: prvEmployer
                                                                          .employers[
                                                                      index]))
                                                        ])),
                                                (prvEmployer.employers[index]
                                                            .launchstatus ==
                                                        'SENTLAUNCHPACK')
                                                    ? Consumer<
                                                            EmployerProvider>(
                                                        builder: (context,
                                                            prvView, child) {
                                                        return ElevatedButton(
                                                            style:
                                                                buttonStyleGreen,
                                                            onPressed:
                                                                () async {
                                                              prvView
                                                                  .setLoadingStatus(
                                                                      index,
                                                                      true);
                                                              LaunchPack obj =
                                                                  LaunchPack();

                                                              obj.employercode =
                                                                  prvView
                                                                      .employers[
                                                                          index]
                                                                      .employercode;
                                                              obj.accountcode =
                                                                  prvView
                                                                      .employers[
                                                                          index]
                                                                      .accountcode;
                                                              await prvView
                                                                  .getInitialLaunchPack(
                                                                      obj
                                                                          .accountcode,
                                                                      obj
                                                                          .employercode,
                                                                      'Advisor')
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            prvView.readAccountsAssociatedtoEmployer(obj.accountcode,
                                                                                obj.employercode),
                                                                            prvView.getLaunchStatusList(),
                                                                            prvView.clearActionLaunchPack(),
                                                                            prvView.loadVisibleStatusList(),
                                                                            prvView.setLoadingStatus(index,
                                                                                false),
                                                                            Navigator.of(context).pushNamed("/empLaunchPack",
                                                                                arguments: prvView.employers[index])
                                                                            //Navigator.of(context).popAndPushNamed("/empLaunchPack", arguments: prvEmployer.employers[index])
                                                                          });
                                                            },
                                                            child: prvView
                                                                    .isLoading(
                                                                        index)
                                                                ? displaySpin()
                                                                : const Text(
                                                                    'VIEW DASHBOARD',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ));
                                                      })
                                                    : Consumer<
                                                            EmployerProvider>(
                                                        builder: (context,
                                                            prvEmp, child) {
                                                        return Tooltip(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: AppColors
                                                                      .black),
                                                          message: checkEmployeeJoined(
                                                                  prvEmployer
                                                                          .employers[
                                                                      index])
                                                              ? ''
                                                              : 'At least one employer user needs to join the advisor platform for you to initiate launch/renewal.\n Please go to Invite menu to resend the invitation to the employer user if needed.',
                                                          decoration:
                                                              tooltipdecoration,
                                                          child: ElevatedButton(
                                                              style: checkEmployeeJoined(
                                                                      prvEmployer
                                                                              .employers[
                                                                          index])
                                                                  ? buttonStyleInvite
                                                                  : buttonStyleGrey,
                                                              onPressed: (isLoading ||
                                                                      !checkEmployeeJoined(
                                                                          prvEmployer.employers[
                                                                              index]))
                                                                  ? null
                                                                  : () {
                                                                      prvEmployer.setLoadingStatus(
                                                                          index,
                                                                          true);
                                                                      LaunchPack
                                                                          obj =
                                                                          LaunchPack();

                                                                      obj.employercode = prvEmployer
                                                                          .employers[
                                                                              index]
                                                                          .employercode;
                                                                      obj.accountcode = prvEmployer
                                                                          .employers[
                                                                              index]
                                                                          .accountcode;

                                                                      prvEmployer
                                                                          .initiateLaunch(
                                                                              obj)
                                                                          .then((value) =>
                                                                              {
                                                                                prvEmployer.getInitialLaunchPack(obj.accountcode, obj.employercode, 'Advisor').then((value) => {
                                                                                      prvEmployer.readAccountsAssociatedtoEmployer(obj.accountcode, obj.employercode),
                                                                                      prvEmployer.clearActionLaunchPack(),
                                                                                      prvEmployer.getLaunchStatusList(),
                                                                                      prvEmployer.loadVisibleStatusList(),
                                                                                      prvEmployer.setLoadingStatus(index, false),
                                                                                      Navigator.of(context).pushNamed("/empLaunchPack", arguments: prvEmployer.employers[index])
                                                                                    })
                                                                              });
                                                                    },
                                                              child: prvEmp
                                                                      .isLoading(
                                                                          index)
                                                                  ? displaySpin()
                                                                  : Text(
                                                                      getCurrentDateDiff(prvEmployer.employers[index].planeffectivedate) >
                                                                              0
                                                                          ? 'INITIATE RENEWAL'
                                                                          : 'INITIATE LAUNCH',
                                                                      style: TextStyle(
                                                                          color: getCurrentDateDiff(prvEmployer.employers[index].planeffectivedate) > 0
                                                                              ? AppColors.black
                                                                              : AppColors.white),
                                                                    )),
                                                        );
                                                      })
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    2,
                                          ),
                                        ],
                                      );
                                    });
                          }),
                        ))
                  ],
                ),
              )),
          if (Responsive.isDesktop(context))
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
        ],
      ),
    );
  }

  int getCurrentDateDiff(String planeffectivedate) {
    DateTime peffectivedate = planeffectivedate.isEmpty
        ? DateTime.now()
        : DateTime.parse(planeffectivedate);
    DateTime currentdate = DateTime.now();
    return currentdate.difference(peffectivedate).inDays;
  }

  checkEmployeeJoined(Employer obj) {
    if (obj.decisionmakeremailinvitationstatus == 'Joined' ||
        obj.contractsignatoryemailinvitationstatus == 'Joined' ||
        obj.daytodaycontactemailinvitationstatus == 'Joined') {
      return true;
    }
    return false;
  }

  /* selectImage(employercode) async {
    final imgProvider = Provider.of<EliteImageProvider>(context, listen: false);
    var mediaData = await ImagePickerWeb.getImageInfo;
    String? base64String = mediaData?.base64;
    //print(base64String);
    // print(mediaData?.fileName);
    String? extension = mediaData?.fileName.toString().split('.').last;
    EmployerProfile obj = EmployerProfile(
        employerCode: employercode,
        fileextension: ".${extension!}",
        filebase64: base64String!);
    imgProvider.uploadEmployerLogo(obj);
  } */

  /*  getButtonText(String email, String role) {
    try {
      EmployerProvider empPrv =
          Provider.of<EmployerProvider>(context, listen: false);
      AdvisorInvite invitedEmail = empPrv.invitedEmployers.firstWhere(
          (e) => e.invitedemail == email,
          orElse: () => AdvisorInvite(
              role: Role(rolecode: '', rolename: '', roletype: ''),
              companycategory: CompanyCategory(
                  categorycode: '', categoryname: '', basecategorycode: '')));
      var buttonText = '';
      if (role == 'DAYTODAY') {
        buttonText = (invitedEmail.invitationstatus.isEmpty &&
                empPrv.selectedEmployer == null)
            ? "Send"
            : (invitedEmail.invitationstatus.isEmpty &&
                    empPrv.selectedEmployer != null)
                ? empPrv.selectedEmployer!.daytodaycontactemailinvitationstatus
                : invitedEmail.invitationstatus;
      } else if (role == 'CONTRACTSIGNATORY') {
        buttonText = (invitedEmail.invitationstatus.isEmpty &&
                empPrv.selectedEmployer == null)
            ? "Send"
            : (invitedEmail.invitationstatus.isEmpty &&
                    empPrv.selectedEmployer != null)
                ? empPrv
                    .selectedEmployer!.contractsignatoryemailinvitationstatus
                : invitedEmail.invitationstatus;
      } else if (role == 'DECISIONMAKER') {
        buttonText = (invitedEmail.invitationstatus.isEmpty &&
                empPrv.selectedEmployer == null)
            ? "Send"
            : (invitedEmail.invitationstatus.isEmpty &&
                    empPrv.selectedEmployer != null)
                ? empPrv.selectedEmployer!.decisionmakeremailinvitationstatus
                : invitedEmail.invitationstatus;
      }

      if (buttonText.isEmpty) {
        buttonText = "Send";
      }
      return buttonText;
    } catch (e) {
      buttonText = "Error";
    }
  } */
}
