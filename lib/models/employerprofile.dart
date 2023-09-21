class EmployerProfile {
  String employerCode;
  String fileextension;
  String filebase64;
  String? companylogo;

  EmployerProfile(
      {required this.employerCode,
      required this.fileextension,
      required this.filebase64});

  Map toMap() {
    var map = <String, dynamic>{};
    map['employerCode'] = employerCode;
    map['fileextension'] = fileextension;
    map['filebase64'] = filebase64;
    return map;
  }
}
