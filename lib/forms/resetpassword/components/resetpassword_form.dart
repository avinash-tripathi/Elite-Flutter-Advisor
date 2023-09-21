import 'package:advisorapp/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  // late String loggedinAccountCode = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final newpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /*  getLoggedInUser() async {
    await HttpService().getLoggedInAccountCode().then((value) => {
          loggedinAccountCode = value!,
        });
    setState(() {});
  }
 */
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: newpasswordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter new password';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "New password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: confirmpasswordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm new password.';
                }
                if (value != newpasswordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: "Confirm password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    LoginProvider loginProvider =
                        Provider.of<LoginProvider>(context, listen: false);
                    await loginProvider.accountResetPassword(
                        loginProvider.logedinUser.accountcode,
                        confirmpasswordController.text);

                    if (loginProvider.resetPasswordStatus.accountcode != "") {
                      /* await EliteDialog(context, 'Reset Confirmed!',
                            'Dear User, your passord reset successfully, Please login again in Advisor Portal!'); */
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, "/Login");
                    }
                  }
                } catch (e) {
                  /* setState(() {
                    showSnackBar(context, "Error while reset Password");
                  }); */
                } finally {}
              },
              child: Text(
                "Reset Password".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          /* AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ), */
        ],
      ),
    );
  }
}
