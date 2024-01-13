class AdminUser {
  String usercode;
  String firstname;
  String lastname;
  String username;
  String emailid;
  String rolecode;
  String rolename;

  AdminUser({
    this.usercode = '0',
    this.firstname = '',
    this.lastname = '',
    this.username = '',
    this.emailid = '',
    this.rolecode = '',
    this.rolename = '',
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      usercode: json['usercode'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      emailid: json['emailid'],
      rolecode: json['rolecode'],
      rolename: json['rolename'],
    );
  }
}
