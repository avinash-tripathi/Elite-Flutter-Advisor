import 'package:advisorapp/models/stripe/payment/cardpaymentmethodoptions.dart';

class PaymentMethodOptions {
  final CardPaymentMethodOptions card;

  PaymentMethodOptions({required this.card});

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    return PaymentMethodOptions(
      card: CardPaymentMethodOptions.fromJson(json['card']),
    );
  }
}
