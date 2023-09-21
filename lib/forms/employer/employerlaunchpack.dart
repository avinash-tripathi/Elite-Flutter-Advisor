import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/forms/accountform/groupconversation.dart';
import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/employerassistant.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/launchstatus.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/employer.dart';

class EmployerLaunchPack extends StatefulWidget {
  final Employer selectedEmployer;
  const EmployerLaunchPack({Key? key, required this.selectedEmployer})
      : super(key: key);

  @override
  State<EmployerLaunchPack> createState() => _EmployerLaunchPackState();
}

class _EmployerLaunchPackState extends State<EmployerLaunchPack> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              //resetForm();
                              //dialogBuilder(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
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
                            )),
                        const Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: SizeConfig.screenWidth / 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(Icons.play_arrow),
                                    ),
                                    Text(
                                      widget.selectedEmployer.companyname,
                                      style: appstyle,
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  style:
                                      (widget.selectedEmployer.launchstatus ==
                                              'SENTLAUNCHPACK')
                                          ? buttonStyleGreen
                                          : buttonStyleInvite,
                                  onPressed: (prvEmployer.updatelaunchstatus &&
                                          widget.selectedEmployer
                                                  .launchstatus !=
                                              'SENTLAUNCHPACK')
                                      ? null
                                      : () async {
                                          Employer obj =
                                              widget.selectedEmployer;

                                          await prvEmployer
                                              .updateLaunchStatus(
                                                  obj.accountcode,
                                                  obj.employercode,
                                                  "SENTLAUNCHPACK")
                                              .then((value) async {
                                            widget.selectedEmployer
                                                    .launchstatus =
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
                                      : Text(
                                          (widget.selectedEmployer
                                                      .launchstatus ==
                                                  'SENTLAUNCHPACK')
                                              ? "${365 - DateTime.now().difference(DateTime.parse(widget.selectedEmployer.planeffectivedate)).inDays} Days to go"
                                              : 'SEND LAUNCH PACK',
                                          style: TextStyle(
                                              color: (widget.selectedEmployer
                                                          .launchstatus ==
                                                      'SENTLAUNCHPACK')
                                                  ? Colors.white
                                                  : AppColors.red),
                                        ))
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
                                                return SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: DataTable(
                                                      columnSpacing: 8.0,
                                                      columns: const [
                                                        DataColumn(
                                                            label: SizedBox(
                                                          width: 100.0,
                                                          child: Center(
                                                              child:
                                                                  Text('From')),
                                                        )),
                                                        DataColumn(
                                                            label: SizedBox(
                                                          width: 100.0,
                                                          child: Center(
                                                              child:
                                                                  Text('To')),
                                                        )),
                                                        DataColumn(
                                                            label: SizedBox(
                                                          width: 230.0,
                                                          child: Center(
                                                              child: Text(
                                                                  'Action Item')),
                                                        )),
                                                        DataColumn(
                                                            label: SizedBox(
                                                          width: 110.0,
                                                          child: Center(
                                                              child: Text(
                                                                  'Due Date')),
                                                        )),
                                                        DataColumn(
                                                            label: SizedBox(
                                                          width: 100.0,
                                                          child: Center(
                                                              child: Text(
                                                                  'Status')),
                                                        )),
                                                        /*  DataColumn(
                                                            label: SizedBox(
                                                          width: 100.0,
                                                          child: Center(
                                                              child: Text(
                                                                  'Action')),
                                                        )), */
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
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    prvDis
                                                                        .launchpacks[
                                                                            i]
                                                                        .fromname,
                                                                  )),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Text(prvDis
                                                                        .launchpacks[
                                                                            i]
                                                                        .toname),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Text(prvDis
                                                                        .launchpacks[
                                                                            i]
                                                                        .formname),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Row(
                                                                      children: [
                                                                        Consumer<EmployerProvider>(builder: (context,
                                                                            prvEDate,
                                                                            child) {
                                                                          return Text(
                                                                            DateFormat('dd-MMM-yyyy').format(DateTime.parse(prvEDate.launchpacks[i].duedate)),
                                                                          );
                                                                        }),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
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

                                                                                  /*   prvEmployer.updateLaunchFormStatus(
                                                                              prvEmployer.launchpacks[i].accountcode,
                                                                              prvEmployer.launchpacks[i].employercode,
                                                                              prvEmployer.launchpacks[i].formcode,
                                                                              prvEmployer.launchpacks[i].formstatus,
                                                                              prvEmployer.launchpacks[i].duedate); */
                                                                                }
                                                                              });
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.date_range,
                                                                              color: AppColors.blue,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Consumer<
                                                                            EmployerProvider>(
                                                                        builder: (context,
                                                                            prvLS,
                                                                            child) {
                                                                      return DropdownButton<
                                                                          LaunchStatus>(
                                                                        value: prvLS.launchStatusList.firstWhere(
                                                                            (element) =>
                                                                                element.code ==
                                                                                prvDis.launchpacks[i].formstatus,
                                                                            orElse: () => prvLS.launchStatusList[0]),
                                                                        onChanged:
                                                                            (newValue) async {
                                                                          // add your code to handle the value change here
                                                                          bool result = await EliteDialog(
                                                                              context,
                                                                              'Please confirm',
                                                                              'Do you want to save the changes?',
                                                                              'Yes',
                                                                              'No');
                                                                          if (result) {
                                                                            prvLS.setLaunchStatus(i,
                                                                                newValue!);
                                                                            prvEmployer.updateLaunchFormStatus(
                                                                                prvEmployer.launchpacks[i].accountcode,
                                                                                prvEmployer.launchpacks[i].employercode,
                                                                                prvEmployer.launchpacks[i].formcode,
                                                                                prvEmployer.launchpacks[i].formstatus,
                                                                                prvEmployer.launchpacks[i].duedate);
                                                                          }
                                                                        },
                                                                        items: prvDis
                                                                            .launchStatusList
                                                                            .map((status) {
                                                                          return DropdownMenuItem<
                                                                              LaunchStatus>(
                                                                            value:
                                                                                status,
                                                                            child:
                                                                                Text(
                                                                              status.name,
                                                                              style: getColoredTextStyle(status.code),
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                      );
                                                                    }),
                                                                  ),
                                                                ),
                                                                /* DataCell(
                                                                  Center(child: Consumer<
                                                                          EmployerProvider>(
                                                                      builder: (context,
                                                                          prvE,
                                                                          child) {
                                                                    return prvE.isLaunchFormSaving(
                                                                            i)
                                                                        ? ElevatedButton(
                                                                            onPressed:
                                                                                null,
                                                                            child:
                                                                                displaySpin())
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () async {
                                                                              try {
                                                                                prvE.setLaunchFormSavingStatus(i, true);
                                                                                await prvE.updateLaunchFormStatus(prvDis.launchpacks[i].accountcode, prvDis.launchpacks[i].employercode, prvDis.launchpacks[i].formcode, prvDis.launchpacks[i].formstatus, prvDis.launchpacks[i].duedate);
                                                                                prvE.setLaunchFormSavingStatus(i, false);
                                                                              } catch (e) {
                                                                                prvE.setLaunchFormSavingStatus(i, false);
                                                                              }
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.save,
                                                                              color: AppColors.blue,
                                                                            ));
                                                                  })),
                                                                ), */
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
                                                    columns: const [
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 120.0,
                                                            child: Center(
                                                                child: Text(
                                                                    'From')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 120.0,
                                                            child: Center(
                                                                child:
                                                                    Text('To')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 120.0,
                                                            child: Center(
                                                                child: Text(
                                                                    'Item')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 85.0,
                                                            child: Center(
                                                                child: Text(
                                                                    'Attachment')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 120.0,
                                                            child: Center(
                                                                child: Text(
                                                                    'Due Date')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 90.0,
                                                            child: Center(
                                                                child: Text(
                                                                    'Private')),
                                                          ),
                                                          numeric: true),
                                                      DataColumn(
                                                          label: SizedBox(
                                                            width: 60.0,
                                                            child: Center(
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
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value
                                                                              .account
                                                                              .accountname
                                                                              .trim(),
                                                                          style:
                                                                              const TextStyle(fontSize: 12)),
                                                                    );
                                                                  })
                                                                  .toSet()
                                                                  .toList(),
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
                                                                            value.account.accountname
                                                                                .trim(),
                                                                            style:
                                                                                const TextStyle(fontSize: 12)),
                                                                      );
                                                                    })
                                                                    .toSet()
                                                                    .toList(),
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
                                                              leading:
                                                                  IconButton(
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
                                                                            prvNew.actionlaunchpacks[i];

                                                                        await prvNew.pickFile(
                                                                            obj,
                                                                            i);
                                                                      },
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
                                                                          ? DateFormat('dd-MMM-yyyy').format(DateTime
                                                                              .now())
                                                                          : DateFormat('dd-MMM-yyyy').format(prvNew
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
                                                            /* Center(
                                                              child:
                                                                  TextFormField(
                                                                readOnly: true,
                                                                onTap:
                                                                    () async {
                                                                  prvNew.assistDueDate =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        prvNew
                                                                            .assistDueDate!,
                                                                    firstDate:
                                                                        DateTime(
                                                                            1900),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100),
                                                                  );
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: (prvNew
                                                                              .assistDueDate ==
                                                                          null)
                                                                      ? DateFormat(
                                                                              'dd-MMM-yyyy')
                                                                          .format(DateTime
                                                                              .now())
                                                                      : DateFormat(
                                                                              'dd-MMM-yyyy')
                                                                          .format(
                                                                              prvNew.assistDueDate!),
                                                                ),
                                                              ),
                                                            ), */
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: Tooltip(
                                                                message: prvNew
                                                                        .selectedVisibilityStatus
                                                                    ? 'If you uncheck Private, then the item will be visible to other users within your company'
                                                                    : 'Private items will be visible only to the Sender and Receiver within your company',
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
                                                                        ActionLaunchPack
                                                                            obj =
                                                                            ActionLaunchPack(
                                                                          filebase64: prvNew
                                                                              .actionlaunchpacks[i]
                                                                              .filebase64,
                                                                          fileextension: prvNew
                                                                              .actionlaunchpacks[i]
                                                                              .fileextension,
                                                                          formcode:
                                                                              '',
                                                                          formname: prvNew
                                                                              .actionlaunchpacks[i]
                                                                              .formname,
                                                                          launchpack:
                                                                              false,
                                                                          renewalpack:
                                                                              false,
                                                                          filename: prvNew
                                                                              .actionlaunchpacks[i]
                                                                              .filename,
                                                                        );
                                                                        lists.add(
                                                                            obj);

                                                                        AccountAction objAct = AccountAction(
                                                                            accountcode:
                                                                                /*  prvEmployer
                                                                            .selectedToAssist!
                                                                            .code */
                                                                                widget.selectedEmployer.accountcode,
                                                                            employercode: widget.selectedEmployer.employercode,
                                                                            formfileupload: lists);

                                                                        await prvNew
                                                                            .saveActionLaunchPack(objAct,
                                                                                i)
                                                                            .then((value) {
                                                                          //write code to insert directly in launchpack for this employer only.
                                                                          ActionLaunchPack
                                                                              objNewAdded =
                                                                              prvNew.actionlaunchpacks[i];
                                                                          LaunchPack
                                                                              obj =
                                                                              LaunchPack();
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
                                                                          obj.accountcode = widget
                                                                              .selectedEmployer
                                                                              .accountcode;
                                                                          obj.employercode = widget
                                                                              .selectedEmployer
                                                                              .employercode;
                                                                          obj.launchcode = prvNew
                                                                              .launchpacks[0]
                                                                              .launchcode;
                                                                          obj.duedate =
                                                                              DateFormat('yyyy-MM-dd').format(prvEmployer.assistDueDate!);
                                                                          obj.formstatus =
                                                                              'InProgress';
                                                                          obj.visibility = (prvNew.selectedVisibilityStatus)
                                                                              ? 'private'
                                                                              : 'public';

                                                                          prvNew
                                                                              .insertLaunchPackForEmployer(obj)
                                                                              .then((value) {
                                                                            //remove actionitem from list and clear the array.
                                                                            prvNew.clearActionLaunchPack();
                                                                            prvNew.getInitialLaunchPack(
                                                                                widget.selectedEmployer.accountcode,
                                                                                widget.selectedEmployer.employercode,
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
                                      ),
                                    ]),
                              )
                      ],
                    ))),
          ),
          if (Responsive.isDesktop(context))
            Expanded(
              flex: 3,
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
                        GroupConversation(),
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
