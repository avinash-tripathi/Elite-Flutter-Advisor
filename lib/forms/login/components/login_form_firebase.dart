import 'package:advisorapp/component/sign_in_button/web.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginFormFirebase extends StatefulWidget {
  const LoginFormFirebase({Key? key}) : super(key: key);

  @override
  State<LoginFormFirebase> createState() => _LoginFormFirebaseState();
}

class _LoginFormFirebaseState extends State<LoginFormFirebase> {
  @override
  initState() {
    super.initState();
    /*  MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);
    masterProvider.getRoles();
    masterProvider.getEmployerRoles();
    masterProvider.getCompanyCategories();
    masterProvider.getCompanyTypes();
    final partnerProvider =
        Provider.of<PartnerProvider>(context, listen: false);
    partnerProvider.getPartner(); */
  }

  @override
  Widget build(BuildContext context) {
    return Form(child: buildBody());
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
