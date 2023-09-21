// ignore_for_file: file_names

//import 'package:advisorapp/component/paymentListTile.dart';

import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';

import 'package:advisorapp/models/activeworkspace.dart';

import 'package:advisorapp/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkSpaceList extends StatefulWidget {
  final List<ActiveWorkSpace> workspacelist;
  final Function(ActiveWorkSpace) onWorkSpaceSelected;

  const WorkSpaceList(
      {Key? key,
      required this.workspacelist,
      required this.onWorkSpaceSelected})
      : super(key: key);
  @override
  State<WorkSpaceList> createState() => _WorkSpaceListState();
}

class _WorkSpaceListState extends State<WorkSpaceList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.only(left: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SvgPicture.asset('assets/alicornName.svg'),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 40, child: SvgPicture.asset('assets/workspace.svg')),
          const PrimaryText(
              text: 'Workspaces', size: 22, fontWeight: FontWeight.w800),
        ],
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 2,
      ),
      Column(
        children: List.generate(
          widget.workspacelist.length,
          (index) => InkWell(
              onDoubleTap: () {
                widget.onWorkSpaceSelected(widget.workspacelist[index]);
              },
              child: ListTile(
                leading: const Icon(Icons.donut_small_rounded),
                title: Text(
                  widget.workspacelist[index].employerlegalname,
                  style: appstyle,
                ),
              )
              /* PaymentListTile(
                icon: 'assets/drop.svg',
                label: widget.workspacelist[index].employerlegalname,
                amount: ''), */
              ),
        ),
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
    ]);
  }
}
