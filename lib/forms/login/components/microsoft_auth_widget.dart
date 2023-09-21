import 'dart:js_interop';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/microsoftAuth_Provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MicrosoftAuthWidget extends StatelessWidget {
  MicrosoftAuthWidget({Key? key}) : super(key: key);

  _loginWithMicrosoft(BuildContext context) async {
    final microsoftProv =
        Provider.of<MicrosoftAuthProvider>(context, listen: false);

    /*await microsoftProv.microsoftLogin(); */
    try {
      final AadOAuth oauth = AadOAuth(microsoftProv.config!);
      final result = await oauth.login();
      result.fold(
        (l) => showError(l.toString(), context),
        (r) => showMessage(
            'Logged in successfully, your access token: $r', context),
      );
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        //_accessToken = accessToken;
        // getAuthenticatedUserData();
      }
    } catch (ex) {
      print(ex);
    }
  }

  void showError(dynamic ex, context) {
    showMessage(ex.toString(), context);
  }

  void showMessage(String text, context) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*  Consumer<MicrosoftAuthProvider>(
            builder: (context, loginMicrosoft, child) {
          return ElevatedButton(
              onPressed: () async {
                final sideProv =
                    Provider.of<SidebarProvider>(context, listen: false);
                if (!loginMicrosoft.microsoftToken.isNull) {
                  try {
                    final loginProvider =
                        Provider.of<LoginProvider>(context, listen: false);
                    Account? res;
                    var obj = loginMicrosoft.authUser;
                    await loginProvider.verifyCredential(obj!);
                    if (!loginProvider.verifying) {
                      res = loginProvider.logedinUser;
                      if (res.accountcode.trim().length > 1) {
                        await loginProvider
                            .setLoggedInCredential(res)
                            .then((value) => {
                                  sideProv.selectedMenu = 'Account',
                                  Navigator.pushNamed(
                                      context, "/companyProfile")
                                });
                      }
                    }
                  } catch (e) {
                    //showSnackBar(context, "Invalid Credential");
                  } finally {}
                }
              },
              child: const Text('Click to Proceed'));
        }), */
        GestureDetector(
          onTap: () {
            _loginWithMicrosoft(context);
          },
          child: SizedBox(
            width: SizeConfig.screenWidth / 8.5,
            height: SizeConfig.blockSizeVertical * 10,
            child: SvgPicture.asset(
              'assets/microsoftsignin.svg', // Replace with your SVG file path
              width: 80,
              height: 80,
            ),
          ),
        ),
      ],
    );
  }
}
