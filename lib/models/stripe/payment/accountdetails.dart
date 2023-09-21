class AmountDetails {
  final Map<String, dynamic> tip;

  AmountDetails(this.tip);

  factory AmountDetails.fromJson(Map<String, dynamic> json) {
    return AmountDetails(json['tip'] ?? {});
  }
}
