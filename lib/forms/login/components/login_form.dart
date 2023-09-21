import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/forms/login/components/google_auth_widget.dart';
import 'package:advisorapp/forms/login/components/microsoft_auth_widget.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/providers/admin_provider.dart';

import 'package:advisorapp/providers/login_provider.dart';

import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../../models/auth.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    //final rProv = Provider.of<RoomProvider>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
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
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MicrosoftAuthWidget(),
              const GoogleAuthWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding),
                child: TextFormField(
                  controller: lgnProvider.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  onSaved: (email) {},
                  decoration: CustomTextDecoration.textDecoration(
                    'Your email',
                    const Icon(
                      Icons.person,
                      color: AppColors.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Email Id.';
                    }
                    if (!isEmailValid(value)) {
                      return 'Invalid Email Format.';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 2, horizontal: defaultPadding),
                child: TextFormField(
                  controller: lgnProvider.passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  cursorColor: kPrimaryColor,
                  decoration: CustomTextDecoration.textDecoration(
                    'Your password',
                    const Icon(
                      Icons.lock,
                      color: AppColors.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Password.';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*  SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    child: const Text('Back'),
                    onPressed: () {
                      showCustomSnackBar(context, "My Error Message");
                    },
                  ),
                ), */
                  SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: buttonStyleBlue,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              //emailController.text = 'hr@elitedigital.ai';
                              //passwordController.text = '123456';
                              final sideProv = Provider.of<SidebarProvider>(
                                  context,
                                  listen: false);

                              Account? res;
                              var obj = Auth(
                                  email: lgnProvider.emailController.text,
                                  mypassword:
                                      lgnProvider.passwordController.text,
                                  firebaseverified: false);
                              await lgnProvider.verifyCredential(obj);
                              if (!lgnProvider.verifying) {
                                res = lgnProvider.logedinUser;
                                if (res.accountcode.trim().length > 1 &&
                                    res.isfirstlogin == false &&
                                    res.invitationstatus.toUpperCase() !=
                                        'EXPIRED') {
                                  await lgnProvider.setLoggedInCredential(res);
                                  sideProv.selectedMenu = 'Account';

                                  Navigator.pushNamed(
                                      context, "/companyProfile");
                                } else if (res.accountcode.trim().length > 1 &&
                                    res.isfirstlogin == true &&
                                    res.invitationstatus.toUpperCase() !=
                                        'EXPIRED') {
                                  await lgnProvider.setLoggedInCredential(res);
                                  Navigator.pushNamed(
                                      context, "/ResetPassword");
                                } else if (res.accountcode.trim().length > 1 &&
                                    res.invitationstatus.toUpperCase() ==
                                        'EXPIRED') {
                                  showSnackBar(context,
                                      'Your invitation has expired. Please request the person that sent you the invitation to resend it. ');
                                } else {
                                  // ignore: use_build_context_synchronously
                                  lgnProvider.invalidCredential = true;
                                  // ignore: use_build_context_synchronously
                                  showSnackBar(context, 'Invalid Credential');
                                }
                              }
                            } catch (e) {
                              //showSnackBar(context, "Invalid Credential");
                            } finally {}
                          }
                        },
                        child: lgnProvider.verifying
                            ? displaySpin()
                            : const Text(
                                "Log in",
                              ),
                      )),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 2, horizontal: defaultPadding),
                child: Text.rich(
                  TextSpan(
                    text:
                        'By continuing, you are indicating that you have read and agree to the ',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Use',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse('https://alicorn.co/terms'),
                                mode: LaunchMode.externalApplication);
                          },
                      ),
                      const TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          )),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse('https://alicorn.co/privacy'),
                                mode: LaunchMode.externalApplication);
                          },
                      ),
                      const TextSpan(
                        text: '.',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 2, horizontal: defaultPadding),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text:
                            '\u00a9 ${DateTime.now().year.toString()} ALICORN INC.',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Text.rich(
                      TextSpan(
                        text: 'Need help? support@alicorn.co',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /* Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " \u00a9 ${DateTime.now().year.toString()} ALICORN INC.",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Need help? support@alicorn.co",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ) */
            ],
          ),
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email To: cannot be empty.';
    }
    if (!isEmailValid(value)) {
      return 'Invalid Email Format.';
    }
    return null;
  }
}
