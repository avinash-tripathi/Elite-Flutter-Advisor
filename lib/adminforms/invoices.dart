import 'package:advisorapp/adminforms/paymentmethods/forminvoice.dart';
import 'package:advisorapp/adminforms/paymentmethods/frmpdfpreview.dart';
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

class FormInvoices extends StatelessWidget {
  const FormInvoices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    SizeConfig().init(context);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    adminProvider.readInvoices(lgnProvider.logedinUser.accountcode);

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
                      Consumer<AdminProvider>(
                          builder: (context, prvPayment, child) {
                        return TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Invoices',
                            style:
                                appstyle, // You need to define appstyle or use a predefined style
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth / 2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const FormInvoice(),
                          Consumer<AdminProvider>(
                              builder: (context, prvPdf, child) {
                            return prvPdf.clickedTodownload
                                ? const FrmPdfPreview()
                                : const Text('');
                          })
                        ],
                      ),
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
