class AccountRole {
  String rolecode;
  String rolename;
  String roletype;

  AccountRole({
    this.rolecode = '0',
    this.rolename = '0',
    this.roletype = '0',
  });
  factory AccountRole.fromJson(Map<String, dynamic> json) {
    return AccountRole(
        rolecode: json['rolecode'],
        rolename: json['rolename'],
        roletype: json['roletype']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['rolecode'] = rolecode;
    map['rolename'] = rolename;
    map['roletype'] = roletype;

    return map;
  }
}
