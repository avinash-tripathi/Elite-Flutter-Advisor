import 'package:advisorapp/models/account.dart';

class Vote {
  String votecode = '';
  String ideacode = '';
  bool voted = false;
  String votedby = '';
  Account? votedbydata;
  Vote(
      {this.votecode = '0',
      this.ideacode = '0',
      this.voted = false,
      this.votedby = '',
      this.votedbydata});

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      votecode: json['votecode'],
      ideacode: json['ideacode'],
      voted: (json['voted'].toString().toUpperCase() == "TRUE") ? true : false,
      votedby: json['votedby'],
      votedbydata: (json['votedbydata'] != null)
          ? Account.fromJson(json['votedbydata'][0])
          : null,
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['ideacode'] = ideacode;
    map['voted'] = voted;
    map['votedby'] = votedby;
    return map;
  }

  int getTotalVotesForIdea(List<Vote> votes, String ideacode) {
    int totalVotes = 0;
    for (var vote in votes) {
      if (vote.ideacode == ideacode && vote.voted) {
        totalVotes++;
      }
    }
    return totalVotes;
  }
}
