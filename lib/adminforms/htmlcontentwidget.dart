import 'package:advisorapp/checkout/checkoutwidget.dart';
import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/models/stripe/stripesession.dart';
import 'package:advisorapp/service/stripeservice.dart';
import 'package:flutter/material.dart';

class HtmlContentWidget extends StatefulWidget {
  const HtmlContentWidget({super.key});

  @override
  _HtmlContentWidgetState createState() => _HtmlContentWidgetState();
}

class _HtmlContentWidgetState extends State<HtmlContentWidget> {
  late Future<StripeSession> _htmlContentFuture;

  @override
  void initState() {
    super.initState();
    _htmlContentFuture = _fetchHtmlContent();
  }

  Future<StripeSession> _fetchHtmlContent() async {
    final response = await StripeService().createCheckOutSession('', '', '');
    return response!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Background(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              child: FutureBuilder<StripeSession>(
                future: _htmlContentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return SizedBox(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 30),
                        child: SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          height: SizeConfig.screenHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckOutWidget(htmlContent: snapshot.data!),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
