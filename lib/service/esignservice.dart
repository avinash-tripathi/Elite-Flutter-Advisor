import 'dart:convert';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/esign/anonymousesignentry.dart';
import 'package:advisorapp/models/esign/anonymousmodel.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
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

  Future<AnonymousModel?> getEsignProcessStatus(processid, isAnonymous) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/ESignatureProcessStatus?processId=$processid&isAnonymous=isAnonymous");
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
        AnonymousModel objectR =
            AnonymousModel.fromJson(jsonDecode(objResponse.body));

        return objectR;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ESignEmbeddedResponse> generateESignEmbeddedURL(
      documentid, formdefinitionid) async {
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
        ESignEmbeddedResponse objectR =
            ESignEmbeddedResponse.fromJson(jsonDecode(objResponse.body));

        return objectR;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return ESignEmbeddedResponse(formDefinitionId: '', url: '');
    }
  }

  Future<AnonymousModel> uploadAnonymousDocumentGenerateEmbedURL(
      AnonymousModel obj) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/UploadAnonymousDocumentGenerateEmbedURL");
      var objResponse = await http.Client().post(uri,
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
          body: json.encode(obj.toMap()));

      if (objResponse.statusCode == 200) {
        AnonymousModel retObj =
            AnonymousModel.fromJson(jsonDecode(objResponse.body));
        retObj.filebase64 = obj.filebase64;
        return retObj;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return obj;
    }
  }

  Future<List<AnonymousEsignEntry>?> getAnonymousList(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAnonymousEsigninfo");
      var objResponse = await http.Client().post(uri,
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
          body: json.encode({"accountcode": accountcode}));

      if (objResponse.statusCode == 200) {
        List<AnonymousEsignEntry> dataList =
            (jsonDecode(objResponse.body) as List)
                .map((partnerJson) => AnonymousEsignEntry.fromJson(partnerJson))
                .toList();
        return dataList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<AnonymousModel> startAnonESignatureProcess(AnonymousModel obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/StartAnonESignatureProcess");
      var objResponse = await http.Client().post(uri,
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
          body: json.encode(obj.toMap()));

      if (objResponse.statusCode == 200) {
        AnonymousModel retObj =
            AnonymousModel.fromJson(jsonDecode(objResponse.body));
        return retObj;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return obj;
    }
  }
}
