import 'package:advisorapp/checkout/checkoutwidget.dart';
import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_profileviewer.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/models/status.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySubscription extends StatelessWidget {
  const MySubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    SizeConfig().init(context);
    // double screenWidth = SizeConfig.screenWidth / 4;
    final prvMaster = Provider.of<MasterProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    adminProvider.readSubscriptionLicense(lgnProvider.logedinUser.accountcode);
    return Scaffold(
        key: scaffoldKey,
        body: Background(
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
                child: Form(
                    key: formKey,
                    child: SizedBox(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 30),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        //adminProvider.initSubscription = true;
                                      },
                                      child: const Text(
                                        'Your License Status',
                                        style: appstyle,
                                      )),
                                  /* Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: ElevatedButton(
                                        style: buttonStyleBlue,
                                        onPressed: () async {
                                          var result = await EliteDialog(
                                              context,
                                              'Please Confirm',
                                              'Do yu really want to proceed?',
                                              'Yes',
                                              'No');
                                          if (result) {
                                            int expiredLicenseCount =
                                                adminProvider
                                                    .subscriptionLicenses
                                                    .where((license) =>
                                                        (license.licensestatus ==
                                                            'Expired') &&
                                                        license.accountstatus
                                                                .toUpperCase() ==
                                                            'ACTIVE')
                                                    .length;
                                            if (expiredLicenseCount <= 0) {
                                              showSnackBar(context,
                                                  'All licenses are active!');
                                              return;
                                            }

                                            await adminProvider
                                                .createCheckOutSession(
                                                    expiredLicenseCount,
                                                    lgnProvider.logedinUser
                                                        .accountcode,
                                                    'SU-20230731121000260');
                                            adminProvider.initSubscription =
                                                true;
                                          }
                                        },
                                        child: const Text(
                                          'Purchase',
                                          style: sideMenuStyle,
                                        )),
                                  ) */
                                ],
                              ),
                              Consumer<AdminProvider>(
                                  builder: (context, prvNew, child) {
                                return prvNew.initSubscription
                                    ? CheckOutWidget(
                                        htmlContent: prvNew.checkoutsession,
                                      ) //const SubscriptionForm()
                                    : IconButton(
                                        onPressed: () {
                                          adminProvider.readSubscriptionLicense(
                                              lgnProvider
                                                  .logedinUser.accountcode);
                                        },
                                        icon: const Icon(
                                          Icons.refresh,
                                          color: AppColors.blue,
                                        ));
                              }),
                              SizedBox(
                                width: SizeConfig.blockSizeVertical,
                              ),
                              Consumer<AdminProvider>(
                                  builder: (context, prvAdmin, child) {
                                return (prvAdmin.readingLicense == true &&
                                        prvAdmin.initSubscription == false)
                                    ? displaySpin()
                                    : (prvAdmin.readingLicense == false &&
                                            prvAdmin.initSubscription == false)
                                        ? SingleChildScrollView(
                                            child: DataTable(
                                                columnSpacing: 15,
                                                columns: [
                                                /*  DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          10,
                                                  child: const Text(
                                                      'Account Owner'),
                                                )), */
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          12,
                                                  child: const Text('User'),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          8,
                                                  child: const Text(
                                                      'Account Role'),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          10,
                                                  child: const Text(
                                                      'Subscription Fee'),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          10,
                                                  child: const Text(
                                                      'Next Autopay Date'),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          10,
                                                  child: const Text(
                                                      'License Status'),
                                                )),
                                                DataColumn(
                                                    label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          10,
                                                  child:
                                                      const Text('User Status'),
                                                ))
                                              ],
                                                rows: [
                                                for (var i = 0;
                                                    i <
                                                        prvAdmin
                                                            .subscriptionLicenses
                                                            .length;
                                                    i++)
                                                  DataRow.byIndex(
                                                      index: i,
                                                      cells: [
                                                        /* DataCell(
                                                          Row(
                                                            children: [
                                                              CustomProfileViewer(
                                                                  account: prvAdmin
                                                                      .subscriptionLicenses[
                                                                          i]
                                                                      .accountownerdata),
                                                            ],
                                                          ),
                                                        ), */
                                                        DataCell(
                                                          Row(
                                                            children: [
                                                              CustomProfileViewer(
                                                                  account: prvAdmin
                                                                      .subscriptionLicenses[
                                                                          i]
                                                                      .accountdata),
                                                            ],
                                                          ),
                                                        ),
                                                        DataCell(DropdownButton<
                                                            Role>(
                                                          value: (prvAdmin
                                                                      .subscriptionLicenses[
                                                                          i]
                                                                      .accountrole ==
                                                                  null)
                                                              ? prvMaster
                                                                  .accountroles
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .rolecode ==
                                                                      prvAdmin
                                                                          .subscriptionLicenses[
                                                                              i]
                                                                          .accountdata
                                                                          .accountrole)
                                                              : prvAdmin
                                                                  .subscriptionLicenses[
                                                                      i]
                                                                  .accountrole,
                                                          onChanged: (Role?
                                                              newValue) async {
                                                            bool result =
                                                                await EliteDialog(
                                                                    context,
                                                                    'Please confirm',
                                                                    'Are you sure to update Account role of user?',
                                                                    'Yes',
                                                                    'No');
                                                            if (result) {
                                                              prvAdmin
                                                                  .setAccountRole(
                                                                      i,
                                                                      newValue!);
                                                              prvAdmin.updateRole(
                                                                  prvAdmin
                                                                      .subscriptionLicenses[
                                                                          i]
                                                                      .accountcode,
                                                                  newValue
                                                                      .rolecode);
                                                            }
                                                          },
                                                          items: prvMaster
                                                              .accountroles
                                                              .map((Role obj) {
                                                                return DropdownMenuItem<
                                                                    Role>(
                                                                  value: obj,
                                                                  child: Text(obj
                                                                      .rolename),
                                                                );
                                                              })
                                                              .toSet()
                                                              .toList(),
                                                        )),
                                                        const DataCell(
                                                          Text(
                                                            "\$99 per month",
                                                            style: appstyle,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            (prvAdmin
                                                                .subscriptionLicenses[
                                                                    i]
                                                                .nextrechargedate),
                                                            style: appstyle,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            prvAdmin
                                                                .subscriptionLicenses[
                                                                    i]
                                                                .licensestatus,
                                                            style: TextStyle(
                                                                color: (prvAdmin
                                                                            .subscriptionLicenses[
                                                                                i]
                                                                            .licensestatus ==
                                                                        'Active')
                                                                    ? AppColors
                                                                        .green
                                                                    : AppColors
                                                                        .red),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          DropdownButton<
                                                              Status>(
                                                            value: prvAdmin
                                                                .statusList
                                                                .firstWhere((e) =>
                                                                    e.code ==
                                                                    prvAdmin
                                                                        .subscriptionLicenses[
                                                                            i]
                                                                        .accountstatus),
                                                            onChanged:
                                                                (newValue) async {
                                                              bool result = await EliteDialog(
                                                                  context,
                                                                  'Please confirm',
                                                                  (newValue!.code ==
                                                                          'inactive')
                                                                      ? 'Would you like to terminate this user?.'
                                                                      : 'If a user is marked as Active, that user will have complete access to the advior platform.\nAll Active users will incur fees for billing purposes. Please confirm.?',
                                                                  'Yes',
                                                                  'No');

                                                              if (result) {
                                                                prvAdmin
                                                                    .setStatus(
                                                                        i,
                                                                        newValue);

                                                                prvAdmin.updateStatus(
                                                                    prvAdmin
                                                                        .subscriptionLicenses[
                                                                            i]
                                                                        .accountcode,
                                                                    newValue
                                                                        .code);
                                                              }
                                                              // add your code to handle the value change here
                                                            },
                                                            items: prvAdmin
                                                                .statusList
                                                                .map((status) {
                                                              return DropdownMenuItem<
                                                                  Status>(
                                                                value: status,
                                                                child: Text(
                                                                  status.name,
                                                                  style: TextStyle(
                                                                      color: (status.code ==
                                                                              'active')
                                                                          ? AppColors
                                                                              .green
                                                                          : AppColors
                                                                              .red),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        /* DataCell(
                                                          (prvAdmin
                                                                      .subscriptionLicenses[
                                                                          i]
                                                                      .licensestatus ==
                                                                  'Expired')
                                                              ? ElevatedButton(
                                                                  style:
                                                                      buttonStyleBlue,
                                                                  onPressed:
                                                                      () async {
                                                                    await adminProvider.createCheckOutSession(
                                                                        adminProvider
                                                                            .subscriptionLicenses[
                                                                                i]
                                                                            .accountcode,
                                                                        lgnProvider
                                                                            .logedinUser
                                                                            .accountcode,
                                                                        'SU-20230731121000260');
                                                                    adminProvider
                                                                            .initSubscription =
                                                                        true;
                                                                  },
                                                                  child: const Text(
                                                                      "Recharge"))
                                                              : ElevatedButton(
                                                                  style:
                                                                      buttonStyleGreen,
                                                                  onPressed:
                                                                      () {},
                                                                  child: const Text(
                                                                      "Active")),
                                                        ), */
                                                      ])
                                              ]))
                                        : const Text('');
                              })
                            ]),
                      ),
                    )),
              ),
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
        ));
  }
}
