class Company {
  String companydomain;
  String companyname;
  String companytype;
  String companycategory;
  String companyaddress;
  String companyphoneno;
  String naicscode;
  Company({
    this.companydomain = '0',
    this.companyname = '0',
    this.companytype = '0',
    this.companycategory = '0',
    this.companyaddress = '0',
    this.companyphoneno = '0',
    this.naicscode = '0',
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        companydomain: json['companydomain'] ?? '',
        companyname: json['companyname'] ?? '',
        companytype: json['companytype'] ?? '',
        companycategory: json['companycategory'] ?? '',
        companyaddress: json['companyaddress'] ?? '',
        companyphoneno: json['companyphoneno'] ?? '',
        naicscode: json['naicscode'] ?? '');
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['companydomain'] = companydomain;
    map['companyname'] = companyname;
    map['companytype'] = companytype;
    map['companycategory'] = companycategory;
    map['companyaddress'] = companyaddress;
    map['companyphoneno'] = companyphoneno;
    map['naicscode'] = naicscode;
    return map;
  }
}
