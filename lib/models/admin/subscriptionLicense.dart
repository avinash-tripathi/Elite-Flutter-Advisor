import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/role.dart';

/* class SubscriptionLicense {
  String paymentcode;
  String accountcode;
  Account accountdata;
  String paymentdate;
  double paymentamount;
  String subscriptioncode;
  Subscription subscriptiondata;
  int licensecount;
  String subscriptionstartdate;
  String subscriptionenddate;
  String coworkeraccountcode;
  List<Account> coworkeraccountdata;

  SubscriptionLicense(
      {this.paymentcode = '0',
      this.accountcode = '',
      required this.accountdata,
      required this.paymentdate,
      this.paymentamount = 0,
      this.subscriptioncode = '',
      required this.subscriptiondata,
      this.licensecount = 0,
      this.subscriptionstartdate = '',
      this.subscriptionenddate = '',
      this.coworkeraccountcode = '',
      required this.coworkeraccountdata});

  factory SubscriptionLicense.fromJson(Map<String, dynamic> json) {
    List<dynamic> coworkersJson = json['coworkeraccountdata'];
    List<Account> accounts =
        coworkersJson.map((oJson) => Account.fromJson(oJson)).toList();

    return SubscriptionLicense(
      paymentcode: json['paymentcode'],
      accountcode: json['accountcode'],
      accountdata: Account.fromJson(json['accountdata'][0]),
      paymentdate: json['paymentdate'],
      paymentamount: double.parse(json['paymentamount']),
      subscriptioncode: json['subscriptioncode'],
      subscriptiondata: Subscription.fromJson(json['subscriptiondata'][0]),
      licensecount: int.parse(json['licensecount']),
      subscriptionstartdate: json['subscriptionstartdate'],
      subscriptionenddate: json['subscriptionenddate'],
      coworkeraccountcode: json['coworkeraccountcode'],
      coworkeraccountdata: accounts,
    );
  }
} */
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
