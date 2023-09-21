class CompanyCategory {
  String categorycode;
  String categoryname;
  String basecategorycode;

  CompanyCategory(
      {required this.categorycode,
      required this.categoryname,
      required this.basecategorycode});
  factory CompanyCategory.fromJson(Map<String, dynamic> json) {
    return CompanyCategory(
        categorycode: json['categorycode'],
        categoryname: json['categoryname'],
        basecategorycode: json['basecategorycode']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['categorycode'] = categorycode;
    map["categoryname"] = categoryname;
    return map;
  }
}
