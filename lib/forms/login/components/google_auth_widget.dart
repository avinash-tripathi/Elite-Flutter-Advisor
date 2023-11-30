import 'package:advisorapp/component/sign_in_button/web.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/config/size_config.dart';

class GoogleAuthWidget extends StatelessWidget {
  const GoogleAuthWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sideProv = Provider.of<SidebarProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // However, in the web...
      if (kIsWeb && account != null) {
        loginProvider.currentGoogleUser = account;
        var obj = Auth(
            email: loginProvider.googleSignIn.currentUser!.email,
            mypassword: '',
            firebaseverified: true);
        loginProvider.verifyCredential(obj).then((value) => {
              if (loginProvider.logedinUser.accountcode.trim().length > 1)
                {
                  loginProvider
                      .setLoggedInCredential(loginProvider.logedinUser)
                      .then((value) => {
                            sideProv.selectedMenu = 'Account',
                            Navigator.pushNamed(context, "/companyProfile")
                          })
                }
            });
      }
    });
    return buildBody();
  }

  Widget buildBody() {
    return Consumer<LoginProvider>(
      builder: (context, lProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildSignInButton(
              onPressed: () async {
                try {
                  final loginProvider =
                      Provider.of<LoginProvider>(context, listen: false);
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
