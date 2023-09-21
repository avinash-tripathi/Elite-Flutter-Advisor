class CompanyType {
  String typecode;
  String typename;

  CompanyType({required this.typecode, required this.typename});
  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(typecode: json['typecode'], typename: json['typename']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['typecode'] = typecode;
    map["typename"] = typename;
    return map;
  }
}
