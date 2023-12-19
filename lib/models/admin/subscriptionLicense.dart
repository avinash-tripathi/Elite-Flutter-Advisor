import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/role.dart';

class SubscriptionLicense {
  String accountcode;
  Account accountdata;
  String accountownercode;
  Account accountownerdata;
  String joineddate;
  String nextrechargedate;
  String licensestatus;
  String accountstatus;
  Role? accountrole;

  SubscriptionLicense(
      {this.accountcode = '',
      required this.accountdata,
      this.accountownercode = '',
      required this.accountownerdata,
      required this.joineddate,
      required this.nextrechargedate,
      this.licensestatus = '',
      this.accountstatus = 'active'});

  factory SubscriptionLicense.fromJson(Map<String, dynamic> json) {
    return SubscriptionLicense(
      accountcode: json['accountcode'],
      accountdata: Account.fromJson(json['accountdata'][0]),
      accountownercode: json['accountownercode'],
      accountownerdata: Account.fromJson(json['accountownerdata'][0]),
      joineddate: json['joineddate'],
      nextrechargedate: json['nextrechargedate'],
      licensestatus: json['licensestatus'],
      accountstatus:
          (json['accountstatus'] == null) ? 'active' : json['accountstatus'],
    );
  }
}
