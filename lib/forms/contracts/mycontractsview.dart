import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_logoviewer.dart';
import 'package:advisorapp/custom/custom_profileviewer.dart';
import 'package:advisorapp/forms/contracts/addanonymous.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyContractsView extends StatelessWidget {
  const MyContractsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final prvRoom = Provider.of<RoomsProvider>(context, listen: false);
    prvRoom.clearActionLaunchPack();
    prvRoom.readAnonymousEsignEntries(loginProvider.logedinUser.accountcode);
    prvRoom.getInitialLaunchPack(
        loginProvider.logedinUser.accountcode, '', 'Individual');
    prvRoom.readRooms(loginProvider.logedinUser.workemail);

    return SizedBox(
        width: SizeConfig.screenWidth,
        child: SizedBox(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<RoomsProvider>(
                        builder: (context, prvAddEsign, child) {
                      return TextButton(
                          onPressed: () {
                            prvAddEsign.newEsign = true;
                          },
                          child: Tooltip(
                            textStyle: const TextStyle(
                              color: AppColors.black,
                            ),
                            decoration: tooltipdecoration,
                            message:
                                "If the eSign is for a user of the advisor platform,\nplease send it from the employer workspace.\nIf the eSign is for someone that is NOT a user \nof the advisor platform, you can send it here.",
                            child: const Text('+ Send for eSign',
                                style: appstyle, textAlign: TextAlign.justify),
                          ));
                    }),
                    IconButton(
                        onPressed: () async => {
                              await prvRoom.getInitialLaunchPack(
                                  loginProvider.logedinUser.accountcode,
                                  '',
                                  'Individual'),
                              await prvRoom.readRooms(
                                  loginProvider.logedinUser.workemail)
                            },
                        icon: const Icon(Icons.refresh),
                        color: AppColors.blue)
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<RoomsProvider>(
                          builder: (context, prvView, child) {
                        return prvView.readingLaunchPack
                            ? displaySpin()
                            : SingleChildScrollView(
                                child: prvView.newEsign
                                    ? const AddAnonymous()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Documents sent to users of the advisor platform",
                                            style: appstyle,
                                          ),
                                          DataTable(
                                              columnSpacing: 15,
                                              columns: [
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          25,
                                                  child: const Text('From'),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          25,
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text('To'),
                                                  ),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          6,
                                                  child: const Center(
                                                      child: Text('Document')),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          10,
                                                  child: const Center(
                                                      child: Text('Due Date')),
                                                )),
                                                /*  DataColumn(
                                                label: SizedBox(
                                              width: SizeConfig.screenWidth / 8,
                                              child: const Center(
                                                  child: Text('Status')),
                                            )), */
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          8,
                                                  child: const Center(
                                                      child: Text('Status')),
                                                )),
                                              ],
                                              rows: [
                                                for (var i = 0;
                                                    i <
                                                        prvView
                                                            .launchpacks.length;
                                                    i++)
                                                  if ((prvView.launchpacks[i]
                                                                  .visibility ==
                                                              'public' ||
                                                          (prvView
                                                                      .launchpacks[
                                                                          i]
                                                                      .visibility ==
                                                                  'private' &&
                                                              (prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .fromcode ==
                                                                      loginProvider
                                                                          .logedinUser
                                                                          .accountcode ||
                                                                  prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .tocode ==
                                                                      loginProvider
                                                                          .logedinUser
                                                                          .accountcode))) &&
                                                      prvView.launchpacks[i]
                                                              .attachmenttype ==
                                                          'esign')
                                                    DataRow.byIndex(
                                                        index: i,
                                                        cells: [
                                                          DataCell(
                                                            Row(
                                                              children: [
                                                                CustomProfileViewer(
                                                                    account: prvView
                                                                            .launchpacks[
                                                                                i]
                                                                            .fromcodedata ??
                                                                        Account(
                                                                            rolewithemployer: [])),
                                                              ],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Row(
                                                              children: [
                                                                CustomProfileViewer(
                                                                    account: prvView
                                                                            .launchpacks[
                                                                                i]
                                                                            .tocodedata ??
                                                                        Account(
                                                                            rolewithemployer: [])),
                                                              ],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Uri uri =
                                                                      Uri.parse(
                                                                          "$defaultActionItemPath${prvView.launchpacks[i].formcode}/${prvView.launchpacks[i].formcodewithextension}");
                                                                  if (prvView
                                                                      .launchpacks[
                                                                          i]
                                                                      .formcodewithextension
                                                                      .isNotEmpty) {
                                                                    if (await canLaunchUrl(
                                                                        uri)) {
                                                                      await launchUrl(
                                                                          uri);
                                                                    }
                                                                  } else {
                                                                    // Handle error when unable to launch the URL
                                                                  }
                                                                },
                                                                child: Center(
                                                                  child:
                                                                      Tooltip(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      gradient:
                                                                          const LinearGradient(
                                                                              colors: <Color>[
                                                                            AppColors.invite,
                                                                            AppColors.red
                                                                          ]),
                                                                    ),
                                                                    message: prvView
                                                                        .launchpacks[
                                                                            i]
                                                                        .actionitemdata
                                                                        ?.filename,
                                                                    child: Text(
                                                                      prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .formname,
                                                                      style: TextStyle(
                                                                          decoration: prvView.launchpacks[i].formcodewithextension.isNotEmpty
                                                                              ? TextDecoration.underline
                                                                              : null),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                                child: Text(convertDateString(prvView
                                                                    .launchpacks[
                                                                        i]
                                                                    .duedate))),
                                                          )
                                                          /* DataCell(
                                                    Center(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'dd-MMM-yyyy')
                                                                .format(DateTime
                                                                    .parse(prvView
                                                                        .launchpacks[
                                                                            i]
                                                                        .duedate)),
                                                          ),
                                                          IconButton(
                                                              onPressed: !(loginProvider
                                                                              .logedinUser
                                                                              .accountcode ==
                                                                          prvView
                                                                              .launchpacks[
                                                                                  i]
                                                                              .tocode ||
                                                                      loginProvider
                                                                              .logedinUser
                                                                              .accountcode ==
                                                                          prvView
                                                                              .launchpacks[
                                                                                  i]
                                                                              .fromcode)
                                                                  ? null
                                                                  : () {
                                                                      showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate:
                                                                            DateTime
                                                                                .now(),
                                                                        firstDate:
                                                                            DateTime(
                                                                                2000),
                                                                        lastDate:
                                                                            DateTime(
                                                                                2100),
                                                                      ).then(
                                                                          (selectedDate) async {
                                                                        if (selectedDate !=
                                                                            null) {
                                                                          bool result = await EliteDialog(
                                                                              context,
                                                                              'Please confirm',
                                                                              'Do you want to save the changes?',
                                                                              'Yes',
                                                                              'No');
                                                                          if (result) {
                                                                            prvView.setLaunchDueDate(
                                                                                i,
                                                                                selectedDate);
                                                                            prvView.updateLaunchFormStatus(
                                                                                prvView.launchpacks[i].accountcode,
                                                                                prvView.launchpacks[i].employercode,
                                                                                prvView.launchpacks[i].formcode,
                                                                                prvView.launchpacks[i].formstatus,
                                                                                prvView.launchpacks[i].duedate);
                                                                          }
                                                                        }
                                                                      });
                                                                    },
                                                              icon: const Icon(
                                                                Icons.date_range,
                                                                color:
                                                                    AppColors.blue,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ), */
                                                          /* DataCell(
                                                    Center(
                                                      child: DropdownButton<
                                                          LaunchStatus>(
                                                        value: prvView
                                                            .launchStatusList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element.code ==
                                                                    prvView
                                                                        .launchpacks[
                                                                            i]
                                                                        .formstatus,
                                                                orElse: () => prvView
                                                                    .launchStatusList[0]),
                                                        onChanged: !(loginProvider
                                                                        .logedinUser
                                                                        .accountcode ==
                                                                    prvView
                                                                        .launchpacks[
                                                                            i]
                                                                        .tocode ||
                                                                loginProvider
                                                                        .logedinUser
                                                                        .accountcode ==
                                                                    prvView
                                                                        .launchpacks[
                                                                            i]
                                                                        .fromcode)
                                                            ? null
                                                            : (newValue) async {
                                                                // add your code to handle the value change here
                                                                bool result =
                                                                    await EliteDialog(
                                                                        context,
                                                                        'Please confirm',
                                                                        'Do you want to save the changes?',
                                                                        'Yes',
                                                                        'No');
                                                                if (result) {
                                                                  prvView
                                                                      .setLaunchStatus(
                                                                          i,
                                                                          newValue!);
                                                                  prvView.updateLaunchFormStatus(
                                                                      prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .accountcode,
                                                                      prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .employercode,
                                                                      prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .formcode,
                                                                      prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .formstatus,
                                                                      prvView
                                                                          .launchpacks[
                                                                              i]
                                                                          .duedate);
                                                                }
                                                              },
                                                        items: prvView
                                                            .launchStatusList
                                                            .where((e) =>
                                                                e.key ==
                                                                prvView
                                                                    .launchpacks[i]
                                                                    .attachmenttype)
                                                            .map((status) {
                                                          return DropdownMenuItem<
                                                              LaunchStatus>(
                                                            value: status,
                                                            child: Text(
                                                              status.name,
                                                              style:
                                                                  getColoredTextStyle(
                                                                      status.code),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                  */
                                                          ,
                                                          DataCell(
                                                            Center(
                                                                child: ListTile(
                                                              leading:
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon: Image
                                                                          .asset(
                                                                        'assets/ontask.png',
                                                                        color: AppColors
                                                                            .iconGray,
                                                                      )),
                                                              title: Text(
                                                                prvView
                                                                    .launchStatusList
                                                                    .firstWhere((e) =>
                                                                        e.code ==
                                                                        prvView
                                                                            .launchpacks[i]
                                                                            .formstatus)
                                                                    .name,
                                                                style: getColoredTextStyle(prvView
                                                                    .launchpacks[
                                                                        i]
                                                                    .formstatus),
                                                              ),
                                                            )),
                                                          ),
                                                        ]),
                                              ]),
                                        ],
                                      ),
                              );
                      }),
                      const Text(""),
                      Consumer<RoomsProvider>(
                          builder: (context, prvAno, child) {
                        return prvAno.readingAnonymousEntries
                            ? displaySpin()
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Documents sent to someone outside of the advisor platform",
                                      style: appstyle,
                                    ),
                                    DataTable(columnSpacing: 15, columns: [
                                      DataColumn(
                                          label: SizedBox(
                                        width: SizeConfig.screenWidth / 25,
                                        child: const Text('From'),
                                      )),
                                      DataColumn(
                                          label: SizedBox(
                                        width: SizeConfig.screenWidth / 25,
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('To'),
                                        ),
                                      )),
                                      DataColumn(
                                          label: SizedBox(
                                        width: SizeConfig.screenWidth / 6,
                                        child: const Center(
                                            child: Text('Document')),
                                      )),
                                      DataColumn(
                                          label: SizedBox(
                                        width: SizeConfig.screenWidth / 10,
                                        child: const Center(
                                            child: Text('Due Date')),
                                      )),
                                      DataColumn(
                                          label: SizedBox(
                                        width: SizeConfig.screenWidth / 8,
                                        child:
                                            const Center(child: Text('Status')),
                                      )),
                                    ], rows: [
                                      for (var i = 0;
                                          i < prvAno.anonymousEntries.length;
                                          i++)
                                        DataRow.byIndex(index: i, cells: [
                                          DataCell(
                                            Row(
                                              children: [
                                                CustomProfileViewer(
                                                    account: prvAno
                                                            .anonymousEntries[i]
                                                            .accountcodedata ??
                                                        Account(
                                                            rolewithemployer: [])),
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              children: [
                                                CustomProfileViewer(
                                                    account: Account(
                                                        accountcode: "",
                                                        accountname: prvAno
                                                            .anonymousEntries[i]
                                                            .firstname,
                                                        lastname: prvAno
                                                            .anonymousEntries[i]
                                                            .lastname,
                                                        workemail: prvAno
                                                            .anonymousEntries[i]
                                                            .thirdpartyemail,
                                                        rolewithemployer: []))
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            GestureDetector(
                                              onTap: () async {
                                                String downloadAction =
                                                    "Advisor/DownloadESignDocumentAsync?documentId=";
                                                Uri uri = Uri.parse(
                                                    "$webApiserviceURL$downloadAction${prvAno.anonymousEntries[i].processdocumentid}");

                                                if (prvAno.anonymousEntries[i]
                                                    .documentname.isNotEmpty) {
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri);
                                                  }
                                                } else {
                                                  // Handle error when unable to launch the URL
                                                }
                                              },
                                              child: Center(
                                                child: Tooltip(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    gradient:
                                                        const LinearGradient(
                                                            colors: <Color>[
                                                          AppColors.invite,
                                                          AppColors.red
                                                        ]),
                                                  ),
                                                  message: prvAno
                                                      .anonymousEntries[i]
                                                      .documentname,
                                                  child: Text(
                                                    prvAno.anonymousEntries[i]
                                                        .documentname,
                                                    style: TextStyle(
                                                        decoration: prvAno
                                                                .anonymousEntries[
                                                                    i]
                                                                .anonymouscode
                                                                .isNotEmpty
                                                            ? TextDecoration
                                                                .underline
                                                            : null),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                                child: Text((prvAno
                                                    .anonymousEntries[i]
                                                    .startson))),
                                          ),
                                          DataCell(
                                            Center(
                                                child: ListTile(
                                              leading: IconButton(
                                                  onPressed: () {},
                                                  icon: Image.asset(
                                                    'assets/ontask.png',
                                                    color: AppColors.iconGray,
                                                  )),
                                              title: Text(
                                                prvAno.anonymousEntries[i]
                                                    .overallstatus,
                                                style: getColoredTextStyle(
                                                    prvAno.anonymousEntries[i]
                                                        .overallstatus),
                                              ),
                                            )),
                                          ),
                                        ]),
                                    ]),
                                  ],
                                ),
                              );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /*  Text getTextValue(Employer obj) {
    String textValue = (obj.launchstatus == 'SENTLAUNCHPACK')
        ? "${calculateDateDifference(obj.planeffectivedate)} Days to go"
        : getCurrentDateDiff(obj.planeffectivedate) > 0
            ? 'UNDER RENEWAL PROCESS'
            : 'UNDER LAUNCH PROCESS';
    return Text(textValue,
        style: TextStyle(
            color: getCurrentDateDiff(obj.planeffectivedate) > 0
                ? AppColors.black
                : AppColors.white));
  } */
  Text getTextValue(Employer obj) {
    String textValue = "";

    if (obj.launchstatus == 'SENTLAUNCHPACK') {
      textValue = "${calculateDateDifference(obj.planeffectivedate)} Days to";
      String statusText = getCurrentDateDiff(obj.planeffectivedate) > 0
          ? ' Renewal'
          : ' Launch';
      textValue = textValue + statusText;
    } else {
      textValue = getCurrentDateDiff(obj.planeffectivedate) > 0
          ? 'UNDER RENEWAL PROCESS'
          : 'UNDER LAUNCH PROCESS';
    }
    return Text(textValue,
        style: TextStyle(
            color: getCurrentDateDiff(obj.planeffectivedate) > 0
                ? AppColors.black
                : AppColors.white));
  }

  bool hasSameCompanyCode(List<LaunchPack> launchPacks) {
    if (launchPacks.isEmpty) {
      return false; // Or handle this case according to your requirements
    }
    final firstCompanyCode = launchPacks.first.employercode;
    return launchPacks.every((pack) => pack.employercode == firstCompanyCode);
  }

  Widget noOfDaysTogo(List<LaunchPack> lp, List<Employer> em) {
    bool onlyOneEmployercode = hasSameCompanyCode(lp);
    if (onlyOneEmployercode) {
      Employer obj = em.firstWhere((e) => e.employercode == lp[0].employercode);
      return getTextValue(obj);
    } else {
      return const Text('');
    }
  }

  Widget currentcompany(String employercode, List<Employer> em) {
    Employer selectedEmployer =
        em.firstWhere((e) => e.employercode == employercode);
    return CustomLogoViewer(employer: selectedEmployer);
  }

  ElevatedButton eleButton(
    List<LaunchPack> lp,
    List<Employer> em,
  ) {
    bool onlyOneEmployercode = hasSameCompanyCode(lp);
    if (onlyOneEmployercode) {
      Employer obj = em.firstWhere((e) => e.employercode == lp[0].employercode);
      return ElevatedButton(
          style: (obj.launchstatus == 'SENTLAUNCHPACK')
              ? getButtonLaunchStyle(
                  calculateDateDifference(obj.planeffectivedate))
              : buttonStyleInvite,
          onPressed: () => {},
          child: noOfDaysTogo(lp, em));
    } else {
      return ElevatedButton(onPressed: () {}, child: const Text(''));
    }
  }
}
