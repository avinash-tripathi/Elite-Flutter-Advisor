import 'package:advisorapp/models/esign/esigndocument.dart';

class ActionLaunchPack {
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
  String contentmimetype = '';
  ESignDocument esigndocumentdata;
  bool newAction = false;

  ActionLaunchPack(
      {required this.formcode,
      required this.formname,
      this.launchpack = false,
      this.renewalpack = false,
      this.isprivate = true,
      required this.filebase64,
      required this.fileextension,
      required this.filename,
      this.duedate = '',
      this.itemstatus = '',
      this.attachmenttype = '',
      this.contentmimetype = '',
      required this.esigndocumentdata,
      this.newAction = false});
  factory ActionLaunchPack.fromJson(Map<String, dynamic> json) {
    List<dynamic>? roleWithEmployerJson = json['esigndocumentdata'];
    List<ESignDocument>? esigndocument = roleWithEmployerJson == null
        ? []
        : (roleWithEmployerJson)
            .map((oJson) => ESignDocument.fromJson(oJson))
            .toList();
    if (esigndocument.isEmpty) {
      esigndocument
          .add(ESignDocument(esigndocumentid: '', formdefinitionid: ''));
    }

    return ActionLaunchPack(
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
            ? 'active'
            : json['itemstatus'],
        attachmenttype:
            (json['attachmenttype'] == null || json['attachmenttype'] == '')
                ? 'none'
                : json['attachmenttype'],
        esigndocumentdata: esigndocument[0],
        newAction: (json['formcode'] == '' || json['formcode'] == null)
            ? true
            : false);
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
    map['contentmimetype'] = contentmimetype;

    return map;
  }

  Map toJsonMap() {
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
    map['contentmimetype'] = contentmimetype;
    map['esigndocumentdata'] = [esigndocumentdata.toMap()];

    return map;
  }
}
