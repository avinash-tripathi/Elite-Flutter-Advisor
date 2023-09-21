class Role {
  String rolecode;
  String rolename;
  String roletype;

  Role(
      {required this.rolecode, required this.rolename, required this.roletype});
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        rolecode: json['rolecode'],
        rolename: json['rolename'],
        roletype: json['roletype']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['rolecode'] = rolecode;
    map["rolename"] = rolename;
    map["roletype"] = roletype;
    return map;
  }
}
