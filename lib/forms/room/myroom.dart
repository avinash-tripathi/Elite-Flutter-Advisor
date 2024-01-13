import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_logoviewer.dart';
import 'package:advisorapp/custom/custom_profileviewer.dart';
import 'package:advisorapp/esignwidget/iframeroom.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/employerassistant.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/esign/esigndocument.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/launchstatus.dart';
import 'package:advisorapp/models/mail/newactionitemmail.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyRoom extends StatelessWidget {
  const MyRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final prvRoom = Provider.of<RoomsProvider>(context, listen: false);
    prvRoom.clearActionLaunchPack();
    /*  prvRoom.getInitialLaunchPack(
        loginProvider.logedinUser.accountcode, '', 'Individual');
    prvRoom.readRooms(loginProvider.logedinUser.workemail); */

    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
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
                    builder: (context, prvAddAction, child) {
                  return hasSameCompanyCode(prvAddAction.launchpacks)
                      ? TextButton(
                          onPressed: () {
                            prvAddAction.addActionLaunchPack();
                          },
                          child: const Text(
                            '+ Add a new to do',
                            style: appstyle,
                          ))
                      : const Text('');
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /* IconButton(
                    onPressed: () async => {
                          await prvRoom.getInitialLaunchPack(
                              loginProvider.logedinUser.accountcode,
                              '',
                              'Individual'),
                          await prvRoom
                              .readRooms(loginProvider.logedinUser.workemail),
                          prvRoom.newActionItem = false
                        },
                    icon: const Icon(Icons.refresh),
                    color: AppColors.blue),IconButton(
                    onPressed: () async => {
                          await prvRoom.getInitialLaunchPack(
                              loginProvider.logedinUser.accountcode,
                              '',
                              'Individual'),
                          await prvRoom
                              .readRooms(loginProvider.logedinUser.workemail),
                          prvRoom.newActionItem = false
                        },
                    icon: const Icon(Icons.refresh),
                    color: AppColors.blue), */
                Consumer<RoomsProvider>(builder: (context, prvText, child) {
                  return (prvText.readingLaunchPack || prvText.readingRooms)
                      ? displaySpin()
                      : hasSameCompanyCode(prvText.launchpacks)
                          ? currentcompany(
                              prvText) /* currentcompany(prvText.launchpacks[0].employercode,
                              prvText.employers) */
                          : Tooltip(
                              textStyle:
                                  const TextStyle(color: AppColors.black),
                              decoration: tooltipdecoration,
                              message:
                                  'Only action items related to you are displayed here.\nGo to an employer workspace if you would like to see action items of all users.',
                              child: Text(prvText.actionItemText,
                                  style: appstyle));
                }),
                /*  Consumer<RoomsProvider>(
                    builder: (context, prvCountDown, child) {
                  return prvCountDown.readingLaunchPack
                      ? displaySpin()
                      : prvCountDown.readingRooms
                          ? displaySpin()
                          : hasSameCompanyCode(prvCountDown.launchpacks)
                              ? eleButton(prvCountDown.launchpacks,
                                  prvCountDown.employers)
                              : IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.refresh),
                                  color: Colors.transparent,
                                );
                }) */
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<RoomsProvider>(builder: (context, prvView, child) {
                    return (prvView.readingLaunchPack || prvView.readingRooms)
                        ? displaySpin()
                        : prvView.viewIframe
                            ? SizedBox(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight - 100,
                                child: IframeRoom(
                                  src: prvView.esignembededdata!.url,
                                ),
                              )
                            : SingleChildScrollView(
                                child: DataTable(columnSpacing: 8, columns: [
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
                                    width: SizeConfig.screenWidth / 4,
                                    child: const Center(
                                        child: Text('Action Item')),
                                  )),
                                  DataColumn(
                                      label: SizedBox(
                                    width: SizeConfig.screenWidth / 10,
                                    child:
                                        const Center(child: Text('Due Date')),
                                  )),
                                  DataColumn(
                                      label: SizedBox(
                                    width: SizeConfig.screenWidth / 8,
                                    child: const Center(child: Text('Status')),
                                  )),
                                  /*  DataColumn(
                                      label: SizedBox(
                                    width: SizeConfig.screenWidth / 15,
                                    child: const Center(
                                        child: Text('Employer')),
                                  )) ,*/
                                ], rows: [
                                  for (var i = 0;
                                      i < prvView.launchpacks.length;
                                      i++)
                                    if (prvView.launchpacks[i].visibility ==
                                            'public' ||
                                        (prvView.launchpacks[i].visibility ==
                                                'private' &&
                                            (prvView.launchpacks[i].fromcode ==
                                                    loginProvider.logedinUser
                                                        .accountcode ||
                                                prvView.launchpacks[i].tocode ==
                                                    loginProvider.logedinUser
                                                        .accountcode)))
                                      DataRow.byIndex(index: i, cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              CustomProfileViewer(
                                                  account: prvView
                                                          .launchpacks[i]
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
                                                          .launchpacks[i]
                                                          .tocodedata ??
                                                      Account(
                                                          rolewithemployer: [])),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          GestureDetector(
                                              onTap: () async {
                                                String downloadAction =
                                                    "Advisor/DownloadESignDocumentAsync?documentId=";
                                                Uri uri = Uri.parse("");
                                                if (prvView.launchpacks[i]
                                                            .attachmenttype ==
                                                        "esign" &&
                                                    prvView
                                                        .launchpacks[i]
                                                        .esigndocumentdata
                                                        .processdocumentId!
                                                        .isNotEmpty) {
                                                  uri = Uri.parse(
                                                      "$webApiserviceURL$downloadAction${prvView.launchpacks[i].esigndocumentdata.processdocumentId}");
                                                } else {
                                                  uri = Uri.parse(
                                                      "$defaultActionItemPath${prvView.launchpacks[i].formcode}/${prvView.launchpacks[i].formcodewithextension}");
                                                }

                                                if (prvView
                                                    .launchpacks[i]
                                                    .formcodewithextension
                                                    .isNotEmpty) {
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri);
                                                  }
                                                } else {
                                                  // Handle error when unable to launch the URL
                                                }
                                              },
                                              child: Center(
                                                child: ListTile(
                                                  leading: Text(
                                                    prvView.launchpacks[i]
                                                        .formname,
                                                    style: TextStyle(
                                                        decoration: prvView
                                                                .launchpacks[i]
                                                                .formcodewithextension
                                                                .isNotEmpty
                                                            ? TextDecoration
                                                                .underline
                                                            : null),
                                                  ),
                                                  trailing: prvView
                                                              .launchpacks[i]
                                                              .attachmenttype ==
                                                          "esign"
                                                      ? IconButton(
                                                          icon: Image.asset(
                                                              "assets/ontask.png",
                                                              color: AppColors
                                                                  .iconGray),
                                                          onPressed: () async {
                                                            var docId = prvView
                                                                .launchpacks[i]
                                                                .esigndocumentdata
                                                                .esigndocumentid;
                                                            var formdefinitionId = prvView
                                                                .launchpacks[i]
                                                                .esigndocumentdata
                                                                .formdefinitionid;
                                                            await prvView
                                                                .generateESignEmbeddedURL(
                                                                    docId,
                                                                    formdefinitionId)
                                                                .then((value) {
                                                              prvView.viewIframe =
                                                                  true;
                                                            });
                                                          },
                                                        )
                                                      : null,
                                                ),
                                              )),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Row(
                                              children: [
                                                Text(
                                                  DateFormat('MM-dd-yyyy')
                                                      .format(DateTime.parse(
                                                          prvView.launchpacks[i]
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
                                                              context: context,
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
                                                                bool result =
                                                                    await EliteDialog(
                                                                        context,
                                                                        'Please Confirm',
                                                                        'Do you want to save the changes?',
                                                                        'Yes',
                                                                        'No');
                                                                if (result) {
                                                                  prvView.setLaunchDueDate(
                                                                      i,
                                                                      selectedDate);
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
                                                              }
                                                            });
                                                          },
                                                    icon: const Icon(
                                                      Icons.date_range,
                                                      color: AppColors.blue,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: DropdownButton<LaunchStatus>(
                                              value: prvView.launchStatusList
                                                  .firstWhere(
                                                      (element) =>
                                                          element.code ==
                                                          prvView.launchpacks[i]
                                                              .formstatus,
                                                      orElse: () => prvView
                                                          .launchStatusList[0]),
                                              onChanged: (!(loginProvider
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
                                                                  .fromcode) ||
                                                      prvView.launchpacks[i]
                                                              .attachmenttype ==
                                                          "esign")
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
                                                        prvView.setLaunchStatus(
                                                            i, newValue!);
                                                        prvView.updateLaunchFormStatus(
                                                            prvView
                                                                .launchpacks[i]
                                                                .accountcode,
                                                            prvView
                                                                .launchpacks[i]
                                                                .employercode,
                                                            prvView
                                                                .launchpacks[i]
                                                                .formcode,
                                                            prvView
                                                                .launchpacks[i]
                                                                .formstatus,
                                                            prvView
                                                                .launchpacks[i]
                                                                .duedate);
                                                      }
                                                    },
                                              items: prvView.launchStatusList
                                                  .where((e) =>
                                                      e.key ==
                                                      prvView.launchpacks[i]
                                                          .attachmenttype)
                                                  .map((status) {
                                                return DropdownMenuItem<
                                                    LaunchStatus>(
                                                  value: status,
                                                  child: Text(
                                                    status.name,
                                                    style: getColoredTextStyle(
                                                        status.code),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        /* DataCell(
                                          Center(
                                            child: Text(
                                              prvView.launchpacks[i]
                                                  .employername,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ), */
                                      ]),
                                ]),
                              );
                  }),
                  const Divider(color: AppColors.sidemenu),
                  //adding new to do list
                  Consumer<RoomsProvider>(builder: (context, prvNew, child) {
                    return prvNew.newActionItem
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 8.0,
                              columns: [
                                const DataColumn(
                                    label: SizedBox(
                                  width: 20.0,
                                  child: Center(child: Text('#')),
                                )),
                                DataColumn(
                                  label: SizedBox(
                                    width: SizeConfig.screenWidth / 12,
                                    child: const Center(child: Text('From')),
                                  ),
                                ),
                                DataColumn(
                                    label: SizedBox(
                                      width: SizeConfig.screenWidth / 10,
                                      child: const Center(child: Text('To')),
                                    ),
                                    numeric: true),
                                DataColumn(
                                    label: SizedBox(
                                      width: SizeConfig.screenWidth / 10,
                                      child: const Center(child: Text('Item')),
                                    ),
                                    numeric: true),
                                DataColumn(
                                    label: SizedBox(
                                      width: SizeConfig.screenWidth / 15,
                                      child: const Center(
                                          child: Text('Attachment')),
                                    ),
                                    numeric: true),
                                DataColumn(
                                    label: SizedBox(
                                      width: SizeConfig.screenWidth / 10,
                                      child:
                                          const Center(child: Text('Due Date')),
                                    ),
                                    numeric: true),
                                DataColumn(
                                    label: SizedBox(
                                      width: SizeConfig.screenWidth / 20,
                                      child:
                                          const Center(child: Text('Private')),
                                    ),
                                    numeric: true),
                                DataColumn(
                                    label: SizedBox(
                                      width: SizeConfig.screenWidth / 20,
                                      child:
                                          const Center(child: Text('Action')),
                                    ),
                                    numeric: true),
                              ],
                              rows: [
                                for (var i = 0;
                                    i < prvNew.actionlaunchpacks.length;
                                    i++)
                                  DataRow(cells: [
                                    DataCell(IconButton(
                                      onPressed:
                                          !prvNew.actionlaunchpacks[i].newAction
                                              ? null
                                              : () {
                                                  prvNew.removeLaunchPack(i);
                                                },
                                      icon:
                                          prvNew.actionlaunchpacks[i].newAction
                                              ? const Icon(
                                                  Icons.close,
                                                  color: AppColors.red,
                                                )
                                              : Text((i + 1).toString()),
                                    )),
                                    DataCell(
                                      Center(
                                          child: DropdownButton<EmployerAssist>(
                                        value: prvNew.selectedFromAssist,
                                        items: prvNew.employerAssistList
                                            .map((EmployerAssist value) {
                                              return DropdownMenuItem<
                                                  EmployerAssist>(
                                                value: value,
                                                child: Text(
                                                  value.account.accountname
                                                      .trim(),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            })
                                            .toSet()
                                            .toList(),
                                        onChanged: (EmployerAssist? value) {
                                          prvNew.selectedFromAssist = value!;
                                        },
                                      )),
                                    ),
                                    DataCell(
                                      Center(
                                        child: DropdownButton<EmployerAssist>(
                                          value: prvNew.selectedToAssist,
                                          items: prvNew.employerAssistList
                                              .map((EmployerAssist value) {
                                                return DropdownMenuItem<
                                                    EmployerAssist>(
                                                  value: value,
                                                  child: Text(
                                                    value.account.accountname
                                                        .trim(),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              })
                                              .toSet()
                                              .toList(),
                                          onChanged: (EmployerAssist? value) {
                                            prvNew.selectedToAssist = value;
                                          },
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: TextFormField(
                                          initialValue: prvNew
                                              .actionlaunchpacks[i].formname,
                                          decoration: const InputDecoration(
                                            labelText: 'Item',
                                          ),
                                          onChanged: (value) {
                                            prvNew.actionlaunchpacks[i]
                                                .formname = value;
                                          },
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(Center(
                                      child: ListTile(
                                        leading: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            DropdownButton<AttachmentType>(
                                              value: prvNew.attachmentTypeList
                                                  .firstWhere((element) =>
                                                      element.code ==
                                                      prvNew
                                                          .actionlaunchpacks[i]
                                                          .attachmenttype),
                                              onChanged: (newValue) {
                                                prvNew.setAttachmentType(
                                                    i, newValue!);
                                                (newValue.code == "esign")
                                                    ? EliteDialog(
                                                        context,
                                                        'Alert',
                                                        'Please note that once the document is sent for eSign, the sender or the receiver won’t be able to change signatories. If signatories need to be changed, you can send a new document for eSign.',
                                                        'Ok',
                                                        'Close')
                                                    : null;
                                              },
                                              items: prvNew.attachmentTypeList
                                                  .map((status) {
                                                return DropdownMenuItem<
                                                    AttachmentType>(
                                                  value: status,
                                                  child: Text(
                                                    status.name,
                                                    style: TextStyle(
                                                        color: (status.code ==
                                                                'file')
                                                            ? Colors.blue
                                                            : (status.code ==
                                                                    'esign')
                                                                ? Colors.green
                                                                : (status.code ==
                                                                        'inactive')
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            prvNew.actionlaunchpacks[i]
                                                        .newAction &&
                                                    (prvNew.actionlaunchpacks[i]
                                                                .attachmenttype ==
                                                            'esign' ||
                                                        prvNew.actionlaunchpacks[i]
                                                                .attachmenttype ==
                                                            'file')
                                                ? IconButton(
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .paperclip),
                                                    onPressed: (prvNew
                                                            .actionlaunchpacks[
                                                                i]
                                                            .formcode
                                                            .isNotEmpty)
                                                        ? null
                                                        : () async {
                                                            ActionLaunchPack
                                                                obj =
                                                                prvNew.actionlaunchpacks[
                                                                    i];
                                                            await prvNew
                                                                .pickFile(
                                                                    obj, i);
                                                          },
                                                  )
                                                : Center(
                                                    child: prvNew
                                                                .actionlaunchpacks[
                                                                    i]
                                                                .attachmenttype ==
                                                            'esign'
                                                        ? Tooltip(
                                                            decoration:
                                                                tooltipdecorationGradient,
                                                            message:
                                                                "View ESign Template",
                                                            child: IconButton(
                                                              iconSize: 20,
                                                              onPressed:
                                                                  () async {
                                                                var docId = prvNew
                                                                    .actionlaunchpacks[
                                                                        i]
                                                                    .esigndocumentdata
                                                                    .esigndocumentid;
                                                                var formdefinitionId = prvNew
                                                                    .actionlaunchpacks[
                                                                        i]
                                                                    .esigndocumentdata
                                                                    .formdefinitionid;
                                                                await prvNew
                                                                    .generateESignEmbeddedURL(
                                                                        docId,
                                                                        formdefinitionId)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              prvNew.viewIframe = true
                                                                            });
                                                              },
                                                              style:
                                                                  buttonStyleAmber,
                                                              icon: Image.asset(
                                                                'assets/ontask.png',
                                                                color: AppColors
                                                                    .iconGray,
                                                              ),
                                                            ),
                                                          )
                                                        : const Text(''),
                                                  ),
                                          ],
                                        ),
                                        title: Tooltip(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            gradient: const LinearGradient(
                                                colors: <Color>[
                                                  AppColors.invite,
                                                  AppColors.red
                                                ]),
                                          ),
                                          message: prvNew
                                              .actionlaunchpacks[i].filename,
                                          child: Text(prvNew
                                              .actionlaunchpacks[i]
                                              .fileextension),
                                        ),
                                      ),
                                    )),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                (prvNew.assistDueDate == null)
                                                    ? DateFormat('MM-dd-yyyy')
                                                        .format(DateTime.now())
                                                    : DateFormat('MM-dd-yyyy')
                                                        .format(prvNew
                                                            .assistDueDate!),
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                            IconButton(
                                                onPressed: () async {
                                                  prvNew.assistDueDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        prvNew.assistDueDate!,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2100),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.date_range,
                                                  color: AppColors.blue,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Tooltip(
                                          textStyle: const TextStyle(
                                              color: AppColors.black),
                                          decoration: tooltipdecoration,
                                          message: prvNew.toDotooltip,
                                          child: Checkbox(
                                            value:
                                                prvNew.selectedVisibilityStatus,
                                            onChanged: (value) {
                                              prvNew.selectedVisibilityStatus =
                                                  value!;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: prvNew.savingLaunchPack
                                            ? ElevatedButton(
                                                onPressed: null,
                                                child: displaySpin())
                                            : IconButton(
                                                icon: const Icon(
                                                  Icons.save,
                                                  color: AppColors.blue,
                                                ),
                                                onPressed: () async {
                                                  List<ActionLaunchPack> lists =
                                                      [];
                                                  ActionLaunchPack obj = ActionLaunchPack(
                                                      filebase64: prvNew
                                                          .actionlaunchpacks[i]
                                                          .filebase64,
                                                      fileextension: prvNew
                                                          .actionlaunchpacks[i]
                                                          .fileextension,
                                                      formcode: '',
                                                      formname: prvNew
                                                          .actionlaunchpacks[i]
                                                          .formname,
                                                      launchpack: false,
                                                      renewalpack: false,
                                                      filename: prvNew
                                                          .actionlaunchpacks[i]
                                                          .filename,
                                                      attachmenttype: prvNew
                                                          .actionlaunchpacks[i]
                                                          .attachmenttype,
                                                      contentmimetype: prvNew
                                                          .actionlaunchpacks[i]
                                                          .contentmimetype,
                                                      esigndocumentdata:
                                                          ESignDocument(
                                                              esigndocumentid:
                                                                  '',
                                                              formdefinitionid:
                                                                  ''));
                                                  lists.add(obj);
                                                  if (obj.fileextension
                                                          .isEmpty &&
                                                      (obj.attachmenttype ==
                                                              'esign' ||
                                                          obj.attachmenttype ==
                                                              'file')) {
                                                    EliteDialog(
                                                        context,
                                                        "Alert",
                                                        "Please attach a valid document.",
                                                        "Ok",
                                                        "Cancel");
                                                    return;
                                                  }
                                                  Employer selectedEmployer =
                                                      Employer(partners: []);

                                                  if (hasSameCompanyCode(
                                                      prvNew.launchpacks)) {
                                                    selectedEmployer = prvRoom
                                                        .employers
                                                        .firstWhere((e) =>
                                                            e.employercode ==
                                                            prvNew
                                                                .launchpacks[0]
                                                                .employercode);
                                                  }

                                                  AccountAction objAct =
                                                      AccountAction(
                                                          accountcode:
                                                              selectedEmployer
                                                                  .accountcode,
                                                          employercode:
                                                              selectedEmployer
                                                                  .employercode,
                                                          formfileupload:
                                                              lists);

                                                  await prvNew
                                                      .saveActionLaunchPack(
                                                          objAct, i)
                                                      .then((value) async {
                                                    //write code to insert directly in launchpack for this employer only.
                                                    ActionLaunchPack
                                                        objNewAdded =
                                                        prvNew.actionlaunchpacks[
                                                            i];
                                                    LaunchPack obj = LaunchPack(
                                                        accountowners: [],
                                                        esigndocumentdata:
                                                            ESignDocument(
                                                                esigndocumentid:
                                                                    '',
                                                                formdefinitionid:
                                                                    ''));
                                                    obj.formcode =
                                                        objNewAdded.formcode;
                                                    obj.attachmenttype =
                                                        objNewAdded
                                                            .attachmenttype;
                                                    obj.fromcode = prvNew
                                                        .selectedFromAssist!
                                                        .account
                                                        .accountcode;
                                                    obj.tocode = prvNew
                                                        .selectedToAssist!
                                                        .account
                                                        .accountcode;
                                                    obj.accountcode =
                                                        selectedEmployer
                                                            .accountcode;
                                                    obj.employercode =
                                                        selectedEmployer
                                                            .employercode;
                                                    obj.launchcode = prvNew
                                                        .launchpacks[0]
                                                        .launchcode;
                                                    obj.duedate = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(prvRoom
                                                            .assistDueDate!);

                                                    obj.attachmenttype =
                                                        objNewAdded
                                                            .attachmenttype;
                                                    if (objNewAdded
                                                            .attachmenttype ==
                                                        'esign') {
                                                      obj.formstatus =
                                                          selectedEmployer
                                                                      .launchstatus ==
                                                                  'INITIATE'
                                                              ? 'esignnotsent'
                                                              : 'esigninprogress';
                                                    }
                                                    if (objNewAdded
                                                            .attachmenttype ==
                                                        'file') {
                                                      obj.formstatus =
                                                          selectedEmployer
                                                                      .launchstatus ==
                                                                  'INITIATE'
                                                              ? 'notsent'
                                                              : 'InProgress';
                                                    }
                                                    if (objNewAdded
                                                            .attachmenttype ==
                                                        'none') {
                                                      obj.formstatus =
                                                          selectedEmployer
                                                                      .launchstatus ==
                                                                  'INITIATE'
                                                              ? 'none'
                                                              : 'noneinprogress';
                                                    }

                                                    obj.visibility = (prvNew
                                                            .selectedVisibilityStatus)
                                                        ? 'private'
                                                        : 'public';

                                                    var objMail =
                                                        NewActionItemMail();
                                                    objMail.toRecipientEmailId =
                                                        prvNew.selectedToAssist!
                                                            .account.workemail;
                                                    objMail.employerCompanyName =
                                                        selectedEmployer
                                                            .companyname;
                                                    if (objNewAdded
                                                            .attachmenttype ==
                                                        "esign") {
                                                      await prvNew
                                                          .generateESignEmbeddedURL(
                                                              prvNew
                                                                  .actionlaunchpacks[
                                                                      i]
                                                                  .esigndocumentdata
                                                                  .esigndocumentid,
                                                              prvNew
                                                                  .actionlaunchpacks[
                                                                      i]
                                                                  .esigndocumentdata
                                                                  .formdefinitionid)
                                                          .then((value) {
                                                        prvNew.viewIframe =
                                                            true;
                                                      });
                                                    }

                                                    if (obj
                                                        .formcode.isNotEmpty) {
                                                      await prvNew
                                                          .insertLaunchPackForEmployer(
                                                              obj)
                                                          .then((value) {
                                                        prvNew
                                                            .sendAssignmentEmail(
                                                                objMail);
                                                        //remove actionitem from list and clear the array.

                                                        prvNew
                                                            .clearActionLaunchPack();
                                                        prvNew.getInitialLaunchPack(
                                                            selectedEmployer
                                                                .accountcode,
                                                            selectedEmployer
                                                                .employercode,
                                                            'Advisor');
                                                      });
                                                    }
                                                  });
                                                },
                                              ),
                                      ),
                                    ),
                                  ]),
                              ],
                            ),
                          )
                        : const Text('');
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget currentcompany(RoomsProvider prvText) {
    String employercode = prvText.launchpacks[0].employercode;
    List<Employer> em = prvText.employers;

    Employer selectedEmployer =
        em.firstWhere((e) => e.employercode == employercode);
    return Column(
      children: [
        Tooltip(
            textStyle: const TextStyle(color: AppColors.black),
            decoration: tooltipdecoration,
            message:
                'Only action items related to you are displayed here.\nGo to an employer workspace if you would like to see action items of all users.',
            child: Text(prvText.actionItemText, style: appstyle)),
        CustomLogoViewer(employer: selectedEmployer),
      ],
    );
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
