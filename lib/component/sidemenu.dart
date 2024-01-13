// ignore_for_file: unused_import, prefer_const_constructors

import 'dart:js_interop';

import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/Login/login_screen.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/admin/setupIntent/inputsetupintent.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/idea_provider.dart';
import 'package:advisorapp/providers/launch_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/microsoftAuth_Provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/providers/paymentmethod_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../config/size_config.dart';
import '../style/colors.dart';

class SideMenu extends StatelessWidget {
  // final GoogleSignInAccount currentGoogleAccount;
  const SideMenu({
    Key? key,
    // required this.currentGoogleAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sideProvider = Provider.of<SidebarProvider>(context, listen: false);

    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    final bool issuperadmin = adminProv.adminusers
        .any((user) => user.emailid == lgnProvider.logedinUser.workemail);

    final mstProvider = Provider.of<MasterProvider>(context, listen: false);
    CompanyCategory objCate = mstProvider.companycategories[0];
    if (mstProvider.companycategories.isNotEmpty &&
        lgnProvider.logedinUser.companycategory.isNotEmpty) {
      objCate = mstProvider.companycategories.firstWhere((element) =>
          element.categorycode == lgnProvider.logedinUser.companycategory);
    }

    String paymentcode = '';
    paymentcode = lgnProvider.logedinUser.accountpaymentinfo;
    /*  bool restricttoAccount =
        (paymentcode == 'PC-20230423165346513') ? true : false; */
    bool restricttoAccount =
        (paymentcode == 'PC-20230423165346513') ? false : false;

    bool validLicense = lgnProvider.logedinUser.validlicense;
    bool validPaymentMethod = lgnProvider.logedinUser.validpaymentmethodexist;
    if (objCate.categoryname == 'Employer') {
      validPaymentMethod = true;
      validLicense = true;
    }
    bool isAccountOwner =
        (lgnProvider.logedinUser.accountrole == 'RL-20230224175000800');

    adminProv.readAttachedPaymentMethod(lgnProvider.logedinUser.accountcode);

    return SizedBox(
      width: SizeConfig.screenWidth / 7,
      child: Container(
        width: SizeConfig.screenWidth / 7,
        height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(
            color: AppColors.sidemenu,
            border: Border(right: BorderSide(color: AppColors.sidemenu))),
        child:
            Consumer<SidebarProvider>(builder: (context, menuProvider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 20,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [],
                    ),
                  ),
                  Visibility(
                    visible: ((restricttoAccount == false) && !issuperadmin),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (menuProvider.selectedMenu == 'Home')
                              ? const Color.fromARGB(255, 234, 231, 231)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: SvgPicture.asset(
                            'assets/home.svg',
                          ),
                        ),
                        title: const Text(
                          'Home',
                          style: sideMenuStyle,
                        ),
                        onTap: !validLicense
                            ? null
                            : () {
                                sideProvider.selectedMenu = 'Home';

                                final prvRoom = Provider.of<RoomsProvider>(
                                    context,
                                    listen: false);

                                prvRoom.getInitialLaunchPack(
                                    lgnProvider.logedinUser.accountcode,
                                    '',
                                    'Individual');
                                prvRoom.readRooms(
                                    lgnProvider.logedinUser.workemail);
                                prvRoom.actionItemText = "My Action Items";

                                Navigator.pushNamed(context, "/Home");
                              },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: ((lgnProvider.logedinUser.mandatorycolumnfilled ==
                                'YES' &&
                            objCate.categoryname == 'Advisor' &&
                            restricttoAccount == false) &&
                        !issuperadmin),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (menuProvider.selectedMenu == 'Employer')
                              ? const Color.fromARGB(255, 234, 231, 231)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: SvgPicture.asset(
                            'assets/employer.svg',
                            ////color: AppColors.iconGray,
                          ),
                        ),
                        title: const Text(
                          'Employer',
                          style: sideMenuStyle,
                        ),
                        onTap: !validLicense
                            ? null
                            : () {
                                final prvEmployer =
                                    Provider.of<EmployerProvider>(context,
                                        listen: false);
                                prvEmployer.getEmployers(
                                    lgnProvider.logedinUser.accountcode);

                                sideProvider.selectedMenu = 'Employer';
                                Navigator.pushNamed(context, "/Employer");
                              },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: ((lgnProvider.logedinUser.mandatorycolumnfilled ==
                                'YES' &&
                            objCate.categoryname == 'Advisor' &&
                            restricttoAccount == false) &&
                        !issuperadmin),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (menuProvider.selectedMenu == 'Partner')
                              ? const Color.fromARGB(255, 234, 231, 231)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: SvgPicture.asset(
                            'assets/partner.svg',
                            ////color: AppColors.iconGray,
                          ),
                        ),
                        title: const Text(
                          'Partner',
                          style: sideMenuStyle,
                        ),
                        onTap: !validLicense
                            ? null
                            : () {
                                final partnerProvider =
                                    Provider.of<PartnerProvider>(context,
                                        listen: false);
                                partnerProvider.getPartnerAddedByAccount(
                                    lgnProvider.logedinUser.accountcode);
                                sideProvider.selectedMenu = 'Partner';
                                Navigator.pushNamed(context, "/Partner");
                              },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: (menuProvider.selectedMenu == 'Ideas')
                            ? const Color.fromARGB(255, 234, 231, 231)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: ListTile(
                      leading: SizedBox(
                        width: 20,
                        child: SvgPicture.asset(
                          'assets/idea.svg',
                          //color: AppColors.iconGray,
                        ),
                      ),
                      title: const Text(
                        'Ideas',
                        style: sideMenuStyle,
                      ),
                      onTap: !validLicense
                          ? null
                          : () {
                              sideProvider.selectedMenu = 'Ideas';
                              Navigator.pushNamed(context, "/Ideas");
                            },
                    ),
                  ),
                  Visibility(
                    visible: ((lgnProvider.logedinUser.mandatorycolumnfilled ==
                                    'YES' &&
                                restricttoAccount == false &&
                                (objCate.categoryname == 'Advisor') ||
                            objCate.categoryname == 'Partner') ||
                        issuperadmin),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (menuProvider.selectedMenu == 'Invite')
                              ? const Color.fromARGB(255, 234, 231, 231)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: SvgPicture.asset(
                            'assets/invite.svg',
                            //color: AppColors.iconGray,
                          ),
                        ),
                        title: const Text(
                          'Invite',
                          style: sideMenuStyle,
                        ),
                        onTap: !validLicense
                            ? null
                            : () {
                                sideProvider.selectedMenu = 'Invite';
                                Navigator.pushNamed(context, "/invite");
                              },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true && !issuperadmin,
                    child: Container(
                      decoration: BoxDecoration(
                          color: (menuProvider.selectedMenu == 'Contracts')
                              ? const Color.fromARGB(255, 234, 231, 231)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: SvgPicture.asset(
                            'assets/contract.svg',
                            color: AppColors.iconGray,
                          ),
                        ),
                        title: const Text(
                          'Contracts',
                          style: sideMenuStyle,
                        ),
                        onTap: !validLicense
                            ? null
                            : () {
                                sideProvider.selectedMenu = 'Contracts';
                                Navigator.pushNamed(context, "/contracts");
                              },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: (menuProvider.selectedMenu == 'Account')
                            ? const Color.fromARGB(255, 234, 231, 231)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: ListTile(
                      leading: SizedBox(
                        width: 20,
                        child: SvgPicture.asset(
                          'assets/account.svg',
                          //color: AppColors.iconGray,
                        ),
                      ),
                      title: const Text('Account', style: sideMenuStyle),
                      onTap: () {
                        //Navigator.pushNamed(context, "/ApplicationProfile");
                        //Navigator.pushNamed(context, "/Screen");
                        //Navigator.pushReplacementNamed(context, '/Screen');
                        //Navigator.pushNamed(context, '/companyProfile');
                        sideProvider.selectedMenu = 'Account';
                        Navigator.pushReplacementNamed(
                            context, '/companyProfile');
                      },
                    ),
                  ),
                  Visibility(
                    visible: validLicense && isAccountOwner && !issuperadmin,
                    child: ExpansionTile(
                      initiallyExpanded:
                          (menuProvider.selectedMenu == 'Subscription' ||
                                  menuProvider.selectedMenu == 'Billing' ||
                                  menuProvider.selectedMenu == 'Invoices')
                              ? true
                              : false,
                      leading: SizedBox(
                        width: 20,
                        child: SvgPicture.asset(
                          'assets/employer.svg',
                          //color: AppColors.iconGray,
                        ),
                      ),
                      title: Text('Admin', style: sideMenuStyle),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  (menuProvider.selectedMenu == 'Subscription')
                                      ? const Color.fromARGB(255, 234, 231, 231)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: ListTile(
                            title: const Text('Users',
                                textAlign: TextAlign.right,
                                style: sideMenuAdminStyle),
                            onTap: () {
                              sideProvider.selectedMenu = 'Subscription';
                              Navigator.pushReplacementNamed(
                                  context, '/Subscription');
                            },
                          ),
                        ),
                        Visibility(
                          visible: isAccountOwner &&
                              objCate.basecategorycode != 'employer',
                          child: Consumer<AdminProvider>(
                              builder: (context, admProvider, child) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: (menuProvider.selectedMenu ==
                                          'Billing')
                                      ? const Color.fromARGB(255, 234, 231, 231)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: ListTile(
                                title: const Text('Payment methods',
                                    textAlign: TextAlign.right,
                                    style: sideMenuAdminStyle),
                                onTap: () {
                                  sideProvider.selectedMenu = 'Billing';
                                  Account objA = lgnProvider.logedinUser;

                                  var obj = InputSetupIntent(
                                      customerid: '',
                                      name:
                                          '${objA.accountname} ${objA.lastname}',
                                      email: objA.workemail,
                                      description: "Payment for Advisor",
                                      metadata: {
                                        "accountcode": objA.accountcode
                                      });

                                  if (admProvider.attachedpaymentmethod ==
                                      null) {
                                    admProvider
                                        .createSetupIntentCheckOutSession(obj);
                                  } else if (admProvider
                                              .attachedpaymentmethod !=
                                          null &&
                                      admProvider.attachedpaymentmethod!
                                          .paymentmethoddata.isNull &&
                                      admProvider.setupintentUrl.isEmpty) {
                                    obj.customerid = admProvider
                                        .attachedpaymentmethod!.customerdata.id;
                                    admProvider
                                        .createSetupIntentCheckOutSession(obj);
                                  }

                                  Navigator.pushReplacementNamed(
                                      context, '/Billing');
                                },
                              ),
                            );
                          }),
                        ),
                        Visibility(
                          visible: isAccountOwner &&
                              objCate.basecategorycode != 'employer',
                          child: Consumer<AdminProvider>(
                              builder: (context, admProvider, child) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: (menuProvider.selectedMenu ==
                                          'Invoices')
                                      ? const Color.fromARGB(255, 234, 231, 231)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: ListTile(
                                title: const Text('Invoices',
                                    textAlign: TextAlign.right,
                                    style: sideMenuAdminStyle),
                                onTap: () {
                                  sideProvider.selectedMenu = 'Invoices';
                                  Navigator.pushReplacementNamed(
                                      context, '/Invoices');
                                },
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: const Alignment(0, .8),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: ListTile(
                    leading: const SizedBox(
                      width: 20,
                      child: Icon(Icons.logout),
                    ),
                    title: const Text('Logout', style: sideMenuStyle),
                    onTap: () async {
                      // Add logout functionality here
                      try {
                        final empProvider = Provider.of<EmployerProvider>(
                            context,
                            listen: false);
                        empProvider.addNew = false;
                        empProvider.edit = false;
                        Employer obj = Employer(partners: []);
                        empProvider.selectedEmployer = obj;
                        // empProvider.employers.clear();

                        final partnerProvider = Provider.of<PartnerProvider>(
                            context,
                            listen: false);
                        partnerProvider.addNew = false;
                        partnerProvider.edit = false;
                        partnerProvider.partners.clear();
                        Partner objPartner = Partner();
                        partnerProvider.selectedPartner = objPartner;

                        lgnProvider.logedinUser = Account(rolewithemployer: []);
                        lgnProvider.clearLoggedInCredential();
                        lgnProvider.passwordController.text = "";
                        lgnProvider.emailController.text = "";

                        final launchProvider =
                            Provider.of<LaunchProvider>(context, listen: false);
                        launchProvider.launchpacks.clear();
                        launchProvider.selectedLaunchPacks?.clear();

                        final addProvider = Provider.of<AddotherProvider>(
                            context,
                            listen: false);
                        addProvider.advisorinvites.clear();
                        addProvider.filteredinvites.clear();

                        final roomProvider =
                            Provider.of<RoomsProvider>(context, listen: false);
                        roomProvider.employers.clear();
                        roomProvider.launchpacks.clear();

                        final ideaProvider =
                            Provider.of<IdeaProvider>(context, listen: false);
                        ideaProvider.ideas.clear();
                        ideaProvider.votes.clear();
                        final adminProvider =
                            Provider.of<AdminProvider>(context, listen: false);
                        adminProvider.subscriptionLicenses.clear();
                        adminProvider.subscriptions.clear();

                        final paymentProvider =
                            Provider.of<PaymentMethodProvider>(context,
                                listen: false);
                        paymentProvider.paymentmethods.clear();
                        if (lgnProvider.currentGoogleUser != null) {
                          lgnProvider.googleSignOut();
                        }

                        await clearCache(context);
                        Navigator.of(context).pushAndRemoveUntil(
                          // the new route
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(),
                          ),

                          (Route route) => false,
                        );
                      } catch (e) {
                        rethrow;
                      }
                    },
                  ),
                ),
              ),
              Consumer<AdminProvider>(builder: (context, admProvider, child) {
                if (objCate.categoryname != 'Employer' && isAccountOwner) {
                  validPaymentMethod = admProvider.validpaymentmethodexist;
                  lgnProvider.logedinUser.validpaymentmethodexist =
                      validPaymentMethod;
                }
                return issuperadmin
                    ? Text('')
                    : ((!validLicense || !validPaymentMethod))
                        ? Align(
                            alignment: Alignment(0, .6),
                            child: ListTile(
                              title: Text(
                                'Alert!',
                                style: TextStyle(color: AppColors.red),
                              ),
                              subtitle: Text(
                                'Subscription is not active or has expired! Please contact your account owner.\nPayment method needs to be on file for an active subscription.\nPayment method can be added by the account owner in the Admin section.',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          )
                        : Text('');
              }),
              const Align(
                alignment: Alignment(0, 1),
                child: ListTile(
                  title: Text('Need help?'),
                  subtitle: Text('support@alicorn.co'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> clearCache(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.clearCachedAccount();
    loginProvider.clearLoggedInCredential();
    if (loginProvider.currentGoogleUser != null) {
      loginProvider.googleSignOut();
    }

    Provider.of<AddotherProvider>(context, listen: false)
        .advisorinvites
        .clear();
    Provider.of<EmployerProvider>(context, listen: false)
        .actionlaunchpacks
        .clear();
    Provider.of<EmployerProvider>(context, listen: false)
        .employerAssistList
        .clear();
    Provider.of<EmployerProvider>(context, listen: false)
        .attachmentTypeList
        .clear();
    Provider.of<EmployerProvider>(context, listen: false)
        .employerprofiles
        .clear();
    Provider.of<EmployerProvider>(context, listen: false).clearEmployees();
    Provider.of<EmployerProvider>(context, listen: false).clearLaunchPacks();

    Provider.of<RoomsProvider>(context, listen: false).clearActionLaunchPack();
    Provider.of<RoomsProvider>(context, listen: false).clearEmployees();
    Provider.of<RoomsProvider>(context, listen: false).clearLaunchPacks();

    Provider.of<IdeaProvider>(context, listen: false).ideas.clear();
    Provider.of<IdeaProvider>(context, listen: false).votes.clear();
    /*   Provider.of<LaunchProvider>(context, listen: false)
        .attachmentTypeList
        .clear(); */
    /*  Provider.of<LaunchProvider>(context, listen: false).itemStatusList.clear(); */
    Provider.of<LaunchProvider>(context, listen: false).launchpacks.clear();

    Provider.of<PartnerProvider>(context, listen: false).partners.clear();

    Provider.of<PartnerProvider>(context, listen: false)
        .invitedPartners
        .clear();
    final prvMicrosoft =
        Provider.of<MicrosoftAuthProvider>(context, listen: false);
    if (prvMicrosoft.accessToken != null) {
      prvMicrosoft.microsoftLogout();
    }
  }
}
