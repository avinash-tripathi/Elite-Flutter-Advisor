class InputSetupIntent {
  String customerid;
  String name;
  String email;
  Map<String, dynamic> metadata;
  String description;

  InputSetupIntent({
    required this.customerid,
    required this.name,
    required this.email,
    required this.metadata,
    required this.description,
  });

  factory InputSetupIntent.fromJson(Map<String, dynamic> json) {
    return InputSetupIntent(
      customerid: json['customerid'],
      name: json['name'],
      email: json['email'],
      metadata: json['metadata'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerid': customerid,
      'name': name,
      'email': email,
      'metadata': metadata,
      'description': description,
    };
  }
}
