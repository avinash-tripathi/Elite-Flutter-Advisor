// ignore_for_file: unused_import

import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/login/components/login_form_firebase.dart';
import 'package:advisorapp/forms/login/components/login_sidemenu.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../component/background.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Background(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: LoginSideMenu()),
            Flexible(flex: 8, child: LoginScreenTopImage()),
            Flexible(flex: 3, child: LoginForm()),
          ],
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
                flex: 8,
                child: LoginForm() //LoginFormFirebase(), //LoginForm(),
                ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
