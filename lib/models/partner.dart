class Partner {
  String partnercode;
  String accountcode;
  String partnerdomainname;
  String companyname;
  String companycategory;
  String companyaddress;
  String companyphonenumber;
  String salesleademail;
  String contractsignatoryemail;
  String accountleademail;
  String salesleademailinvitationstatus;
  String contractsignatoryemailinvitationstatus;
  String accountleademailinvitationstatus;

  Partner(
      {this.partnercode = '0',
      this.accountcode = '0',
      this.partnerdomainname = '',
      this.companyname = '',
      this.companycategory = '',
      this.companyaddress = '',
      this.companyphonenumber = '',
      this.salesleademail = '',
      this.contractsignatoryemail = '',
      this.accountleademail = '',
      this.salesleademailinvitationstatus = '',
      this.contractsignatoryemailinvitationstatus = '',
      this.accountleademailinvitationstatus = ''});

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
        accountcode: json['accountcode'] ?? '',
        partnercode: json['partnercode'],
        partnerdomainname: json['partnerdomainname'] ?? '',
        companyname: json['partnercompanyname'] ?? '',
        companycategory: json['partnercompanycategory'] ?? '',
        companyaddress: json['address'] ?? '',
        companyphonenumber: json['phonenumber'] ?? '',
        salesleademail: json['salesleademail'] ?? '',
        contractsignatoryemail: json['contractsignatoryemail'] ?? '',
        accountleademail: json['accountleademail'] ?? '',
        salesleademailinvitationstatus:
            json['salesleademailinvitationstatus'] ?? 'Send',
        contractsignatoryemailinvitationstatus:
            json['contractsignatoryemailinvitationstatus'] ?? 'Send',
        accountleademailinvitationstatus:
            json['accountleademailinvitationstatus'] ?? 'Send');
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['accountcode'] = accountcode;
    map['partnercode'] = partnercode;
    map['partnerdomainname'] = partnerdomainname;
    map['partnercompanyname'] = companyname;
    map['partnercompanycategory'] = companycategory;
    map['address'] = companyaddress;
    map['phonenumber'] = companyphonenumber;
    map['salesleademail'] = salesleademail;
    map['contractsignatoryemail'] = contractsignatoryemail;
    map['accountleademail'] = accountleademail;

    map['salesleademailinvitationstatus'] = salesleademailinvitationstatus;
    map['contractsignatoryemailinvitationstatus'] =
        contractsignatoryemailinvitationstatus;
    map['accountleademailinvitationstatus'] = accountleademailinvitationstatus;

    return map;
  }
}
