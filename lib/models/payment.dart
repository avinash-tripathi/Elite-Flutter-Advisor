class Payment {
  String paymentcode;
  String paymentname;

  Payment({required this.paymentcode, required this.paymentname});
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentcode: json['paymentcode'],
      paymentname: json['paymentname'],
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['paymentcode'] = paymentcode;
    map["paymentname"] = paymentname;

    return map;
  }
}
