import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/models/stripe/stripesession.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'package:url_launcher/url_launcher.dart';

class CheckOutWidget extends StatelessWidget {
  StripeSession htmlContent; // URL of your API that returns an HTML page
  CheckOutWidget({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth / 15,
      height: SizeConfig.screenHeight / 15,
      child: Center(
        child: Consumer<AdminProvider>(builder: (context, prvRead, child) {
          return ElevatedButton(
            onPressed: () async {
              //redirectToURL(htmlContent);
              final Uri url = Uri.parse(prvRead.checkoutsession.sessionUrl);
              await launchUrl(url);
              prvRead.initSubscription = false;
            },
            child: const Text('Pay'),
          );
        }),
      ),
    );
  }

  void redirectToURL(String url) {
    js.context.callMethod('eval', ['window.location.assign("$url");']);
  }
}
