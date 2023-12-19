import 'dart:html' as html;
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'package:advisorapp/providers/employer_provider.dart';

class IframeEmployer extends StatelessWidget {
  final String src;

  const IframeEmployer({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    // Register the view factory with a dynamic src
    ui.platformViewRegistry.registerViewFactory(
      src,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..width = '550'
          ..height = '650'
          ..style.border = 'none';
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
              final prv = Provider.of<EmployerProvider>(context, listen: false);
              prv.esignembededdata = null;
              prv.viewIframe = false;
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.red,
            ))
      ],
    );
  }
}
