@JS()
library stripe;

import 'package:advisorapp/checkout/constants.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
//https://www.youtube.com/watch?v=yYxIWEQgOe4&t=786s

void redirectToCheckout(BuildContext _) async {
  final stripe = Stripe(apiKey);
  stripe.redirectToCheckout(CheckoutOptions(
    lineItems: [
      LineItem(price: nikesPriceId, quantity: 1),
    ],
    mode: 'payment',
    successUrl: 'http://localhost:5000/#/success',
    cancelUrl: 'http://localhost:5000/#/cancel',
  ));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
