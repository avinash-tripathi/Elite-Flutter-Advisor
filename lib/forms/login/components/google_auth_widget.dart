import 'package:advisorapp/component/sign_in_button/web.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleAuthWidget extends StatelessWidget {
  const GoogleAuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return (loginProvider.currentGoogleUser != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: GoogleUserCircleAvatar(
                      identity: loginProvider.currentGoogleUser!,
                    ),
                    title: Text(
                        loginProvider.googleSignIn.currentUser!.displayName ??
                            ''),
                    subtitle:
                        Text(loginProvider.googleSignIn.currentUser!.email),
                  ),
                  //const Text('Signed in successfully.'),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          final sideProv = Provider.of<SidebarProvider>(context,
                              listen: false);
                          Account? res;
                          var obj = Auth(
                              email:
                                  loginProvider.googleSignIn.currentUser!.email,
                              mypassword: '',
                              firebaseverified: true);
                          await loginProvider.verifyCredential(obj);
                          if (!loginProvider.verifying) {
                            res = loginProvider.logedinUser;
                            if (res.accountcode.trim().length > 1) {
                              await loginProvider.setLoggedInCredential(res);
                              sideProv.selectedMenu = 'Account';
                              Navigator.pushNamed(context, "/companyProfile");
                            }
                          }
                        } catch (e) {
                          //showSnackBar(context, "Invalid Credential");
                        } finally {}
                      },
                      child: const Text('Click To Proceed'))
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // const Text('You are not currently signed in.'),
                  buildSignInButton(
                    onPressed: () async {
                      try {
                        await loginProvider.handleGoogleSignIn();
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                  ),
                ],
              );
      },
    );
  }
}
