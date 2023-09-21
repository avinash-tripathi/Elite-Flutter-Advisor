import 'package:flutter/material.dart';

class UrlAlertDialog extends StatelessWidget {
  final String url;

  const UrlAlertDialog(this.url);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Web Page'),
      content: Container(
        width: double.maxFinite,
        height: 400, // Adjust the height as needed
        child: WebViewIframe(url),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class WebViewIframe extends StatelessWidget {
  final String url;

  const WebViewIframe(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const HtmlElementView(
        viewType: 'iframeElement',
      ),
    );
  }
}
