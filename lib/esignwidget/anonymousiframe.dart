import 'dart:html' as html;

import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class AnonymousIframe extends StatelessWidget {
  final String src;

  const AnonymousIframe({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    // Register the view factory with a dynamic src
    final roomProvider = Provider.of<RoomsProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    ui.platformViewRegistry.registerViewFactory(
      'esignanonymousiframe',
      (int viewId) {
        /*  final l = Provider.of<LaunchProvider>(context, listen: false);
        l.viewNewAnoIframe = false; */
        final iframe = html.IFrameElement()
          ..width = '550'
          ..height = '650'
          ..style.border = 'none';

        // Set the src dynamically
        //iframe.src = 'https://www.youtube.com/embed/$youtubeVideoId';
        iframe.src = src;
        return iframe;
      },
    );

    // Use the platform view
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: HtmlElementView(
            viewType: 'esignanonymousiframe',
            onPlatformViewCreated: (id) {},
          ),
        ),
        Tooltip(
          decoration: tooltipdecorationGradient,
          message: "Click here to send contract to recepient.",
          child: Consumer<RoomsProvider>(builder: (context, prvView, child) {
            return prvView.startESign
                ? displaySpin()
                : IconButton(
                    onPressed: () async {
                      try {
                        await roomProvider
                            .startAnonESignatureProcess(
                                roomProvider.anonymousUser!)
                            .then((value) => {
                                  if (roomProvider
                                      .anonymousUser!.processid.isNotEmpty)
                                    {
                                      showSnackBar(context,
                                          'Successfully Sent for ESign'),
                                      roomProvider.readAnonymousEsignEntries(
                                          loginProvider
                                              .logedinUser.accountcode),
                                      roomProvider.viewNewAnoIframe = false,
                                      roomProvider.newEsign = false
                                    }
                                  else
                                    {
                                      showSnackBar(context,
                                          'There is some issue on sending email.\n Please contact to Account Owner!')
                                    }
                                });
                      } catch (e) {
                        showSnackBar(context,
                            'There is some issue on sending email.\n Please contact to Account Owner!');
                        roomProvider.viewNewAnoIframe = false;
                        roomProvider.newEsign = false;
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.blue,
                    ));
          }),
        ),
        IconButton(
            onPressed: () {
              Provider.of<RoomsProvider>(context, listen: false)
                  .viewNewAnoIframe = false;
              Provider.of<RoomsProvider>(context, listen: false).newEsign =
                  false;
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.red,
            ))
      ],
    );
  }
}
