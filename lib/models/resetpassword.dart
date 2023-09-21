class ResetPassword {
  String id;
  String accountcode;
  String mypassword;
  String status;

  ResetPassword(
      {this.id = '0',
      this.accountcode = '0',
      this.mypassword = '0',
      this.status = '0'});
  factory ResetPassword.fromJson(Map<String, dynamic> json) {
    return ResetPassword(id: json['id'], accountcode: json['accountcode']
        // mypassword: json['mypassword']
        );
  }
}
