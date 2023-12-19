class AnonymousUser {
  String email = '';
  String firstname = '';
  String lastname = '';
  String company = '';

  AnonymousUser(
      {required this.email,
      required this.firstname,
      required this.lastname,
      required this.company});
  factory AnonymousUser.fromJson(Map<String, dynamic> json) {
    return AnonymousUser(
      email: json['email'] ?? '',
      firstname: json['firstName'] ?? '',
      lastname: json['lastName'] ?? '',
      company: json['company'] ?? '',
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};

    map["email"] = email;
    map["firstName"] = firstname;
    map["lastName"] = lastname;
    map["company"] = company;
    return map;
  }
}
