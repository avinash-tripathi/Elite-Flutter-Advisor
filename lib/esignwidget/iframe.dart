import 'dart:html' as html;
import 'package:advisorapp/providers/launch_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class MyIframe extends StatelessWidget {
  final String src;

  const MyIframe({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    // Register the view factory with a dynamic src
    ui.platformViewRegistry.registerViewFactory(
      src,
      (int viewId) {
        /*  final l = Provider.of<LaunchProvider>(context, listen: false);
        l.viewIframe = false; */
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
            viewType: src,
            onPlatformViewCreated: (id) {},
          ),
        ),
        IconButton(
            onPressed: () {
              Provider.of<LaunchProvider>(context, listen: false).viewIframe =
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
