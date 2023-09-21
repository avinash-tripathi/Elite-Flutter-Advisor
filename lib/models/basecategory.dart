class BaseCompanyCategory {
  String basecategorycode;
  String basecategoryname;

  BaseCompanyCategory(
      {required this.basecategorycode, required this.basecategoryname});
  factory BaseCompanyCategory.fromJson(Map<String, dynamic> json) {
    return BaseCompanyCategory(
        basecategorycode: json['basecategorycode'],
        basecategoryname: json['basecategoryname']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['basecategorycode'] = basecategorycode;
    map["basecategoryname"] = basecategoryname;
    return map;
  }
}
