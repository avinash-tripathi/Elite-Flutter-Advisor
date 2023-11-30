import 'package:advisorapp/models/account.dart';

class Idea {
  String ideacode = '';
  String topic = '';
  String topicdescription = '';
  String createdby = '';
  String filebase64 = '';
  String fileextension = '';
  String ideafilename = 'browse to upload file';
  Account? createdbydata;
  Idea(
      {this.ideacode = '0',
      this.topic = '',
      this.topicdescription = '',
      this.createdby = '',
      required this.filebase64,
      required this.fileextension,
      required this.ideafilename,
      this.createdbydata});

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      ideacode: json['ideacode'],
      topic: json['topic'],
      topicdescription: json['topicdescription'],
      createdby: json['createdby'],
      filebase64: '',
      fileextension: json['fileextension'],
      ideafilename: json['ideafilename'],
      createdbydata: (json['createdbydata'] != null)
          ? Account.fromJson(json['createdbydata'][0])
          : null,
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['ideacode'] = ideacode;
    map['topic'] = topic;
    map['topicdescription'] = topicdescription;
    map['createdby'] = createdby;
    map['filebase64'] = filebase64;
    map['fileextension'] = fileextension;
    map['ideafilename'] = ideafilename;
    return map;
  }
}
