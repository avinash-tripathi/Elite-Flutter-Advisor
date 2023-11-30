import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/microsoftAuth_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../providers/sidebar_provider.dart';

class MicrosoftAuthWidget extends StatelessWidget {
  const MicrosoftAuthWidget({Key? key}) : super(key: key);

  loginWithMicrosoft(BuildContext context) async {
    final microsoftProv =
        Provider.of<MicrosoftAuthProvider>(context, listen: false);
    await microsoftProv.microsoftLogin();
  }

  @override
  Widget build(BuildContext context) {
    final sideProv = Provider.of<SidebarProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    final prvMicrosoft =
        Provider.of<MicrosoftAuthProvider>(context, listen: false);
    return Column(
      children: [
        Consumer<MicrosoftAuthProvider>(
            builder: (context, loginMicrosoft, child) {
          return /* GestureDetector(
            onTap: () async {
              await loginMicrosoft.microsoftLogin();

              if (loginMicrosoft.accessToken != null) {
                await loginMicrosoft.getAuthenticatedUserData();
                Account? res;
                var obj = loginMicrosoft.authUser;
                await lgnProvider.verifyCredential(obj!);
                if (!lgnProvider.verifying) {
                  res = lgnProvider.logedinUser;
                  if (res.accountcode.trim().length > 1 &&
                      res.invitationstatus.toUpperCase() != 'EXPIRED') {
                    sideProv.selectedMenu = 'Account';
                    await lgnProvider.setLoggedInCredential(res).then((value) =>
                        Navigator.pushNamed(context, "/companyProfile"));
                  } else if (res.accountcode.trim().length > 1 &&
                      res.invitationstatus.toUpperCase() == 'EXPIRED') {
                    showSnackBar(context,
                        'Your invitation has expired. Please request the person that sent you the invitation to resend it. ');
                  } else {
                    lgnProvider.invalidCredential = true;
                    // ignore: use_build_context_synchronously
                    if (prvMicrosoft.accessToken != null) {
                      prvMicrosoft.microsoftLogout();
                    }

                    showSnackBar(context, 'Invalid Credential');
                  }
                }
              }

            },
            child: SizedBox(
              width: SizeConfig.screenWidth / 8.2,
              height: SizeConfig.blockSizeVertical * 11,
              child: SvgPicture.asset(
                'assets/microsoftsignin.svg', // Replace with your SVG file path
                width: 80,
                height: 80,
              ),
            ),
          ); */
              SizedBox(
            /* width: SizeConfig.screenWidth / 7.2,
            height: SizeConfig.blockSizeVertical * 11, */
            width: 210,
            height: SizeConfig.blockSizeVertical * 11,
            child: ElevatedButton(
              onPressed: () async {
                await loginMicrosoft.microsoftLogin();

                if (loginMicrosoft.accessToken != null) {
                  await loginMicrosoft.getAuthenticatedUserData();
                  Account? res;
                  var obj = loginMicrosoft.authUser;
                  await lgnProvider.verifyCredential(obj!);
                  if (!lgnProvider.verifying) {
                    res = lgnProvider.logedinUser;
                    if (res.accountcode.trim().length > 1 &&
                        res.invitationstatus.toUpperCase() != 'EXPIRED') {
                      sideProv.selectedMenu = 'Account';
                      await lgnProvider.setLoggedInCredential(res).then(
                          (value) =>
                              Navigator.pushNamed(context, "/companyProfile"));
                    } else if (res.accountcode.trim().length > 1 &&
                        res.invitationstatus.toUpperCase() == 'EXPIRED') {
                      showSnackBar(context,
                          'Your invitation has expired. Please request the person that sent you the invitation to resend it. ');
                    } else {
                      lgnProvider.invalidCredential = true;
                      // ignore: use_build_context_synchronously
                      if (prvMicrosoft.accessToken != null) {
                        prvMicrosoft.microsoftLogout();
                      }

                      showSnackBar(context, 'Invalid Credential');
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent),
              child: SvgPicture.asset(
                'assets/microsoftsignin.svg', // Path to your SVG asset
                width: SizeConfig.screenWidth / 20,
                height: SizeConfig.blockSizeVertical * 5,
              ),
            ),
          );
        }),
      ],
    );
  }
}
