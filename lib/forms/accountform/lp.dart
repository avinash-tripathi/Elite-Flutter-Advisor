import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/esignwidget/iframe.dart';

import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/launchstatus.dart';
import 'package:advisorapp/providers/launch_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class LaunchPackDetail extends StatefulWidget {
  const LaunchPackDetail({Key? key}) : super(key: key);

  @override
  State<LaunchPackDetail> createState() => _LaunchPackDetailState();
}

class _LaunchPackDetailState extends State<LaunchPackDetail> {
  TextEditingController controller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final launchProvider = Provider.of<LaunchProvider>(context, listen: false);
    launchProvider.readLaunchPack(loginProvider.logedinUser.accountcode, '');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
        key: _scaffoldKey,
        body: Background(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              flex: 2,
              child: SideMenu(
                key: null,
              ),
            ),
          Expanded(
            flex: 9,
            child: Consumer<LaunchProvider>(
                builder: (context, launchProvider, child) {
              return launchProvider.reading
                  ? displaySpin()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                launchProvider.addLaunchPack();
                                launchProvider.resetAccountActionIndexSaved();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '+Create an employer launch & renewal pack',
                                    style: appstyle,
                                  ),
                                  Tooltip(
                                      textStyle: const TextStyle(
                                          color: AppColors.black),
                                      decoration: tooltipdecoration,
                                      message:
                                          "Create action items that are standard for each client you launch or renew.\nExamples include items like Sign an NDA, Sign an MSA, Send benefits guide, Send current SPD document, etc.\nYour launch pack and renewal pack will be sent out to the client automatically \nby the advisor at the appropriate time. The advisor can choose who receives your action item on \nthe client side and assign a due date, however, you will be able to modify it if necessary.",
                                      child: const Icon(
                                        Icons.info,
                                        color: AppColors.black,
                                      )),
                                ],
                              ),
                            ),
                            launchProvider.viewIframe
                                ? SizedBox(
                                    width: SizeConfig.screenWidth,
                                    height: SizeConfig.screenHeight - 120,
                                    child: MyIframe(
                                      src: launchProvider.esignembededdata!.url,
                                    ),
                                  )
                                : SizedBox(
                                    width: SizeConfig.screenWidth,
                                    height: SizeConfig.screenHeight - 100,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: SizeConfig.screenWidth,
                                          height:
                                              (SizeConfig.screenHeight) * 3 / 4,
                                          child: SingleChildScrollView(
                                            child: DataTable(
                                              columnSpacing: 8.0,
                                              dataRowHeight: 60,
                                              columns: [
                                                const DataColumn(
                                                    label: SizedBox(
                                                  width: 20.0,
                                                  child:
                                                      Center(child: Text('#')),
                                                )),
                                                const DataColumn(
                                                    label: SizedBox(
                                                  width: 180.0,
                                                  child: Center(
                                                      child: Text('Item')),
                                                )),
                                                const DataColumn(
                                                    label: SizedBox(
                                                  width: 120.0,
                                                  child: Center(
                                                      child:
                                                          Text('Attachment')),
                                                )),
                                                const DataColumn(
                                                    label: SizedBox(
                                                  width: 90.0,
                                                  child: Center(
                                                      child:
                                                          Text('Launch Pack')),
                                                )),
                                                const DataColumn(
                                                    label: SizedBox(
                                                  width: 100.0,
                                                  child: Center(
                                                      child:
                                                          Text('Renewal Pack')),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width: 90.0,
                                                  child: Center(
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text('Private'),
                                                      Tooltip(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: AppColors
                                                                      .black),
                                                          decoration:
                                                              tooltipdecoration,
                                                          message:
                                                              'Private items will be visible only to the Sender, Receiver, and the Advisor',
                                                          child: const Icon(
                                                              Icons.info))
                                                    ],
                                                  )),
                                                )),
                                                const DataColumn(
                                                    label: SizedBox(
                                                  width: 90.0,
                                                  child: Center(
                                                      child: Text('Status')),
                                                )),
                                                const DataColumn(
                                                    label: SizedBox(
                                                        width: 100.0,
                                                        child: Center(
                                                            child:
                                                                Text('Save')))),
                                              ],
                                              rows: List.generate(
                                                launchProvider
                                                    .launchpacks.length,
                                                (index) => DataRow(
                                                  cells: [
                                                    DataCell(IconButton(
                                                      onPressed: !launchProvider
                                                              .launchpacks[
                                                                  index]
                                                              .newAction
                                                          ? null
                                                          : () {
                                                              launchProvider
                                                                  .removeLaunchPack(
                                                                      index);
                                                            },
                                                      icon: launchProvider
                                                              .launchpacks[
                                                                  index]
                                                              .newAction
                                                          ? const Icon(
                                                              Icons.close,
                                                              color:
                                                                  AppColors.red,
                                                            )
                                                          : Text((index + 1)
                                                              .toString()),
                                                    )),
                                                    DataCell(TextFormField(
                                                      maxLines: 2,
                                                      readOnly: !launchProvider
                                                          .launchpacks[index]
                                                          .newAction,
                                                      initialValue:
                                                          launchProvider
                                                              .launchpacks[
                                                                  index]
                                                              .formname,
                                                      decoration:
                                                          const InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            AppColors.sidemenu,
                                                        labelText: 'Item',
                                                      ),
                                                      onChanged: (value) {
                                                        launchProvider
                                                            .launchpacks[index]
                                                            .formname = value;
                                                      },
                                                    )),
                                                    DataCell(Center(
                                                      child: ListTile(
                                                        leading: Container(
                                                          color: AppColors
                                                              .sidemenu,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              DropdownButton<
                                                                  AttachmentType>(
                                                                value: launchProvider
                                                                    .attachmentTypeList
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .code ==
                                                                        launchProvider
                                                                            .launchpacks[index]
                                                                            .attachmenttype),
                                                                onChanged:
                                                                    (newValue) {
                                                                  launchProvider
                                                                      .setAttachmentType(
                                                                          index,
                                                                          newValue!);
                                                                  // add your code to handle the value change here
                                                                },
                                                                items: launchProvider
                                                                    .attachmentTypeList
                                                                    .map(
                                                                        (status) {
                                                                  return DropdownMenuItem<
                                                                      AttachmentType>(
                                                                    value:
                                                                        status,
                                                                    child: Text(
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
                                                              launchProvider
                                                                      .launchpacks[
                                                                          index]
                                                                      .newAction
                                                                  ? IconButton(
                                                                      icon: const Icon(
                                                                          FontAwesomeIcons
                                                                              .paperclip),
                                                                      onPressed: (launchProvider
                                                                              .launchpacks[index]
                                                                              .formcode
                                                                              .isNotEmpty)
                                                                          ? null
                                                                          : () async {
                                                                              ActionLaunchPack obj = launchProvider.launchpacks[index];
                                                                              await launchProvider.pickFile(obj, index);
                                                                            },
                                                                    )
                                                                  : Center(
                                                                      child: launchProvider.launchpacks[index].attachmenttype ==
                                                                              'esign'
                                                                          ? Tooltip(
                                                                              decoration: tooltipdecorationGradient,
                                                                              message: "View ESign Template",
                                                                              child: IconButton(
                                                                                iconSize: 20,
                                                                                onPressed: () async {
                                                                                  var docId = launchProvider.launchpacks[index].esigndocumentdata.esigndocumentid;
                                                                                  var formdefinitionId = launchProvider.launchpacks[index].esigndocumentdata.formdefinitionid;
                                                                                  ESignEmbeddedResponse jsonData = await launchProvider.generateESignEmbeddedURL(docId, formdefinitionId);
                                                                                  if (jsonData.url.toString().isNotEmpty) {
                                                                                    launchProvider.viewIframe = true;
                                                                                  }
                                                                                },
                                                                                style: buttonStyleAmber,
                                                                                icon: Image.asset('assets/ontask.png'),
                                                                              ),
                                                                            )
                                                                          : const Text(
                                                                              ''),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                        title: Tooltip(
                                                          decoration:
                                                              tooltipdecorationGradient,
                                                          message:
                                                              launchProvider
                                                                  .launchpacks[
                                                                      index]
                                                                  .filename,
                                                          child: Text(
                                                              launchProvider
                                                                  .launchpacks[
                                                                      index]
                                                                  .fileextension),
                                                        ),
                                                        trailing: IconButton(
                                                            onPressed:
                                                                (() async {
                                                              Uri uri = Uri.parse(
                                                                  "$defaultActionItemPath${launchProvider.launchpacks[index].formcode}/${launchProvider.launchpacks[index].formcode}${launchProvider.launchpacks[index].fileextension}");
                                                              if (launchProvider
                                                                  .launchpacks[
                                                                      index]
                                                                  .fileextension
                                                                  .isNotEmpty) {
                                                                if (await canLaunchUrl(
                                                                    uri)) {
                                                                  await launchUrl(
                                                                      uri);
                                                                }
                                                              } else {
                                                                // Handle error when unable to launch the URL
                                                              }
                                                            }),
                                                            icon: launchProvider
                                                                    .launchpacks[
                                                                        index]
                                                                    .fileextension
                                                                    .isNotEmpty
                                                                ? const Icon(
                                                                    Icons
                                                                        .file_download,
                                                                    color: AppColors
                                                                        .green,
                                                                  )
                                                                : const Icon(
                                                                    Icons.block,
                                                                    color: Colors
                                                                        .transparent)),
                                                      ),
                                                    )),
                                                    DataCell(Center(
                                                      child: Checkbox(
                                                        value: launchProvider
                                                            .launchpacks[index]
                                                            .launchpack,
                                                        onChanged: (value) {
                                                          launchProvider
                                                                  .launchpacks[
                                                                      index]
                                                                  .launchpack =
                                                              value!;
                                                          ActionLaunchPack obj =
                                                              launchProvider
                                                                      .launchpacks[
                                                                  index];
                                                          launchProvider
                                                              .removeAndInsertLaunchPack(
                                                                  obj, index);
                                                        },
                                                      ),
                                                    )),
                                                    DataCell(Center(
                                                      child: Checkbox(
                                                        value: launchProvider
                                                            .launchpacks[index]
                                                            .renewalpack,
                                                        onChanged: (value) {
                                                          launchProvider
                                                                  .launchpacks[
                                                                      index]
                                                                  .renewalpack =
                                                              value!;
                                                          ActionLaunchPack obj =
                                                              launchProvider
                                                                      .launchpacks[
                                                                  index];
                                                          launchProvider
                                                              .removeAndInsertLaunchPack(
                                                                  obj, index);
                                                        },
                                                      ),
                                                    )),
                                                    DataCell(Center(
                                                      child: Checkbox(
                                                        value: launchProvider
                                                            .launchpacks[index]
                                                            .isprivate,
                                                        onChanged: (value) {
                                                          launchProvider
                                                                  .launchpacks[
                                                                      index]
                                                                  .isprivate =
                                                              value!;
                                                          ActionLaunchPack obj =
                                                              launchProvider
                                                                      .launchpacks[
                                                                  index];
                                                          launchProvider
                                                              .removeAndInsertLaunchPack(
                                                                  obj, index);
                                                        },
                                                      ),
                                                    )),
                                                    DataCell(Center(
                                                      child: DropdownButton<
                                                          LaunchStatus>(
                                                        value: launchProvider
                                                            .itemStatusList
                                                            .firstWhere((element) =>
                                                                element.code ==
                                                                launchProvider
                                                                    .launchpacks[
                                                                        index]
                                                                    .itemstatus),
                                                        onChanged: (newValue) {
                                                          launchProvider
                                                              .setItemStatus(
                                                                  index,
                                                                  newValue!);
                                                          // add your code to handle the value change here
                                                        },
                                                        items: launchProvider
                                                            .itemStatusList
                                                            .map((status) {
                                                          return DropdownMenuItem<
                                                              LaunchStatus>(
                                                            value: status,
                                                            child: Text(
                                                              status.name,
                                                              style: TextStyle(
                                                                  color: (status
                                                                              .code ==
                                                                          'archive')
                                                                      ? Colors
                                                                          .blue
                                                                      : (status.code ==
                                                                              'active')
                                                                          ? Colors
                                                                              .green
                                                                          : (status.code == 'inactive')
                                                                              ? Colors.red
                                                                              : Colors.black),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    )),
                                                    DataCell((launchProvider
                                                            .accountActionSaved(
                                                                index))
                                                        ? displaySpin()
                                                        : Center(
                                                            child: IconButton(
                                                              iconSize: 20,
                                                              onPressed: launchProvider
                                                                      .accountActionIndexSaved(
                                                                          index)
                                                                  ? null
                                                                  : () async {
                                                                      // Handle save button press
                                                                      try {
                                                                        if ((launchProvider.launchpacks[index].attachmenttype == 'esign' ||
                                                                                launchProvider.launchpacks[index].attachmenttype == 'file') &&
                                                                            launchProvider.launchpacks[index].fileextension.isEmpty) {
                                                                          EliteDialog(
                                                                              context,
                                                                              "Alert",
                                                                              "Please attach a document.",
                                                                              "Ok",
                                                                              "Cancel");
                                                                          return;
                                                                        }
                                                                        List<ActionLaunchPack>
                                                                            lists =
                                                                            [];
                                                                        lists.add(
                                                                            launchProvider.launchpacks[index]);
                                                                        launchProvider.selectedLaunchPacks =
                                                                            lists;

                                                                        var accountcode = loginProvider
                                                                            .logedinUser
                                                                            .accountcode;

                                                                        if (launchProvider
                                                                            .launchpacks[index]
                                                                            .formcode
                                                                            .isEmpty) {
                                                                          await launchProvider.saveLaunchPack(
                                                                              accountcode,
                                                                              '',
                                                                              index);
                                                                          launchProvider
                                                                              .launchpacks[index]
                                                                              .newAction = false;

                                                                          if (launchProvider
                                                                              .savedAccountAction!
                                                                              .accountcode
                                                                              .isNotEmpty) {
                                                                            // ignore: use_build_context_synchronously
                                                                            EliteDialog(
                                                                                context,
                                                                                "Success",
                                                                                "Data saved successfully!",
                                                                                "Ok",
                                                                                "Close");
                                                                          }
                                                                        }
                                                                        if (launchProvider
                                                                            .launchpacks[index]
                                                                            .formcode
                                                                            .isNotEmpty) {
                                                                          await launchProvider.updateLaunchPack(
                                                                              accountcode,
                                                                              '',
                                                                              index);
                                                                          if (launchProvider
                                                                              .savedAccountAction!
                                                                              .accountcode
                                                                              .isNotEmpty) {
                                                                            // ignore: use_build_context_synchronously
                                                                            EliteDialog(
                                                                                context,
                                                                                "Success",
                                                                                "Data updated successfully!",
                                                                                "Ok",
                                                                                "Close");
                                                                          }
                                                                        }

                                                                        launchProvider.setAccountActionIndexSaved(
                                                                            index,
                                                                            true);
                                                                        launchProvider.launchpacks[index].formcode = launchProvider
                                                                            .savedAccountAction!
                                                                            .formfileupload[0]
                                                                            .formcode;
                                                                      } catch (e) {
                                                                        launchProvider.setAccountActionIndexSaved(
                                                                            index,
                                                                            false);
                                                                      }
                                                                    },
                                                              style:
                                                                  buttonStyleAmber,
                                                              icon: Icon(
                                                                FontAwesomeIcons
                                                                    .floppyDisk,
                                                                color: launchProvider
                                                                        .accountActionIndexSaved(
                                                                            index)
                                                                    ? AppColors
                                                                        .iconGray
                                                                    : AppColors
                                                                        .blue,
                                                              ),
                                                            ),
                                                          )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(0, .9),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  width: 150,
                                                  child: ElevatedButton(
                                                    style: buttonStyleBlue,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .popAndPushNamed(
                                                              "/yourProfile");
                                                    },
                                                    child: const Text('Back'),
                                                  )),
                                              SizedBox(
                                                width: 150,
                                                child: ElevatedButton(
                                                  style: buttonStyleInvite,
                                                  child: const Text('Next'),
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .popAndPushNamed(
                                                            "/addOther");
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ]),
                    );
            }),
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
        ])));
  }
}
