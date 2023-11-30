import 'dart:convert';

import 'package:advisorapp/models/role.dart';

class Account {
  String accountcode;
  String accountname;
  String lastname;
  String worktitle;
  List<Role> rolewithemployer;
  String phonenumber;
  String mobilenumber;
  String workemail;
  String accountrole;
  String eincode;
  String naicscode;
  String companyname;
  String companydomainname;
  String typeofcompany;
  String companycategory;
  String companyaddress;
  String companyphonenumber;
  String accountpaymentinfo;
  bool isfirstlogin;
  String mandatorycolumnfilled;
  String invitationstatus;
  bool validlicense;
  String fancyname;

  Account({
    this.accountcode = '0',
    this.accountname = '',
    this.lastname = '',
    this.worktitle = '',
    required this.rolewithemployer,
    this.phonenumber = '',
    this.mobilenumber = '',
    this.workemail = '',
    this.accountrole = '',
    this.eincode = '',
    this.naicscode = '',
    this.companyname = '',
    this.companydomainname = '',
    this.typeofcompany = '',
    this.companycategory = '',
    this.companyaddress = '',
    this.companyphonenumber = '',
    this.accountpaymentinfo = '',
    this.isfirstlogin = true,
    this.mandatorycolumnfilled = '',
    this.invitationstatus = '',
    this.validlicense = false,
    this.fancyname = '',
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    List<dynamic> roleWithEmployerJson = json['rolewithemployer'] ?? '';
    List<Role> roles =
        roleWithEmployerJson.map((oJson) => Role.fromJson(oJson)).toList();

    return Account(
      accountcode: json['accountcode'],
      accountname: json['accountname'],
      lastname: json['lastname'] ?? '',
      worktitle: json['worktitle'],
      rolewithemployer: roles,
      phonenumber: json['phonenumber'],
      mobilenumber: json['mobilenumber'] ?? '',
      workemail: json['workemail'],
      accountrole: json['accountrole'],
      eincode: json['eincode'] ?? '',
      naicscode: json['naicscode'] ?? '',
      companyname: json['companyname'],
      companydomainname: json['companydomainname'],
      typeofcompany: json['typeofcompany'],
      companycategory: json['companycategory'],
      companyaddress: json['companyaddress'],
      companyphonenumber: json['companyphonenumber'],
      accountpaymentinfo: json['accountpaymentinfo'],
      isfirstlogin: (json['isfirstlogin'].toString().toUpperCase() == "TRUE")
          ? true
          : false,
      mandatorycolumnfilled: json['mandatorycolumnfilled'] ?? '',
      invitationstatus: json['invitationstatus'] ?? '',
      validlicense: (json['validlicense'].toString().toUpperCase() == "TRUE")
          ? true
          : false,
      fancyname: json['fancyname'] ?? '',
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['accountcode'] = accountcode;
    map["accountname"] = accountname;
    map["lastname"] = lastname;
    map['worktitle'] = worktitle;
    map['rolewithemployer'] =
        rolewithemployer.map((objRole) => objRole.toMap()).toList();

    map['mobilenumber'] = mobilenumber;
    map['phonenumber'] = phonenumber;
    map['workemail'] = workemail;
    map['accountrole'] = accountrole;
    map['eincode'] = eincode;
    map['naicscode'] = naicscode;
    map['companyname'] = companyname;
    map['companydomainname'] = companydomainname;
    map['typeofcompany'] = typeofcompany;
    map['companycategory'] = companycategory;
    map['companyaddress'] = companyaddress;
    map['companyphonenumber'] = companyphonenumber;
    map['accountpaymentinfo'] = accountpaymentinfo;

    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'accountcode': accountcode,
      'accountname': accountname,
      'lastname': lastname,
      'worktitle': worktitle,
      'rolewithemployer':
          rolewithemployer.map((objRole) => objRole.toMap()).toList(),
      'phonenumber': phonenumber,
      'mobilenumber': mobilenumber,
      'workemail': workemail,
      'accountrole': accountrole,
      'eincode': eincode,
      'naicscode': naicscode,
      'companyname': companyname,
      'companydomainname': companydomainname,
      'typeofcompany': typeofcompany,
      'companycategory': companycategory,
      'companyaddress': companyaddress,
      'companyphonenumber': companyphonenumber,
      'accountpaymentinfo': accountpaymentinfo,
      'isfirstlogin': isfirstlogin.toString()
    };
  }
}
