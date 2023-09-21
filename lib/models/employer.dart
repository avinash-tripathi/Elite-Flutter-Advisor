import 'package:advisorapp/models/partner.dart';

class Employer {
  String employercode;
  String accountcode;
  String companydomainname;
  String companyname;
  String companytype;
  String companyaddress;
  String companyphonenumber;
  String planeffectivedate;
  String contractsignatoryemail;
  String daytodaycontactemail;
  String decisionmakeremail;
  String contractsignatoryemailinvitationstatus;
  String daytodaycontactemailinvitationstatus;
  String decisionmakeremailinvitationstatus;
  String launchstatus;
  List<Partner> partners;

  Employer(
      {this.employercode = '0',
      this.accountcode = '0',
      this.companydomainname = '',
      this.companyname = '',
      this.companytype = '',
      this.companyaddress = '',
      this.companyphonenumber = '',
      this.planeffectivedate = '',
      this.contractsignatoryemail = '',
      this.daytodaycontactemail = '',
      this.decisionmakeremail = '',
      this.contractsignatoryemailinvitationstatus = '',
      this.daytodaycontactemailinvitationstatus = '',
      this.decisionmakeremailinvitationstatus = '',
      this.launchstatus = '',
      required this.partners});

  factory Employer.fromJson(Map<String, dynamic> json) {
    List<dynamic> partnersJson = json['partners'];
    List<Partner> partners = partnersJson
        .map((partnerJson) => Partner.fromJson(partnerJson))
        .toList();

    return Employer(
      accountcode: json['accountcode'] ?? '',
      employercode: json['employercode'] ?? '',
      companydomainname: json['employerdomainname'] ?? '',
      companyname: json['employerlegalname'] ?? '',
      companytype: json['typeofcompany'] ?? '',
      companyaddress: json['address'] ?? '',
      companyphonenumber: json['phonenumber'] ?? '',
      planeffectivedate: json['planeffectivedate'] ?? '',
      contractsignatoryemail: json['contractsignatoryemail'] ?? '',
      daytodaycontactemail: json['daytodaycontactemail'] ?? '',
      decisionmakeremail: json['decisionmakeremail'] ?? '',
      contractsignatoryemailinvitationstatus:
          json['contractsignatoryemailinvitationstatus'] ?? '',
      daytodaycontactemailinvitationstatus:
          json['daytodaycontactemailinvitationstatus'] ?? '',
      decisionmakeremailinvitationstatus:
          json['decisionmakeremailinvitationstatus'] ?? '',
      launchstatus: json['isLaunchPackInitiated'] ?? '',
      partners: partners,
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['accountcode'] = accountcode;
    map['employercode'] = employercode;
    map['employerdomainname'] = companydomainname;
    map['employerlegalname'] = companyname;
    map['typeofcompany'] = companytype;
    map['address'] = companyaddress;
    map['phonenumber'] = companyphonenumber;
    map['planeffectivedate'] = planeffectivedate;
    map['contractsignatoryemail'] = contractsignatoryemail;
    map['daytodaycontactemail'] = daytodaycontactemail;
    map['decisionmakeremail'] = decisionmakeremail;
    map['partners'] = partners.map((partner) => partner.toMap()).toList();

    return map;
  }
}
