// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/custom/custom_logoviewerpartner.dart';
import 'package:advisorapp/custom/custom_tooltippartner.dart';
import 'package:advisorapp/forms/partner/partnerentry.dart';
import 'package:advisorapp/forms/partner/sl_partnerentry.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/partner.dart';
import '../../component/sidemenu.dart';

class PartnerForm extends StatelessWidget {
  PartnerForm({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final partnerProvider =
        Provider.of<PartnerProvider>(context, listen: false);
    //final lProvider = Provider.of<LoginProvider>(context, listen: false);
    final mProvider = Provider.of<MasterProvider>(context, listen: false);
    //partnerProvider.getPartnerAddedByAccount(lProvider.logedinUser.accountcode);
    return Scaffold(
      key: _scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox(),
      ),
      body: Background(
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
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            partnerProvider.addNew = true;
                            partnerProvider.edit = false;
                            partnerProvider.selectedPartner = Partner();
                            partnerProvider.partnerdomainnameController.clear();
                            partnerProvider.accountLeadEmailController.clear();
                            partnerProvider.salesLeadEmailController.clear();
                            partnerProvider.contractSignatoryEmailController
                                .clear();
                            partnerProvider.selectedPartnerCompanyCategory =
                                mProvider.companycategories.firstWhere(
                                    (e) => e.categorycode == 'select');
                            partnerProvider.clearInvitation();
                            //resetForm();
                          },
                          child: const Text(
                            '+ Add a new Partner',
                            style: appstyle,
                          )),
                      // const Divider(color: Colors.grey),
                      Consumer<PartnerProvider>(
                          builder: (context, prvMode, child) {
                        return (prvMode.addNew || prvMode.edit)
                            ? const SLPartnerEntry() // PartnerEntry() // dataEntryForm()
                            : const Text('');
                      }),
                      Consumer<PartnerProvider>(
                          builder: (context, prvRead, child) {
                        return prvRead.readingAccPartner
                            ? displaySpin()
                            : SizedBox(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: prvRead.partners.length,
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                prvRead.edit = true;
                                                prvRead.addNew = false;
                                                prvRead.selectedPartner =
                                                    prvRead.partners[index];

                                                final prvMaster =
                                                    Provider.of<MasterProvider>(
                                                        context,
                                                        listen: false);
                                                try {
                                                  var objCategory = prvMaster
                                                      .companycategories
                                                      .firstWhere((element) =>
                                                          element
                                                              .categorycode ==
                                                          prvRead
                                                              .partners[index]
                                                              .companycategory);

                                                  prvRead.selectedPartnerCompanyCategory =
                                                      (objCategory.categorycode
                                                              .isEmpty)
                                                          ? prvMaster
                                                              .companycategories[0]
                                                          : objCategory;
                                                } on StateError catch (e) {
                                                  prvRead.selectedPartnerCompanyCategory =
                                                      prvMaster
                                                          .companycategories[0];
                                                }
                                              },
                                              child: CustomLogoViewerPartner(
                                                partner:
                                                    prvRead.partners[index],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TooltipWithCopy(
                                                  partner: partnerProvider
                                                      .partners[index]),
                                            ),
                                          ]),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 2,
                                      ),
                                    ]);
                                  },
                                ),
                              );
                      })

                      /* SizedBox(
                          width: SizeConfig.screenWidth,
                          child: FutureBuilder(
                              future: pProvider.getPartnerAddedByAccount(
                                  lProvider.logedinUser.accountcode),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return displaySpin();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              pProvider.partners.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          pProvider.edit = true;
                                                          pProvider.addNew =
                                                              false;
                                                          pProvider
                                                                  .selectedPartner =
                                                              pProvider
                                                                      .partners[
                                                                  index];

                                                          final prvMaster = Provider
                                                              .of<MasterProvider>(
                                                                  context,
                                                                  listen:
                                                                      false);
                                                          try {
                                                            var objCategory = prvMaster
                                                                .companycategories
                                                                .firstWhere((element) =>
                                                                    element
                                                                        .categorycode ==
                                                                    pProvider
                                                                        .partners[
                                                                            index]
                                                                        .companycategory);

                                                            pProvider
                                                                .selectedPartnerCompanyCategory = (objCategory
                                                                    .categorycode
                                                                    .isEmpty)
                                                                ? prvMaster
                                                                    .companycategories[0]
                                                                : objCategory;
                                                          } on StateError catch (e) {
                                                            // Handle the exception
                                                            pProvider
                                                                    .selectedPartnerCompanyCategory =
                                                                prvMaster
                                                                    .companycategories[0];
                                                          }
                                                        },
                                                        child:
                                                            CustomLogoViewerPartner(
                                                          partner: pProvider
                                                                  .partners[
                                                              index],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                         
                                                            TooltipWithCopy(
                                                                partner: pProvider
                                                                        .partners[
                                                                    index]),
                                                      )
                                                    ]),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      2,
                                                ),
                                              ],
                                            );
                                          }),
                                    ],
                                  );
                                }
                              }))
                               */
                    ],
                  ),
                )),
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
      ),
    );
  }

  /*  String? validateInput(String value) {
    if (value.isEmpty) {
      return 'Please Enter Company Domain Name.';
    }
    return null;
  } */
}
