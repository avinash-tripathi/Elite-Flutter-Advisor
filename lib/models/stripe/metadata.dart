class Metadata {
  String orderId;

  Metadata({required this.orderId});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      orderId: json['order_id'],
    );
  }
}
