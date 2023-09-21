// ignore_for_file: file_names

import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/service/httpservice.dart';

import 'package:advisorapp/style/colors.dart';
import 'package:advisorapp/style/style.dart';
import 'package:flutter/material.dart';

class ActionItemTable extends StatefulWidget {
  final List<dynamic> actionitems;
  const ActionItemTable({Key? key, required this.actionitems})
      : super(key: key);

  @override
  State<ActionItemTable> createState() => _ActionItemTableState();
}

class _ActionItemTableState extends State<ActionItemTable> {
  final Map<String, String> _formstatusarray = {
    '': '',
    'NotSend': 'Not Send',
    'Pending': 'Pending',
    'InProgress': 'InProgress',
    'Complete': 'Complete',
  };
  late String formstatus = '';
  late String loggedinAccountCode = '';
  late bool isInitiater = false;

  @override
  void initState() {
    formstatus = 'Pending';
    getLoggedInUser();
    super.initState();
  }

  getLoggedInUser() async {
    await HttpService().getLoggedInAccountCode().then((value) => {
          loggedinAccountCode = value!,
          if (loggedinAccountCode.split('-')[0] == 'AC') {isInitiater = true}
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection:
          Responsive.isDesktop(context) ? Axis.vertical : Axis.horizontal,
      child: SizedBox(
          width: Responsive.isDesktop(context)
              ? double.infinity
              : SizeConfig.screenWidth,
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(3),
              4: FlexColumnWidth(3),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(
                  color: AppColors.iconGray,
                ),
                children: [
                  TableCell(
                    child: Text(
                      'For Employer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'From',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'To',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'Form Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...List.generate(
                widget.actionitems.length,
                (index) => TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    PrimaryText(
                      text: widget.actionitems[index]["employerlegalname"]
                          .toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.light,
                    ),
                    PrimaryText(
                      text: widget.actionitems[index]["partneraccountleadname"]
                          .toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.iconGray,
                    ),
                    PrimaryText(
                      text: widget.actionitems[index]["employercontactemail"]
                          .toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.iconGray,
                    ),
                    PrimaryText(
                      text: widget.actionitems[index]["formname"].toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.iconGray,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        widget.actionitems[index]["formstatus"].toString(),
                        style: TextStyle(
                            color: getFormStatusColor(widget.actionitems[index]
                                    ["formstatus"]
                                .toString())),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: InkWell(
                        onDoubleTap: () {
                          dialogBuilder(context, widget.actionitems[index]);
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: AppColors.light),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Color getFormStatusColor(value) {
    if (value == 'Pending') {
      return Colors.red;
    } else if (value == 'Complete') {
      return Colors.green;
    } else if (value == 'InProgress') {
      return Colors.amber;
    }
    return Colors.red;
  }

  dialogBuilder(BuildContext context, dynamic actionitem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Status"),
          content: SingleChildScrollView(
            child: Form(
              child: SizedBox(
                width: SizeConfig.screenWidth / 3,
                height: (SizeConfig.screenHeight) / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    PrimaryText(
                      text: actionitem["launchcode"].toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.light,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryText(
                      text: actionitem["employerlegalname"].toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.light,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryText(
                      text: actionitem["formname"].toString(),
                      size: 14,
                      fontWeight: FontWeight.w200,
                      color: AppColors.light,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 200,
                        child: DropdownButton<String>(
                          hint: const Text('Select Form Status'),
                          value: actionitem["formstatus"],
                          items: _formstatusarray.keys
                              .map<DropdownMenuItem<String>>((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(
                                _formstatusarray[key]!,
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'Poppins'),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              actionitem["formstatus"] = newValue!;
                            });
                            HttpService().updateActionItemFormStatus(
                                actionitem["launchcode"], newValue);
                            Navigator.of(context).pop();
                          },
                        ))
                  ],
                ),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 24.0, right: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  DropdownButton formStatusControl() {
    return DropdownButton<String>(
      hint: const Text('Select Form Status'),
      value: formstatus,
      items: _formstatusarray.keys.map<DropdownMenuItem<String>>((String key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(
            _formstatusarray[key]!,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          formstatus = newValue!;
        });
      },
    );
  }
}
