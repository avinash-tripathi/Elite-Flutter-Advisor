class ESignDocument {
  //String formcode;
  String esigndocumentid;
  String formdefinitionid;

  ESignDocument(
      {required this.esigndocumentid, required this.formdefinitionid});
  factory ESignDocument.fromJson(Map<String, dynamic> json) {
    return ESignDocument(
        esigndocumentid: json['esigndocumentid'],
        formdefinitionid: json['formdefinitionid']);
  }
  Map toMap() {
    var map = <String, dynamic>{};

    map["esigndocumentid"] = esigndocumentid;
    map["formdefinitionid"] = formdefinitionid;
    return map;
  }
}
