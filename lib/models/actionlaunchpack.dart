class ActionLaunchPack {
  String launchcode;
  String formcode = '';
  String formname = '';
  bool launchpack = false;
  bool renewalpack = false;
  bool isprivate = true;
  String filebase64 = '';
  String fileextension = '';
  String filename = 'browse to upload file';
  String duedate = '';
  String itemstatus = '';
  String attachmenttype = '';

  ActionLaunchPack(
      {this.launchcode = '',
      required this.formcode,
      required this.formname,
      this.launchpack = false,
      this.renewalpack = false,
      this.isprivate = true,
      required this.filebase64,
      required this.fileextension,
      required this.filename,
      this.duedate = '',
      this.itemstatus = '',
      this.attachmenttype = ''});
  factory ActionLaunchPack.fromJson(Map<String, dynamic> json) {
    return ActionLaunchPack(
      launchcode: json['launchcode'] ?? '',
      formcode: json['formcode'] ?? '',
      formname: json['formname'] ?? '',
      launchpack: json['launchpack'] ?? false,
      renewalpack: json['renewalpack'] ?? false,
      isprivate: json['isprivate'] ?? true,
      filebase64: '',
      fileextension: json['fileextension'] ?? '',
      filename: json['formfilename'] ?? '',
      duedate: (json['duedate'] == null) ? '1900-01-01' : json['duedate'],
      itemstatus: (json['itemstatus'] == null || json['itemstatus'] == '')
          ? 'inactive'
          : json['itemstatus'],
      attachmenttype:
          (json['attachmenttype'] == null || json['attachmenttype'] == '')
              ? 'file'
              : json['attachmenttype'],
    );
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map['formcode'] = formcode;
    map['formname'] = formname;
    map['launchpack'] = launchpack;
    map['renewalpack'] = renewalpack;
    map['isprivate'] = isprivate;
    map['filebase64'] = filebase64;
    map['fileextension'] = fileextension;
    map['itemstatus'] = itemstatus;
    map['formfilename'] = filename;
    map['attachmenttype'] = attachmenttype;
    return map;
  }
}
