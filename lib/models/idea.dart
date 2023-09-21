import 'package:advisorapp/models/account.dart';

class Idea {
  String ideacode = '';
  String topic = '';
  String createdby = '';
  Account? createdbydata;
  Idea(
      {this.ideacode = '0',
      this.topic = '',
      this.createdby = '',
      this.createdbydata});

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      ideacode: json['ideacode'],
      topic: json['topic'],
      createdby: json['createdby'],
      createdbydata: (json['createdbydata'] != null)
          ? Account.fromJson(json['createdbydata'][0])
          : null,
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['ideacode'] = ideacode;
    map['topic'] = topic;
    map['createdby'] = createdby;
    return map;
  }
}
