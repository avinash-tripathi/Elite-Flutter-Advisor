import 'dart:convert';
import 'package:advisorapp/constants.dart';
import 'package:http/http.dart' as http;

class EsignService {
  static const serviceURL = webApiserviceURL;

  Future<dynamic> downloadEsignDocument(documentid) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/DownloadESignDocumentAsync?documentId=$documentid");
      var objResponse = await http.Client().get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Charset': 'utf-8',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      );

      if (objResponse.statusCode == 200) {
        return jsonDecode(objResponse.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> generateESignEmbeddedURL(documentid, formdefinitionid) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/GenerateESignEmbededURL?documentId=$documentid&formDefinitionID=$formdefinitionid");
      var objResponse = await http.Client().get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Charset': 'utf-8',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      );

      if (objResponse.statusCode == 200) {
        return jsonDecode(objResponse.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }
}
