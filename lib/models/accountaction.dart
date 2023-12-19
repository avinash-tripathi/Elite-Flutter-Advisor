import 'package:advisorapp/models/actionlaunchpack.dart';

class AccountAction {
  String accountcode;
  String employercode;
  List<ActionLaunchPack> formfileupload;

  AccountAction(
      {required this.accountcode,
      required this.employercode,
      required this.formfileupload});

  factory AccountAction.fromJson(Map<String, dynamic> json) {
    List<dynamic> formsJson = json['formfileupload'];
    List<ActionLaunchPack> forms =
        formsJson.map((fJson) => ActionLaunchPack.fromJson(fJson)).toList();

    return AccountAction(
        accountcode: json['accountcode'],
        employercode: json['employercode'],
        formfileupload: forms);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['accountcode'] = accountcode;
    map['employercode'] = employercode;
    //map['formfileupload'] = formfileupload;
    map['formfileupload'] =
        formfileupload.map((form) => form.toJsonMap()).toList();

    return map;
  }
}
