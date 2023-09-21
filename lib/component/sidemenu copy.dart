// ignore_for_file: unused_import, prefer_const_constructors

import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/Login/login_screen.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/idea_provider.dart';
import 'package:advisorapp/providers/launch_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../config/size_config.dart';
import '../style/colors.dart';

class SideMenu extends StatefulWidget {
  // final GoogleSignInAccount currentGoogleAccount;
  const SideMenu({
    Key? key,
    // required this.currentGoogleAccount,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    final mstProvider = Provider.of<MasterProvider>(context, listen: false);
    CompanyCategory objCate = mstProvider.companycategories[0];
    if (mstProvider.companycategories.isNotEmpty &&
        lgnProvider.logedinUser.companycategory.isNotEmpty) {
      objCate = mstProvider.companycategories.firstWhere((element) =>
          element.categorycode == lgnProvider.logedinUser.companycategory);
    }

    String paymentcode = '';
    paymentcode = lgnProvider.logedinUser.accountpaymentinfo;
    bool restricttoAccount =
        (paymentcode == 'PC-20230423165346513') ? true : false;
    bool validLicense = lgnProvider.logedinUser.validlicense;
    bool isAccountOwner =
        (lgnProvider.logedinUser.accountrole == 'RL-20230224175000800');

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
                  Container(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: GoogleUserCircleAvatar(
                        identity: lgnProvider.currentGoogleUser!,
                      ),
                      title: Text(
                          lgnProvider.currentGoogleUser!.displayName ?? '',
                          style: sideGoogleStyle),
                      /*    subtitle: Text(lgnProvider.currentGoogleUser!.email,
                          style: sideMenuStyle), */
                    ),
                  ),
                  Visibility(
                    visible: (restricttoAccount == false),
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
                                menuProvider.selectedMenu = 'Home';
                                Navigator.pushNamed(context, "/Home");
                              },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (lgnProvider.logedinUser.mandatorycolumnfilled ==
                            'YES' &&
                        objCate.categoryname == 'Advisor' &&
                        restricttoAccount == false),
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
                                menuProvider.selectedMenu = 'Employer';
                                Navigator.pushNamed(context, "/Employer");
                              },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (lgnProvider.logedinUser.mandatorycolumnfilled ==
                            'YES' &&
                        objCate.categoryname == 'Advisor' &&
                        restricttoAccount == false),
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
                                menuProvider.selectedMenu = 'Partner';
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
                              menuProvider.selectedMenu = 'Ideas';
                              Navigator.pushNamed(context, "/Ideas");
                            },
                    ),
                  ),
                  Visibility(
                    visible: (lgnProvider.logedinUser.mandatorycolumnfilled ==
                            'YES' &&
                        restricttoAccount == false),
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
                                menuProvider.selectedMenu = 'Invite';
                                Navigator.pushNamed(context, "/invite");
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
                        menuProvider.selectedMenu = 'Account';
                        Navigator.pushReplacementNamed(
                            context, '/companyProfile');
                      },
                    ),
                  ),
                  Visibility(
                    visible: isAccountOwner,
                    child: ExpansionTile(
                      initiallyExpanded:
                          (menuProvider.selectedMenu == 'Subscription')
                              ? true
                              : false,
                      leading: SizedBox(
                        width: 20,
                        child: SvgPicture.asset(
                          'assets/account.svg',
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
                            leading: SizedBox(
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/account.svg',
                                //color: AppColors.iconGray,
                              ),
                            ),
                            title: const Text('License', style: sideMenuStyle),
                            onTap: () {
                              menuProvider.selectedMenu = 'Subscription';
                              Navigator.pushReplacementNamed(
                                  context, '/Subscription');
                            },
                          ),
                        ),
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
                        /* final roomProvider =
                            Provider.of<RoomProvider>(context, listen: false);
                        roomProvider.employers.clear(); */

                        //lgnProvider.googleSignOut();
                        lgnProvider.logedinUser = Account(rolewithemployer: []);

                        lgnProvider.clearLoggedInCredential();
                        await clearCache();

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
              !validLicense
                  ? Align(
                      alignment: Alignment(0, .6),
                      child: ListTile(
                        title: Text(
                          'License Expired!',
                          style: TextStyle(color: AppColors.red),
                        ),
                        subtitle:
                            Text('Please contact with your Account Owner.'),
                      ),
                    )
                  : Text(''),
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

  Future<void> clearCache() async {
    Provider.of<LoginProvider>(context, listen: false).clearCachedAccount();
    Provider.of<LoginProvider>(context, listen: false)
        .clearLoggedInCredential();
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
    Provider.of<LaunchProvider>(context, listen: false)
        .attachmentTypeList
        .clear();
    Provider.of<LaunchProvider>(context, listen: false).itemStatusList.clear();
    Provider.of<LaunchProvider>(context, listen: false).launchpacks.clear();

    Provider.of<PartnerProvider>(context, listen: false).partners.clear();
    Provider.of<PartnerProvider>(context, listen: false).partners.clear();
    Provider.of<PartnerProvider>(context, listen: false)
        .invitedPartners
        .clear();
  }
}
