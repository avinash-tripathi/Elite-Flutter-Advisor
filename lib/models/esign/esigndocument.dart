class ESignDocument {
  //String formcode;
  String esigndocumentid = '';
  String formdefinitionid = '';
  String? processid = '';
  String? processdocumentId = '';

  ESignDocument(
      {required this.esigndocumentid,
      required this.formdefinitionid,
      this.processid,
      this.processdocumentId});
  factory ESignDocument.fromJson(Map<String, dynamic> json) {
    return ESignDocument(
        esigndocumentid: json['esigndocumentid'],
        formdefinitionid: json['formdefinitionid'],
        processid: json['processid'] ?? '',
        processdocumentId: json['processdocumentId'] ?? '');
  }
  Map toMap() {
    var map = <String, dynamic>{};

    map["esigndocumentid"] = esigndocumentid;
    map["formdefinitionid"] = formdefinitionid;
    return map;
  }
}
