import 'package:advisorapp/component/background.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  /*  Widget build(BuildContext context) {
    const String trademark = "™";
    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: defaultPadding * 8),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: SvgPicture.asset('assets/AlicornLogoTransparent.svg'),
                ),
                const Text(
                  "advisor$trademark",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
                ),
                const SizedBox(height: defaultPadding),
                const Text(
                  "Client launch & renewal management platform",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontStyle: FontStyle.italic),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeHorizontal * 18),
                        child: Column(
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  } */
  Widget build(BuildContext context) {
    const String trademark = "™";
    return Scaffold(
      body: Background(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: SvgPicture.asset('assets/AlicornLogoTransparent.svg'),
              ),
              const Text(
                "advisor$trademark",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
              ),
              const Text(
                "Work more efficiently!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontStyle: FontStyle.italic),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                    vertical: defaultPadding / 2, horizontal: defaultPadding),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: '',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /* const SizedBox(height: 16),
             Text(
              "\u00a9 ${DateTime.now().year.toString()} ALICORN INC.",
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ), */
            ],
          ),
        ),
      ),
    );
  }
}
