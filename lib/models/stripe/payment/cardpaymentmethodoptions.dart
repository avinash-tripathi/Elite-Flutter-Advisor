class CardPaymentMethodOptions {
  final int installments;
  final dynamic mandateOptions;
  final dynamic network;
  final String requestThreeDSecure;

  CardPaymentMethodOptions({
    required this.installments,
    this.mandateOptions,
    this.network,
    required this.requestThreeDSecure,
  });

  factory CardPaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    return CardPaymentMethodOptions(
      installments: json['installments'],
      mandateOptions: json['mandate_options'],
      network: json['network'],
      requestThreeDSecure: json['request_three_d_secure'] ?? 'automatic',
    );
  }
}
