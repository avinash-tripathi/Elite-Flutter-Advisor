import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyIframe extends StatelessWidget {
  final String src;

  const MyIframe({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    // Register the view factory with a dynamic src
    ui.platformViewRegistry.registerViewFactory(
      'esigniframe',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..width = '640'
          ..height = '360'
          ..style.border = 'none';

        // Set the src dynamically
        //iframe.src = 'https://www.youtube.com/embed/$youtubeVideoId';
        iframe.src = src;

        return iframe;
      },
    );

    // Use the platform view
    return HtmlElementView(
      viewType: 'esigniframe',
      onPlatformViewCreated: (id) {},
    );
  }
}
