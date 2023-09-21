import 'dart:js_interop';

import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FormPaymentMethod extends StatelessWidget {
  const FormPaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    SizeConfig().init(context);
    /*  final payProvider =
        Provider.of<PaymentMethodProvider>(context, listen: false); */
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      key: scaffoldKey,
      body: Background(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Expanded(
          flex: 2,
          child: SideMenu(
              // key: null, // Remove this line or provide an appropriate key if needed
              // currentGoogleAccount: loginProvider.currentGoogleUser!, // Uncomment and provide necessary data if needed
              ),
        ),
        Expanded(
          flex: 9,
          child: Form(
            key: formKey,
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
                      TextButton(
                        onPressed: (adminProvider
                                    .attachedpaymentmethod?.paymentmethoddata !=
                                null)
                            ? null
                            : () {
                                Uri uri =
                                    Uri.parse(adminProvider.setupintentUrl);
                                launchUrl(uri);
                              },
                        child: Tooltip(
                          textStyle: const TextStyle(
                              fontSize: 12, color: AppColors.black),
                          message:
                              'Only one payment method can be on file.\nPlease delete the current one if you would like to change the payment method.',
                          decoration: tooltipdecoration,
                          child: const Text(
                            '+ Add Payment Methods',
                            style:
                                appstyle, // You need to define appstyle or use a predefined style
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await adminProvider.readAttachedPaymentMethod(
                                lgnProvider.logedinUser.accountcode);
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.blue,
                          ))
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        /*  const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Your credit and debit cards',
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ), */
                        Consumer<AdminProvider>(
                            builder: (context, prvAdmin, child) {
                          return (prvAdmin.readingPaymentMethod ||
                                  prvAdmin.deletePaymentMethod)
                              ? displaySpin()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (prvAdmin.attachedpaymentmethod
                                                ?.paymentmethoddata !=
                                            null)
                                        ? DataTable(
                                            columnSpacing: 8.0,
                                            columns: [
                                              DataColumn(
                                                label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          6,
                                                  child: const Center(
                                                      child: Text('No')),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          6,
                                                  child: const Center(
                                                    child: Text('Name on card'),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          8,
                                                  child: const Center(
                                                      child:
                                                          Text('Expires on')),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          8,
                                                  child: const Center(
                                                      child: Text('')),
                                                ),
                                              ),
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                DataCell(Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Image.asset(
                                                          'assets/paymenticons/visa.png'),
                                                    ),
                                                    Center(
                                                      child: Image.asset(
                                                          'assets/paymenticons/mastercard.png'),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '${prvAdmin.attachedpaymentmethod?.paymentmethoddata?.card.brand ?? ''}****${prvAdmin.attachedpaymentmethod?.paymentmethoddata?.card.last4 ?? ''}',
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                DataCell(Center(
                                                  child: Text(
                                                    (prvAdmin
                                                            .attachedpaymentmethod!
                                                            .paymentmethoddata
                                                            .isNull)
                                                        ? ''
                                                        : prvAdmin
                                                            .attachedpaymentmethod!
                                                            .paymentmethoddata!
                                                            .billingDetails
                                                            .name,
                                                  ),
                                                )),
                                                DataCell(Center(
                                                  child: Text(
                                                    prvAdmin.attachedpaymentmethod !=
                                                            null
                                                        ? '${prvAdmin.attachedpaymentmethod!.paymentmethoddata?.card.expMonth}/${prvAdmin.attachedpaymentmethod!.paymentmethoddata?.card.expYear}'
                                                        : '',
                                                  ),
                                                )),
                                                DataCell(
                                                  Center(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        try {
                                                          var result =
                                                              await EliteDialog(
                                                            context,
                                                            'Please confirm!',
                                                            'Are you sure to delete?',
                                                            'Yes',
                                                            'No',
                                                          );
                                                          if (result) {
                                                            await prvAdmin
                                                                .deleteAttachedPaymentMethod(
                                                              lgnProvider
                                                                  .logedinUser
                                                                  .accountcode,
                                                              adminProvider
                                                                  .attachedpaymentmethod!
                                                                  .paymentmethoddata
                                                                  ?.id,
                                                            );
                                                          }
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: AppColors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          )
                                        : const Text(
                                            'No payment method registered')
                                  ],
                                );
                        }),
                        /*   Consumer<PaymentMethodProvider>(
                            builder: (context, prvMethod, child) {
                          return prvMethod.selectedMethod == 'Card'
                              ? const CardEntry()
                              : const BankAccountEntry();
                        }) */
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      ])),
    );
  }
}
