// ignore_for_file: prefer_const_constructors

import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/custom/custom_logoviewer.dart';
import 'package:advisorapp/custom/custom_profileviewer.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/employerassistant.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/esign/esigndocument.dart';
import 'package:advisorapp/esignwidget/iframeEmployer.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/launchstatus.dart';
import 'package:advisorapp/models/mail/newactionitemmail.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/employer.dart';

// ignore: camel_case_types
class SLEmployerLaunchPack extends StatelessWidget {
  final Employer selectedEmployer;
  const SLEmployerLaunchPack({Key? key, required this.selectedEmployer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final prvEmployer = Provider.of<EmployerProvider>(context, listen: false);

    return Background(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child: Form(
                child: SingleChildScrollView(
                    padding: defaultSymmetricPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  prvEmployer.setSelectedFromAssistToNull();
                                  prvEmployer.setSelectedToAssistToNull();
                                  prvEmployer.addActionLaunchPack();
                                },
                                child: const Text(
                                  '+ Add a new to do',
                                  style: appstyle,
                                )),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.keyboard_return,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: SizeConfig.screenWidth / 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomLogoViewer(
                                        employer: selectedEmployer),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        selectedEmployer.companyname,
                                        style: appstyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  style: (selectedEmployer.launchstatus ==
                                          'SENTLAUNCHPACK')
                                      ? getButtonLaunchStyle(
                                          calculateDateDifference(
                                              selectedEmployer
                                                  .planeffectivedate))
                                      : buttonStyleInvite,
                                  onPressed: (prvEmployer.updatelaunchstatus &&
                                          selectedEmployer.launchstatus !=
                                              'SENTLAUNCHPACK')
                                      ? null
                                      : () async {
                                          Employer obj = selectedEmployer;
                                          await prvEmployer
                                              .updateLaunchStatus(
                                                  obj.accountcode,
                                                  obj.employercode,
                                                  "SENTLAUNCHPACK")
                                              .then((value) async {
                                            selectedEmployer.launchstatus =
                                                "SENTLAUNCHPACK";
                                            await prvEmployer
                                                .getInitialLaunchPack(
                                                    obj.accountcode,
                                                    obj.employercode,
                                                    'Advisor');
                                          });
                                        },
                                  child: prvEmployer.updatelaunchstatus
                                      ? displaySpin()
                                      : Consumer<EmployerProvider>(
                                          builder: (context, prvText, child) {
                                          return getTextValue(selectedEmployer);
                                        })),
                            ],
                          ),
                        ),
                        prvEmployer.readingLaunchPack
                            ? displaySpin()
                            : Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: SizeConfig.screenWidth,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Consumer<EmployerProvider>(
                                                  builder:
                                                      (context, prvDis, child) {
                                                return prvDis.viewIframe
                                                    ? SizedBox(
                                                        width: SizeConfig
                                                            .screenWidth,
                                                        height: SizeConfig
                                                                .screenHeight -
                                                            120,
                                                        child: IframeEmployer(
                                                          src: prvDis
                                                              .esignembededdata!
                                                              .url,
                                                        ),
                                                      )
                                                    : SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: DataTable(
                                                            columnSpacing: 8.0,
                                                            columns: [
                                                              DataColumn(
                                                                  label:
                                                                      SizedBox(
                                                                width: SizeConfig
                                                                        .screenWidth /
                                                                    25,
                                                                child:
                                                                    const Text(
                                                                        'From'),
                                                              )),
                                                              DataColumn(
                                                                  label:
                                                                      SizedBox(
                                                                width: SizeConfig
                                                                        .screenWidth /
                                                                    25,
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                      'To'),
                                                                ),
                                                              )),
                                                              DataColumn(
                                                                  label:
                                                                      SizedBox(
                                                                width: SizeConfig
                                                                        .screenWidth /
                                                                    4,
                                                                child: const Center(
                                                                    child: Text(
                                                                        'Action Item')),
                                                              )),
                                                              DataColumn(
                                                                  label:
                                                                      SizedBox(
                                                                width: SizeConfig
                                                                        .screenWidth /
                                                                    12,
                                                                child: const Center(
                                                                    child: Text(
                                                                        'Due Date')),
                                                              )),
                                                              DataColumn(
                                                                  label:
                                                                      SizedBox(
                                                                width: SizeConfig
                                                                        .screenWidth /
                                                                    8,
                                                                child: const Center(
                                                                    child: Text(
                                                                        'Status')),
                                                              )),
                                                            ],
                                                            rows: [
                                                              for (var i = 0;
                                                                  i <
                                                                      prvDis
                                                                          .launchpacks
                                                                          .length;
                                                                  i++)
                                                                DataRow.byIndex(
                                                                    index: i,
                                                                    cells: [
                                                                      DataCell(
                                                                        Row(
                                                                          children: [
                                                                            CustomProfileViewer(account: prvDis.launchpacks[i].fromcodedata ?? Account(rolewithemployer: [])),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Row(
                                                                          children: [
                                                                            Center(
                                                                              child: CustomProfileViewer(account: prvDis.launchpacks[i].tocodedata ?? Account(rolewithemployer: [])),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              String downloadAction = "Advisor/DownloadESignDocumentAsync?documentId=";
                                                                              Uri uri = Uri.parse("");
                                                                              if (prvDis.launchpacks[i].attachmenttype == "esign" && prvDis.launchpacks[i].esigndocumentdata.processdocumentId!.isNotEmpty) {
                                                                                uri = Uri.parse("$webApiserviceURL$downloadAction${prvDis.launchpacks[i].esigndocumentdata.processdocumentId}");
                                                                              } else {
                                                                                uri = Uri.parse("$defaultActionItemPath${prvDis.launchpacks[i].formcode}/${prvDis.launchpacks[i].formcodewithextension}");
                                                                              }

                                                                              if (prvDis.launchpacks[i].formcodewithextension.isNotEmpty) {
                                                                                if (await canLaunchUrl(uri)) {
                                                                                  await launchUrl(uri);
                                                                                }
                                                                              } else {
                                                                                // Handle error when unable to launch the URL
                                                                              }
                                                                            },
                                                                            child:
                                                                                Center(
                                                                              child: ListTile(
                                                                                leading: Text(
                                                                                  prvDis.launchpacks[i].formname,
                                                                                  style: TextStyle(decoration: prvDis.launchpacks[i].formcodewithextension.isNotEmpty ? TextDecoration.underline : null),
                                                                                ),
                                                                                trailing: prvDis.launchpacks[i].attachmenttype == "esign"
                                                                                    ? IconButton(
                                                                                        icon: Image.asset("assets/ontask.png"),
                                                                                        onPressed: () async {
                                                                                          var docId = prvDis.launchpacks[i].esigndocumentdata.esigndocumentid;
                                                                                          var formdefinitionId = prvDis.launchpacks[i].esigndocumentdata.formdefinitionid;
                                                                                          await prvDis.generateESignEmbeddedURL(docId, formdefinitionId).then((value) {
                                                                                            prvDis.viewIframe = true;
                                                                                          });
                                                                                        },
                                                                                      )
                                                                                    : null,
                                                                              ),
                                                                            )),
                                                                      ),
                                                                      DataCell(
                                                                        Center(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Consumer<EmployerProvider>(builder: (context, prvEDate, child) {
                                                                                return Text(
                                                                                  DateFormat('MM-dd-yyyy').format(DateTime.parse(prvEDate.launchpacks[i].duedate)),
                                                                                );
                                                                              }),
                                                                              IconButton(
                                                                                  onPressed: () {
                                                                                    showDatePicker(
                                                                                      context: context,
                                                                                      initialDate: DateTime.now(),
                                                                                      firstDate: DateTime(2000),
                                                                                      lastDate: DateTime(2100),
                                                                                    ).then((selectedDate) async {
                                                                                      if (selectedDate != null) {
                                                                                        bool result = await EliteDialog(context, 'Please confirm', 'Do you want to save the changes?', 'Yes', 'No');
                                                                                        if (result) {
                                                                                          prvDis.setLaunchDueDate(i, selectedDate);
                                                                                          prvEmployer.updateLaunchFormStatus(prvEmployer.launchpacks[i].accountcode, prvEmployer.launchpacks[i].employercode, prvEmployer.launchpacks[i].formcode, prvEmployer.launchpacks[i].formstatus, prvEmployer.launchpacks[i].duedate);
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
                                                                          child: Consumer<EmployerProvider>(builder: (context,
                                                                              prvLS,
                                                                              child) {
                                                                            return DropdownButton<LaunchStatus>(
                                                                              value: prvLS.launchStatusList.firstWhere((element) => element.code == prvDis.launchpacks[i].formstatus, orElse: () => prvLS.launchStatusList[0]),
                                                                              onChanged: (prvDis.launchpacks[i].attachmenttype == "esign")
                                                                                  ? null
                                                                                  : (newValue) async {
                                                                                      // add your code to handle the value change here
                                                                                      bool result = await EliteDialog(context, 'Please confirm', 'Do you want to save the changes?', 'Yes', 'No');
                                                                                      if (result) {
                                                                                        prvLS.setLaunchStatus(i, newValue!);
                                                                                        prvEmployer.updateLaunchFormStatus(prvEmployer.launchpacks[i].accountcode, prvEmployer.launchpacks[i].employercode, prvEmployer.launchpacks[i].formcode, prvEmployer.launchpacks[i].formstatus, prvEmployer.launchpacks[i].duedate);
                                                                                      }
                                                                                    },
                                                                              items: prvDis.launchStatusList
                                                                                  .where((e) => e.key == prvDis.launchpacks[i].attachmenttype)
                                                                                  .map((status) {
                                                                                    return DropdownMenuItem<LaunchStatus>(
                                                                                      value: status,
                                                                                      child: Text(
                                                                                        status.name,
                                                                                        style: getColoredTextStyle(status.code),
                                                                                      ),
                                                                                    );
                                                                                  })
                                                                                  .toSet()
                                                                                  .toList(),
                                                                            );
                                                                          }),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                            ]),
                                                      );
                                              }),
                                              const Divider(
                                                  color: AppColors.sidemenu),
                                              //adding new to do list
                                              Consumer<EmployerProvider>(
                                                  builder:
                                                      (context, prvNew, child) {
                                                return SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: DataTable(
                                                    columnSpacing: 8.0,
                                                    columns: [
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                10,
                                                            child: const Center(
                                                                child: Text(
                                                                    'From')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                10,
                                                            child: const Center(
                                                                child:
                                                                    Text('To')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                10,
                                                            child: const Center(
                                                                child: Text(
                                                                    'Item')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                15,
                                                            child: const Center(
                                                                child: Text(
                                                                    'Attachment')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                10,
                                                            child: const Center(
                                                                child: Text(
                                                                    'Due Date')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                16,
                                                            child: const Center(
                                                                child: Text(
                                                                    'Private')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth /
                                                                16,
                                                            child: const Center(
                                                                child: Text(
                                                                    'Action')),
                                                          ),
                                                          numeric: true),
                                                    ],
                                                    rows: [
                                                      for (var i = 0;
                                                          i <
                                                              prvNew
                                                                  .actionlaunchpacks
                                                                  .length;
                                                          i++)
                                                        DataRow(cells: [
                                                          DataCell(
                                                            Center(
                                                                child: DropdownButton<
                                                                    EmployerAssist>(
                                                              value: prvNew
                                                                  .selectedFromAssist,
                                                              items: prvNew
                                                                  .employerAssistList
                                                                  .map((EmployerAssist
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    EmployerAssist>(
                                                                  value: value,
                                                                  child: Text(
                                                                      value
                                                                          .account
                                                                          .accountname
                                                                          .trim(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12)),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (EmployerAssist?
                                                                      value) {
                                                                prvNew.selectedFromAssist =
                                                                    value!;
                                                              },
                                                            )),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: DropdownButton<
                                                                  EmployerAssist>(
                                                                value: prvNew
                                                                    .selectedToAssist,
                                                                items: prvNew
                                                                    .employerAssistList
                                                                    .map((EmployerAssist
                                                                        value) {
                                                                  return DropdownMenuItem<
                                                                      EmployerAssist>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value
                                                                            .account
                                                                            .accountname
                                                                            .trim(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12)),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (EmployerAssist?
                                                                        value) {
                                                                  prvNew.selectedToAssist =
                                                                      value!;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child:
                                                                  TextFormField(
                                                                initialValue: prvNew
                                                                    .actionlaunchpacks[
                                                                        i]
                                                                    .formname,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Item',
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  prvNew
                                                                      .actionlaunchpacks[
                                                                          i]
                                                                      .formname = value;
                                                                },
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(Center(
                                                            child: ListTile(
                                                              leading: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  DropdownButton<
                                                                      AttachmentType>(
                                                                    value: prvNew.attachmentTypeList.firstWhere((element) =>
                                                                        element
                                                                            .code ==
                                                                        prvNew
                                                                            .actionlaunchpacks[i]
                                                                            .attachmenttype),
                                                                    onChanged:
                                                                        (newValue) {
                                                                      prvNew.setAttachmentType(
                                                                          i,
                                                                          newValue!);
                                                                      // add your code to handle the value change here
                                                                    },
                                                                    items: prvNew
                                                                        .attachmentTypeList
                                                                        .map(
                                                                            (status) {
                                                                      return DropdownMenuItem<
                                                                          AttachmentType>(
                                                                        value:
                                                                            status,
                                                                        child:
                                                                            Text(
                                                                          status
                                                                              .name,
                                                                          style: TextStyle(
                                                                              color: (status.code == 'file')
                                                                                  ? Colors.blue
                                                                                  : (status.code == 'esign')
                                                                                      ? Colors.green
                                                                                      : (status.code == 'inactive')
                                                                                          ? Colors.red
                                                                                          : Colors.black),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                  IconButton(
                                                                    icon: const Icon(
                                                                        FontAwesomeIcons
                                                                            .paperclip),
                                                                    onPressed: (prvNew
                                                                            .actionlaunchpacks[i]
                                                                            .formcode
                                                                            .isNotEmpty)
                                                                        ? null
                                                                        : () async {
                                                                            ActionLaunchPack
                                                                                obj =
                                                                                prvNew.actionlaunchpacks[i];
                                                                            await prvNew.pickFile(obj,
                                                                                i);
                                                                          },
                                                                  )
                                                                ],
                                                              ),
                                                              title: Tooltip(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gradient:
                                                                      const LinearGradient(
                                                                          colors: <Color>[
                                                                        AppColors
                                                                            .invite,
                                                                        AppColors
                                                                            .red
                                                                      ]),
                                                                ),
                                                                message: prvNew
                                                                    .actionlaunchpacks[
                                                                        i]
                                                                    .filename,
                                                                child: Text(prvNew
                                                                    .actionlaunchpacks[
                                                                        i]
                                                                    .fileextension),
                                                              ),
                                                            ),
                                                          )),
                                                          DataCell(
                                                            Center(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      (prvNew.assistDueDate ==
                                                                              null)
                                                                          ? DateFormat('MM-dd-yyyy').format(DateTime
                                                                              .now())
                                                                          : DateFormat('MM-dd-yyyy').format(prvNew
                                                                              .assistDueDate!),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12)),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        prvNew.assistDueDate =
                                                                            await showDatePicker(
                                                                          context:
                                                                              context,
                                                                          initialDate:
                                                                              prvNew.assistDueDate!,
                                                                          firstDate:
                                                                              DateTime(1900),
                                                                          lastDate:
                                                                              DateTime(2100),
                                                                        );
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .date_range,
                                                                        color: AppColors
                                                                            .blue,
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: Tooltip(
                                                                message: prvNew
                                                                    .toDotooltip,
                                                                child: Checkbox(
                                                                  value: prvNew
                                                                      .selectedVisibilityStatus,
                                                                  onChanged:
                                                                      (value) {
                                                                    prvNew.selectedVisibilityStatus =
                                                                        value!;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: prvNew
                                                                      .savingLaunchPack
                                                                  ? ElevatedButton(
                                                                      onPressed:
                                                                          null,
                                                                      child:
                                                                          displaySpin())
                                                                  : IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .save,
                                                                        color: AppColors
                                                                            .blue,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        List<ActionLaunchPack>
                                                                            lists =
                                                                            [];
                                                                        ActionLaunchPack obj = ActionLaunchPack(
                                                                            filebase64:
                                                                                prvNew.actionlaunchpacks[i].filebase64,
                                                                            fileextension: prvNew.actionlaunchpacks[i].fileextension,
                                                                            formcode: '',
                                                                            formname: prvNew.actionlaunchpacks[i].formname,
                                                                            launchpack: false,
                                                                            renewalpack: false,
                                                                            filename: prvNew.actionlaunchpacks[i].filename,
                                                                            attachmenttype: prvNew.actionlaunchpacks[i].attachmenttype,
                                                                            contentmimetype: prvNew.actionlaunchpacks[i].contentmimetype,
                                                                            esigndocumentdata: ESignDocument(esigndocumentid: '', formdefinitionid: ''));
                                                                        lists.add(
                                                                            obj);

                                                                        if (obj.fileextension.isEmpty && obj.attachmenttype == 'esign' ||
                                                                            obj.attachmenttype ==
                                                                                'file') {
                                                                          EliteDialog(
                                                                              context,
                                                                              "Alert",
                                                                              "Please attach a valid document.",
                                                                              "Ok",
                                                                              "Cancel");
                                                                          return;
                                                                        }

                                                                        AccountAction objAct = AccountAction(
                                                                            accountcode:
                                                                                selectedEmployer.accountcode,
                                                                            employercode: selectedEmployer.employercode,
                                                                            formfileupload: lists);

                                                                        await prvNew
                                                                            .saveActionLaunchPack(objAct,
                                                                                i)
                                                                            .then((value) async {
                                                                          //write code to insert directly in launchpack for this employer only.
                                                                          ActionLaunchPack
                                                                              objNewAdded =
                                                                              prvNew.actionlaunchpacks[i];
                                                                          LaunchPack
                                                                              obj =
                                                                              LaunchPack(accountowners: [], esigndocumentdata: ESignDocument(esigndocumentid: '', formdefinitionid: ''));
                                                                          obj.formcode =
                                                                              objNewAdded.formcode;
                                                                          obj.fromcode = prvNew
                                                                              .selectedFromAssist!
                                                                              .account
                                                                              .accountcode;
                                                                          obj.tocode = prvNew
                                                                              .selectedToAssist!
                                                                              .account
                                                                              .accountcode;
                                                                          obj.accountcode =
                                                                              selectedEmployer.accountcode;
                                                                          obj.employercode =
                                                                              selectedEmployer.employercode;
                                                                          obj.launchcode = prvNew
                                                                              .launchpacks[0]
                                                                              .launchcode;
                                                                          obj.duedate =
                                                                              DateFormat('yyyy-MM-dd').format(prvEmployer.assistDueDate!);
                                                                          obj.formstatus =
                                                                              'esigninprogress';
                                                                          /*  obj.formstatus = objNewAdded.attachmenttype == 'file'
                                                                              ? 'InProgress'
                                                                              : 'none'; */
                                                                          obj.visibility = (prvNew.selectedVisibilityStatus)
                                                                              ? 'private'
                                                                              : 'public';
                                                                          obj.attachmenttype =
                                                                              objNewAdded.attachmenttype;
                                                                          var objMail =
                                                                              NewActionItemMail();
                                                                          objMail.toRecipientEmailId = prvNew
                                                                              .selectedToAssist!
                                                                              .account
                                                                              .workemail;
                                                                          objMail.employerCompanyName =
                                                                              selectedEmployer.companyname;
                                                                          await prvNew
                                                                              .generateESignEmbeddedURL(prvNew.actionlaunchpacks[i].esigndocumentdata.esigndocumentid, prvNew.actionlaunchpacks[i].esigndocumentdata.formdefinitionid)
                                                                              .then((value) {
                                                                            prvNew.viewIframe =
                                                                                true;
                                                                          });
                                                                          if (obj
                                                                              .formcode
                                                                              .isNotEmpty) {
                                                                            await prvNew.insertLaunchPackForEmployer(obj).then((value) async {
                                                                              //remove actionitem from list and clear the array.
                                                                              prvNew.sendAssignmentEmail(objMail);

                                                                              prvNew.clearActionLaunchPack();
                                                                              prvNew.getInitialLaunchPack(selectedEmployer.accountcode, selectedEmployer.employercode, 'Advisor').then((value) async => {});
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
                                                );
                                              })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              )
                      ],
                    ))),
          ),
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
          ? 'SEND RENEWAL PACK'
          : 'SEND LAUNCH PACK';
    }
    return Text(textValue,
        style: TextStyle(
            color: getCurrentDateDiff(obj.planeffectivedate) > 0
                ? AppColors.black
                : AppColors.white));
  }
}
