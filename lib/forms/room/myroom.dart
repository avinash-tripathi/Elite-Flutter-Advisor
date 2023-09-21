import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_logoviewer.dart';
import 'package:advisorapp/custom/custom_profileviewer.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/employerassistant.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/launchstatus.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        color: AppColors.blue),
                    Consumer<RoomsProvider>(builder: (context, prvText, child) {
                      return hasSameCompanyCode(prvText.launchpacks)
                          ? currentcompany(prvText.launchpacks[0].employercode,
                              prvText.employers)
                          : const Text('My Action Items', style: appstyle);
                    }),
                    Consumer<RoomsProvider>(
                        builder: (context, prvCountDown, child) {
                      return prvCountDown.readingLaunchPack
                          ? displaySpin()
                          : hasSameCompanyCode(prvCountDown.launchpacks)
                              ? eleButton(prvCountDown.launchpacks,
                                  prvCountDown.employers)
                              : IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.refresh),
                                  color: Colors.transparent,
                                );
                    })
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
                                child: DataTable(columnSpacing: 15, columns: [
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
                                  DataColumn(
                                      label: SizedBox(
                                    width: SizeConfig.screenWidth / 15,
                                    child:
                                        const Center(child: Text('Employer')),
                                  )),

                                  /*  DataColumn(
                                                        label: SizedBox(
                                                      width: 100.0,
                                                      child: Center(
                                                          child: Text(
                                                              'Action')),
                                                    )), */
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
                                                Uri uri = Uri.parse(
                                                    "$defaultActionItemPath${prvView.launchpacks[i].formcode}/${prvView.launchpacks[i].formcodewithextension}");
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
                                                  message: prvView
                                                      .launchpacks[i]
                                                      .actionitemdata
                                                      ?.filename,
                                                  child: Text(
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
                                                ),
                                              )),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Row(
                                              children: [
                                                Text(
                                                  DateFormat('dd-MMM-yyyy')
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
                                                                        'Please confirm',
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
                                              onChanged: !(loginProvider
                                                              .logedinUser
                                                              .accountcode ==
                                                          prvView.launchpacks[i]
                                                              .tocode ||
                                                      loginProvider.logedinUser
                                                              .accountcode ==
                                                          prvView.launchpacks[i]
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
                                        DataCell(
                                          Center(
                                            child: Text(
                                              prvView
                                                  .launchpacks[i].employername,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ]),
                              );
                      }),
                      const Divider(color: AppColors.sidemenu),
                      //adding new to do list
                      Consumer<RoomsProvider>(
                          builder: (context, prvNew, child) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 8.0,
                            columns: [
                              DataColumn(
                                  label: SizedBox(
                                    width: SizeConfig.screenWidth / 15,
                                    child: const Center(child: Text('From')),
                                  ),
                                  numeric: true),
                              DataColumn(
                                  label: SizedBox(
                                    width: SizeConfig.screenWidth / 15,
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
                                    child:
                                        const Center(child: Text('Attachment')),
                                  ),
                                  numeric: true),
                              DataColumn(
                                  label: SizedBox(
                                    width: SizeConfig.screenWidth / 15,
                                    child:
                                        const Center(child: Text('Due Date')),
                                  ),
                                  numeric: true),
                              DataColumn(
                                  label: SizedBox(
                                    width: SizeConfig.screenWidth / 20,
                                    child: const Center(child: Text('Private')),
                                  ),
                                  numeric: true),
                              DataColumn(
                                  label: SizedBox(
                                    width: SizeConfig.screenWidth / 16,
                                    child: const Center(child: Text('Action')),
                                  ),
                                  numeric: true),
                            ],
                            rows: [
                              for (var i = 0;
                                  i < prvNew.actionlaunchpacks.length;
                                  i++)
                                DataRow(cells: [
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
                                                overflow: TextOverflow.ellipsis,
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
                                          prvNew.actionlaunchpacks[i].formname =
                                              value;
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
                                                    prvNew.actionlaunchpacks[i]
                                                        .attachmenttype),
                                            onChanged: (newValue) {
                                              prvNew.setAttachmentType(
                                                  i, newValue!);
                                              // add your code to handle the value change here
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
                                                                  'docsign')
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
                                          IconButton(
                                            icon: const Icon(
                                                FontAwesomeIcons.paperclip),
                                            onPressed: (prvNew
                                                    .actionlaunchpacks[i]
                                                    .formcode
                                                    .isNotEmpty)
                                                ? null
                                                : () async {
                                                    ActionLaunchPack obj = prvNew
                                                        .actionlaunchpacks[i];

                                                    await prvNew.pickFile(
                                                        obj, i);
                                                  },
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
                                        child: Text(prvNew.actionlaunchpacks[i]
                                            .fileextension),
                                      ),
                                    ),
                                  )),
                                  DataCell(
                                    Center(
                                      child: Row(
                                        children: [
                                          Text(
                                              (prvNew.assistDueDate == null)
                                                  ? DateFormat('dd-MMM-yyyy')
                                                      .format(DateTime.now())
                                                  : DateFormat('dd-MMM-yyyy')
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
                                        message: prvNew.selectedVisibilityStatus
                                            ? 'If you uncheck Private, then the item will be visible to other users within your company'
                                            : 'Private items will be visible only to the Sender and Receiver within your company',
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
                                                ActionLaunchPack obj =
                                                    ActionLaunchPack(
                                                  attachmenttype: prvNew
                                                      .actionlaunchpacks[i]
                                                      .attachmenttype,
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
                                                );
                                                lists.add(obj);
                                                Employer selectedEmployer =
                                                    Employer(partners: []);

                                                if (hasSameCompanyCode(
                                                    prvNew.launchpacks)) {
                                                  selectedEmployer = prvRoom
                                                      .employers
                                                      .firstWhere((e) =>
                                                          e.employercode ==
                                                          prvNew.launchpacks[0]
                                                              .employercode);
                                                }

                                                AccountAction objAct =
                                                    AccountAction(
                                                        accountcode:
                                                            /*  prvEmployer
                                                                            .selectedToAssist!
                                                                            .code */
                                                            selectedEmployer
                                                                .accountcode,
                                                        employercode:
                                                            selectedEmployer
                                                                .employercode,
                                                        formfileupload: lists);

                                                await prvNew
                                                    .saveActionLaunchPack(
                                                        objAct, i)
                                                    .then((value) {
                                                  //write code to insert directly in launchpack for this employer only.
                                                  ActionLaunchPack objNewAdded =
                                                      prvNew
                                                          .actionlaunchpacks[i];
                                                  LaunchPack obj = LaunchPack();
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
                                                  obj.duedate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(prvRoom
                                                              .assistDueDate!);
                                                  obj.formstatus = objNewAdded
                                                              .attachmenttype ==
                                                          'file'
                                                      ? 'InProgress'
                                                      : 'DocuSigntobesent';

                                                  obj.visibility = (prvNew
                                                          .selectedVisibilityStatus)
                                                      ? 'private'
                                                      : 'public';

                                                  prvNew
                                                      .insertLaunchPackForEmployer(
                                                          obj)
                                                      .then((value) {
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
                                                });
                                              },
                                            ),
                                    ),
                                  ),
                                ]),
                            ],
                          ),
                        );
                      })
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
