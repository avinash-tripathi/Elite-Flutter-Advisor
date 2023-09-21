class Subscription {
  String subscriptioncode;
  String subscriptionname;
  double price;
  double period;
  String type;
  String createdby;
  String periodunit;

  Subscription({
    this.subscriptioncode = '0',
    this.subscriptionname = '',
    required this.price,
    required this.period,
    this.type = '',
    this.createdby = '',
    this.periodunit = '',
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptioncode: json['subscriptioncode'],
      subscriptionname: json['subscriptionname'],
      price: double.parse(json['price']),
      period: double.parse(json['period']),
      type: json['type'],
      createdby: json['createdby'],
      periodunit: json['periodunit'],
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['subscriptioncode'] = subscriptioncode;
    map["subscriptionname"] = subscriptionname;
    map["price"] = price;
    map['period'] = period;
    map['type'] = type;
    map['createdby'] = createdby;
    map['periodunit'] = periodunit;

    return map;
  }
}
