class ActiveWorkSpace {
  String accountcode;
  String accountname;
  String employerlegalname;
  String employercode;
  String formcode;
  String formname;
  String fileextension;

  ActiveWorkSpace({
    this.accountcode = '0',
    this.accountname = '0',
    this.employerlegalname = '0',
    this.employercode = '0',
    this.formcode = '0',
    this.formname = '0',
    this.fileextension = '0',
  });
  factory ActiveWorkSpace.fromJson(Map<String, dynamic> json) {
    return ActiveWorkSpace(
        accountcode: json['accountcode'],
        accountname: json['accountname'],
        employerlegalname: json['employerlegalname'],
        employercode: json['employercode'],
        formcode: json['formcode'],
        formname: json['formname'],
        fileextension: json['fileextension']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['accountcode'] = accountcode;
    map['accountname'] = accountname;
    map['employerlegalname'] = employerlegalname;

    map['employercode'] = employercode;
    map['formcode'] = formcode;
    map['formname'] = formname;
    map['fileextension'] = fileextension;

    return map;
  }
}
