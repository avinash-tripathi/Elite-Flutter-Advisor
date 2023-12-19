class ESignEmbeddedResponse {
  String url;
  String formDefinitionId;

  ESignEmbeddedResponse({required this.url, required this.formDefinitionId});
  factory ESignEmbeddedResponse.fromJson(Map<String, dynamic> json) {
    return ESignEmbeddedResponse(
        url: json['url'], formDefinitionId: json['formDefinitionId']);
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map["url"] = url;
    map["formDefinitionId"] = formDefinitionId;
    return map;
  }
}
