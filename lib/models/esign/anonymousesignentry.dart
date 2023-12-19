import 'package:advisorapp/models/account.dart';

class AnonymousEsignEntry {
  String anonymouscode = '';
  String thirdpartyemail = '';
  String firstname = '';
  String lastname = '';
  String documentname = '';

  String accountcode = '';
  String workemail = '';
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
  Account? accountcodedata;

  AnonymousEsignEntry(
      {this.anonymouscode = '',
      this.thirdpartyemail = '',
      this.firstname = '',
      this.lastname = '',
      this.documentname = '',
      this.accountcode = '',
      this.workemail = '',
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
      this.accountcodedata});
  factory AnonymousEsignEntry.fromJson(Map<String, dynamic> json) {
    List<dynamic> accountJson = json['accountcodedata'] ?? '';
    List<Account> accounts =
        accountJson.map((oJson) => Account.fromJson(oJson)).toList();

    return AnonymousEsignEntry(
        anonymouscode: json['anonymouscode'] ?? '',
        thirdpartyemail: json['thirdpartyemail'] ?? '',
        firstname: json['firstname'] ?? '',
        lastname: json['lastname'] ?? '',
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
        accountcodedata: accounts[0]);
  }
}
