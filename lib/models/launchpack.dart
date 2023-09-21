import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';

class LaunchPack {
  String launchcode;
  String accountcode;
  String employercode;
  String fromcode;
  String tocode;
  String fromname;
  String toname;
  String formcode;
  String formname;
  String formstatus;
  String duedate;
  String visibility;
  bool isprivate = false;
  String formdomainname;
  String employername;
  Account? fromcodedata;
  Account? tocodedata;
  String formcodewithextension;
  ActionLaunchPack? actionitemdata;
  String attachmenttype = 'file';

  LaunchPack(
      {this.launchcode = '0',
      this.accountcode = '0',
      this.employercode = '0',
      this.fromcode = '0',
      this.tocode = '0',
      this.fromname = '0',
      this.toname = '0',
      this.formcode = '0',
      this.formname = '0',
      this.formstatus = '0',
      this.duedate = '',
      this.visibility = '',
      isprivate = false,
      this.formdomainname = '0',
      this.employername = '',
      this.fromcodedata,
      this.tocodedata,
      this.formcodewithextension = '',
      this.actionitemdata,
      this.attachmenttype = 'file'});
  factory LaunchPack.fromJson(Map<String, dynamic> json) {
    return LaunchPack(
      launchcode: json['launchcode'],
      accountcode: json['accountcode'],
      employercode: json['employercode'],
      fromcode: json['fromcode'] ?? '',
      tocode: json['tocode'] ?? '',
      fromname: json['fromname'] ?? '',
      toname: json['toname'] ?? '',
      formcode: json['formcode'] ?? '',
      formname: json['formname'] ?? '',
      formstatus: json['formstatus'] ?? '',
      duedate: json['duedate'] ?? '',
      visibility: json['visibility'] ?? 'public',
      isprivate: json['isprivate'] ?? false,
      formdomainname: json['formdomainname'] ?? '',
      employername: json['employername'] ?? '',
      formcodewithextension: json['formcodewithextension'] ?? '',
      fromcodedata: (json['fromcodedata'] != null)
          ? Account.fromJson(json['fromcodedata'][0])
          : null,
      tocodedata: json['tocodedata'] != null
          ? Account.fromJson(json['tocodedata'][0])
          : null,
      actionitemdata: (json['actionitemdata'] != null)
          ? ActionLaunchPack.fromJson(json['actionitemdata'][0])
          : null,
      attachmenttype: json['attachmenttype'] ?? '',
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['launchcode'] = launchcode;
    map['accountcode'] = accountcode;
    map['employercode'] = employercode;
    map['fromcode'] = fromcode;
    map['tocode'] = tocode;
    map['formcode'] = formcode;
    map['duedate'] = duedate;
    map['formstatus'] = formstatus;
    map['visibility'] = visibility;

    return map;
  }
}
