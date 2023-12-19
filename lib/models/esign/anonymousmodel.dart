import 'package:advisorapp/models/esign/anonymoususer.dart';

class AnonymousModel {
  String documentname = '';
  String accountcode = '';
  String esigndocumentid = '';
  String formdefinitionid = '';
  String esignstatus = '';
  String processid = '';
  String processdocumentid = '';
  String overallstatus = '';
  String startson = '';
  String expireson = '';
  String sendertaskurl = '';
  String receivertaskurl = '';
  String anonymouscode = '';
  String contentmimetype = '';
  String embedurl = '';
  String filebase64 = '';
  AnonymousUser? sender;
  AnonymousUser? recipient;
  AnonymousModel(
      {this.documentname = '',
      this.accountcode = '',
      this.esigndocumentid = '',
      this.formdefinitionid = '',
      this.esignstatus = '',
      this.processid = '',
      this.processdocumentid = '',
      this.overallstatus = '',
      this.startson = '',
      this.expireson = '',
      this.sendertaskurl = '',
      this.receivertaskurl = '',
      this.anonymouscode = '',
      this.contentmimetype = '',
      this.embedurl = '',
      this.filebase64 = '',
      this.sender,
      this.recipient});
  factory AnonymousModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> recipientJson = json['recipient'] ?? '';
    List<AnonymousUser> recipients =
        recipientJson.map((oJson) => AnonymousUser.fromJson(oJson)).toList();

    List<dynamic> senderJson = json['sender'] ?? '';
    List<AnonymousUser> senders =
        senderJson.map((oJson) => AnonymousUser.fromJson(oJson)).toList();

    /*   AnonymousUser recipient = AnonymousUser.fromJson(json['recipient']);
    AnonymousUser sender = AnonymousUser.fromJson(json['sender']); */

    return AnonymousModel(
        documentname: json['documentname'] ?? '',
        accountcode: json['accountcode'] ?? '',
        esigndocumentid: json['esigndocumentid'] ?? '',
        formdefinitionid: json['formdefinitionid'] ?? '',
        esignstatus: json['esignstatus'] ?? '',
        processid: json['processid'] ?? '',
        processdocumentid: json['processdocumentid'] ?? '',
        overallstatus: json['overallstatus'] ?? '',
        startson: json['startson'] ?? '',
        expireson: json['expireson'] ?? '',
        sendertaskurl: json['sendertaskurl'] ?? '',
        receivertaskurl: json['receivertaskurl'] ?? '',
        anonymouscode: json['anonymouscode'] ?? '',
        contentmimetype: json['contentmimetype'] ?? '',
        embedurl: json['embedurl'] ?? '',
        filebase64: json['filebase64'] ?? '',
        sender: senders[0],
        recipient: recipients[0]);
  }
  Map toMap() {
    var map = <String, dynamic>{};

    map["documentname"] = documentname;

    map["accountcode"] = accountcode;
    map["esigndocumentid"] = esigndocumentid;
    map["formdefinitionid"] = formdefinitionid;

    map["esignstatus"] = esignstatus;
    map["processid"] = processid;
    map["processdocumentid"] = processdocumentid;
    map["overallstatus"] = overallstatus;
    map["startson"] = startson;
    map["expireson"] = expireson;

    map["sendertaskurl"] = sendertaskurl;
    map["receivertaskurl"] = receivertaskurl;
    map["anonymouscode"] = anonymouscode;
    map["contentmimetype"] = contentmimetype;
    map["embedurl"] = embedurl;
    map["filebase64"] = filebase64;
    map["sender"] = sender != null ? [sender!.toMap()] : null;
    map["recipient"] = recipient != null ? [recipient!.toMap()] : null;

    return map;
  }
}
