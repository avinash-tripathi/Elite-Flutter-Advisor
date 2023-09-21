// ignore_for_file: library_private_types_in_public_api

import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_button.dart';
import 'package:flutter/material.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  late String mobile;
  late String password;
  late bool remember = false;
  final bool _clicked = false;
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final List<String> errors = [];
  final snackBar = const SnackBar(
    content: Text('Authenticated!!'),
  );

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildMobileFormField(),
          const SizedBox(height: 30),
          buildPasswordFormField(),
          const SizedBox(height: 30),
          Row(
            children: [
              // Checkbox(
              //   value: remember,
              //   activeColor: kPrimaryColor,
              //   onChanged: (value) {
              //     setState(() {
              //       remember = value;
              //     });
              //   },
              // ),
              //Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => {null},
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: _clicked != true ? "Sign In" : "Please Wait..",
            onPressed: () async {
              if (true) {
                /* try {
                  Auth obj = new Auth();
                  obj.password = passwordController.text;
                  obj.mobile = mobileController.text;
                  await LoginService()
                      .authenticateCredential(obj)
                      .then((authResult) {
                  
                    dynamic res = jsonDecode(authResult);
                    if (res['User'][0]["EmployeeId"] != "") {
                      LoginService().setLoggedInCredential(authResult);
                      KeyboardUtil.hideKeyboard(context);
                      showSnackBar(context, "Authenticated..");

                      setState(() {
                        _clicked = false;
                      });

                      //Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    } else {
                      showSnackBar(context, "Invalid Credential");
                      setState(() {
                        _clicked = false;
                      });
                    }
                  });
                } catch (e) {
                  setState(() {
                    showSnackBar(context, "Invalid Credential");
                    _clicked = false;
                  });
                } finally {} */

                // if all are valid then go to success screen
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMobileFormField() {
    return TextFormField(
      controller: mobileController,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => mobile = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kMobileNullError);
        } else if (mobileValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidMobileError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kMobileNullError);
          return "";
        } else if (!mobileValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidMobileError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Mobile",
        hintText: "Enter your mobile number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
