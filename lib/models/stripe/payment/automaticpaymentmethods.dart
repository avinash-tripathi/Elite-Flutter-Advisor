class AutomaticPaymentMethods {
  final bool enabled;

  AutomaticPaymentMethods(this.enabled);

  factory AutomaticPaymentMethods.fromJson(Map<String, dynamic> json) {
    return AutomaticPaymentMethods(json['enabled'] ?? false);
  }
}
