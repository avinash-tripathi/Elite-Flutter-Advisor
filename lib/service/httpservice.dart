import 'dart:convert';
import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/activeworkspace.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/models/basecategory.dart';
import 'package:advisorapp/models/company.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/employerprofile.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/idea.dart';
//import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/mail/newactionitemmail.dart';
import 'package:advisorapp/models/naics.dart';
import 'package:advisorapp/models/payment.dart';
import 'package:advisorapp/models/resetpassword.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/models/vote.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;
import '../models/account.dart';
import '../models/partner.dart';

class HttpService {
  static const serviceURL = webApiserviceURL;

//Login
  setLoggedInCredential(Account customerInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('customerInfo') != null) prefs.clear();
    await prefs.setString('customerInfo', jsonEncode(customerInfo.toJson()));
  }

  clearLoggedInCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('customerInfo') != null) prefs.clear();
  }

  List<Map<String, String>> getList(myString) {
    // Remove the brackets from the string
    String keyValueString = myString.substring(1, myString.length - 1);

// Split the string into an array of key-value pairs
    List<String> keyValueArray = keyValueString.split(',');

// Initialize an empty array to store the final result
    List<Map<String, String>> resultArray = [];

// Loop through each key-value pair and split it into an array of key and value
    for (String keyValue in keyValueArray) {
      List<String> keyValueSplit = keyValue.split(':');

      // Remove any whitespace characters from the key and value
      String key = keyValueSplit[0].trim();
      String value = keyValueSplit[1].trim();

      // Add the key-value pair to the result array
      resultArray.add({key: value});
    }
    return resultArray;
  }

  Future<String?> getLoggedInUserName() async {
    try {
      String? value = "";
      await getLoggedInCredential().then((loggedIn) {
        value = loggedIn.accountname;
        return value;
      });
      return value;
    } catch (error) {
      return "0";
    }
  }

  Future<String?> getLoggedInAccountCode() async {
    try {
      String? value = "";
      await getLoggedInCredential().then((loggedIn) {
        value = loggedIn.accountcode;
        return value;
      });
      return value;
    } catch (error) {
      return "0";
    }
  }

  setAccountInfo(Account account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if (prefs.getString('accountInfo') != null) prefs.clear();
    await prefs.setString('accountInfo', jsonEncode(account.toJson()));
  }

  Future<Account?> getAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('accountInfo');
    if (jsonString != null) {
      return Account.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }

  Future<Account> getLoggedInCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('customerInfo');
    return Account.fromJson(jsonDecode(jsonString!));
  }

  clearSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('customerInfo');
  }

//account
  Future<List<dynamic>> accountRole(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorRoleM");
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
          body: json.encode({"accountcode": accountcode, "status": "1"}));

      if (objResponse.statusCode == 200) {
        // Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        //List<DataRow> dataRows = [];
        Future<List<dynamic>> data = jsonDecode(objResponse.body);
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<AdvisorInvite>> readAdvisorInvite(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorInvitation");
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
          body: json.encode({"invitedby": accountcode}));
      List<AdvisorInvite> list = [];
      if (objResponse.statusCode == 200) {
        //List<AdvisorInvite> data = json.decode(objResponse.body);
        list = (jsonDecode(objResponse.body) as List)
            .map((slist) => AdvisorInvite.fromJson(slist))
            .toList();

        return list;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Naics>> getNaicsCodesg() async {
    try {
      List<Naics> returnList = [];
      var objResponse = await http.Client().get(
        Uri.parse("${serviceURL}Advisor/ReadAdvisorNaicsMGET?status=1"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (objResponse.statusCode == 200) {
        returnList = (jsonDecode(objResponse.body) as List)
            .map((rJson) => Naics.fromJson(rJson))
            .toList();
      }
      return returnList;
    } catch (e) {
      return [];
    }
  }

  Future<List<Naics>> getNaicsCodes() async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorNaicsM");
      List<Naics> returnList = [];
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
          body: json.encode({"status": "1"}));
      if (objResponse.statusCode == 200) {
        returnList = (jsonDecode(objResponse.body) as List)
            .map((rJson) => Naics.fromJson(rJson))
            .toList();
        //List<DataRow> dataRows = [];
        //List data = json.decode(objResponse.body);
        return returnList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Account> getAccount(Account obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAccountM");

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
          body: json.encode({"accountcode": obj.accountcode, "status": "1"}));
      if (objResponse.statusCode == 200) {
        Account objectR = Account.fromJson(jsonDecode(objResponse.body)[0]);
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Account> addAccount(Account obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/InsertAdvisorAccountM");

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
        Account objectR = Account.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Account> updateAccount(Account obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UpdateAdvisorAccountM");
      var body = json.encode(obj.toMap());

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
          body: body);
      if (objResponse.statusCode == 200) {
        Account objectR = Account.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Partner> addPartner(Partner obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/InsertAdvisorAccountToPartners");

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
        Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        objectR.companyname = objectR.partnerdomainname;
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Partner> updatePartner(Partner obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/UpdateAdvisorAccountToPartners");

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
        Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<List<Partner>> fetchPartnerG(accountcode) async {
    try {
      List<Partner> partnerList = [];
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/ReadAdvisorAccountToPartnersGET?status=1&accountcode=$accountcode");
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
        partnerList = (jsonDecode(objResponse.body) as List)
            .map((partnerJson) => Partner.fromJson(partnerJson))
            .toList();

        return partnerList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Partner>> fetchPartner(accountcode) async {
    try {
      List<Partner> partnerList = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAccountToPartners");
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
          body: json.encode({"accountcode": accountcode, "status": "1"}));

      if (objResponse.statusCode == 200) {
        partnerList = (jsonDecode(objResponse.body) as List)
            .map((partnerJson) => Partner.fromJson(partnerJson))
            .toList();
        //List<DataRow> dataRows = [];
        //List data = json.decode(objResponse.body);
        return partnerList
            .where((element) => element.partnercode.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<AccountAction?> addAction(AccountAction obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/InsertAdvisorAccountActionItem");

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
        AccountAction objectR =
            AccountAction.fromJson(jsonDecode(objResponse.body));

        return objectR;
      }
      return null;
    } catch (e) {
      AccountAction objectR =
          AccountAction(accountcode: '', employercode: '', formfileupload: []);

      return objectR;
      //return null;
    }
  }

  Future<AccountAction?> updateAction(AccountAction obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/UpdateAdvisorAccountActionItem");

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
        AccountAction objectR =
            AccountAction.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return null;
    } catch (e) {
      AccountAction objectR =
          AccountAction(accountcode: '', employercode: '', formfileupload: []);

      return objectR;
      //return null;
    }
  }

  Future<List<LaunchPack>> readInitialLaunchPack(
      accountcode, employercode, type) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorLaunchPack");

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
          body: json.encode({
            "accountcode": accountcode,
            "employercode": employercode,
            "status": "1",
            "type": type
          }));
      if (objResponse.statusCode == 200) {
        // Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        //List<DataRow> dataRows = [];
        //List data = json.decode(objResponse.body);
        //return data;
        var oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => LaunchPack.fromJson(oJson))
            .toList();
        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ActionLaunchPack>> readLaunchPackAction(
      accountcode, employercode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAccountActionItem");

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
          body: json.encode({
            "accountcode": accountcode,
            "employercode": employercode,
            "status": "1"
          }));
      if (objResponse.statusCode == 200) {
        // Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        //List<DataRow> dataRows = [];
        //List data = json.decode(objResponse.body);
        //return data;

        var oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => ActionLaunchPack.fromJson(oJson))
            .toList();
        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> deleteLaunchPackAction(id) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/DeleteAdvisorAccountActionItem");

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
          body: json.encode({"id": id}));
      if (objResponse.statusCode == 200) {
        var data = objResponse.body;
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;

      //return null;
    }
  }

// Employer

  Future<EmployerProfile> uploadEmployerLogo(EmployerProfile obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UploadEmployerImageToBLOB");

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
        EmployerProfile objectR = obj; //jsonDecode(objResponse.body);
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Employer> addEmployer(Employer obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/InsertAdvisorAccountToEmployers");

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
        Employer objectR = Employer.fromJson(jsonDecode(objResponse.body));
        objectR.companyname = objectR.companydomainname;
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<Employer> updateEmployer(Employer obj) async {
    try {
      var body = json.encode(obj.toMap());

      Uri uri =
          Uri.parse("${serviceURL}Advisor/UpdateAdvisorAccountToEmployers");

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
          body: body);
      if (objResponse.statusCode == 200) {
        Employer objectR = Employer.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<String> updateLaunchStatus(
      accountcode, employercode, launchstatus) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UpdateLaunchStatus");

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
          body: json.encode({
            "accountcode": accountcode,
            "employercode": employercode,
            "launchstatus": launchstatus
          }));
      if (objResponse.statusCode == 200) {
        return objResponse.body.toString();
      }
      return "";
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<String> updateLaunchFormStatus(
      accountcode, employercode, formcode, formstatus, duedate) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UpdateLaunchFormStatus");

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
          body: json.encode({
            "accountcode": accountcode,
            "employercode": employercode,
            "formcode": formcode,
            "formstatus": formstatus,
            "duedate": duedate.toString().substring(0, 10)
          }));
      if (objResponse.statusCode == 200) {
        return objResponse.body.toString();
      }
      return "";
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<List<dynamic>> fetchEmployers(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAccountToEmployers");
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
          body: json.encode({"accountcode": accountcode, "status": "1"}));

      if (objResponse.statusCode == 200) {
        // Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        //List<DataRow> dataRows = [];
        List data = json.decode(objResponse.body);
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Company>> readCompaniesG() async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/ReadAdvisorEmployerMGET?status=1");
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
        List<Company> oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => Company.fromJson(oJson))
            .toList();
        // List data = json.decode(objResponse.body);
        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Company>> readCompanies() async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorEmployerM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        List<Company> oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => Company.fromJson(oJson))
            .toList();
        // List data = json.decode(objResponse.body);
        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Employer>> readEmployers(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAccountToEmployers");
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
          body: json.encode({"accountcode": accountcode, "status": "1"}));

      if (objResponse.statusCode == 200) {
        List<Employer> oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => Employer.fromJson(oJson))
            .toList();
        // List data = json.decode(objResponse.body);
        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Account>> readAccountsAssociatedtoEmployer(
      accountcode, employercode) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/GetAccountsAssociatedtoEmployer");
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
          body: json.encode(
              {"accountcode": accountcode, "employercode": employercode}));

      if (objResponse.statusCode == 200) {
        List<Account> oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => Account.fromJson(oJson))
            .toList();
        // List data = json.decode(objResponse.body);
        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Account?> verifyCredential(Auth obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/VerifyCredential");
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
          body: json.encode({
            "email": obj.email,
            "mypassword": obj.mypassword,
            "firebaseverified": obj.firebaseverified
          }));

      if (objResponse.statusCode == 200) {
        Account objectR = Account.fromJson(jsonDecode(objResponse.body)[0]);
        return objectR;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResetPassword> resetPassword(accountcode, password) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ResetPassword");
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
          body:
              json.encode({"accountcode": accountcode, "password": password}));

      if (objResponse.statusCode == 200) {
        // Partner objectR = Partner.fromJson(jsonDecode(objResponse.body));
        //List<DataRow> dataRows = [];
        ResetPassword objectR =
            ResetPassword.fromJson(jsonDecode(objResponse.body));

        return objectR;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LaunchPack> insertLaunchPackForEmployer(LaunchPack obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Advisor/InsertAdvisorLaunchPackForEmployer");

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
        LaunchPack objectR = LaunchPack.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<LaunchPack> initiateLaunchPack(LaunchPack obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/InsertAdvisorLaunchPack");

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
        LaunchPack objectR = LaunchPack.fromJson(jsonDecode(objResponse.body));
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<List<ActiveWorkSpace>> getWorkSpace(partnercode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/GetWorkSpace");
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
          body: json.encode({"partnercode": partnercode}));

      if (objResponse.statusCode == 200) {
        List<ActiveWorkSpace> partnerList =
            (jsonDecode(objResponse.body) as List)
                .map((partnerJson) => ActiveWorkSpace.fromJson(partnerJson))
                .toList();
        //List<DataRow> dataRows = [];
        //List data = json.decode(objResponse.body);
        return partnerList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getInitialLaunchPack(accountcode, employercode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/GetInitialLaunchPack");
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
          body: json.encode(
              {"accountcode": accountcode, "employercode": employercode}));

      if (objResponse.statusCode == 200) {
        var data = json.decode(objResponse.body);
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> updateActionItemFormStatus(launchcode, formstatus) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UpdateActionItemFormStatus");
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
          body: json
              .encode({"launchcode": launchcode, "formstatus": formstatus}));

      if (objResponse.statusCode == 200) {
        List data = json.decode(objResponse.body);
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> insertAdvisorInvitation(AdvisorInvite obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/InsertAdvisorInvitation");
      String? invitedby = await getLoggedInAccountCode();

      var body = json.encode({
        "invitedemail": obj.invitedemail,
        "invitedby": invitedby,
        "duration": obj.duration,
        "invitationtype": obj.invitationtype,
        "invitationstatus": obj.invitationstatus,
        "invitedpersonrole": obj.role.rolecode,
        "companycategorycode": obj.companycategory.categorycode
      });

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
          body: body);

      if (objResponse.statusCode == 200) {
        var data = json.decode(objResponse.body);
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downloadFile(formcode, fileextension) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/DownloadFilefromBLOB");
      var body =
          json.encode({"formcode": formcode, "fileextension": fileextension});

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
          body: body);

      if (objResponse.statusCode == 200) {
        String data = json.decode(objResponse.body);
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<NewActionItemMail> sendEmailForNewActionItem(
      NewActionItemMail obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/SendEmail");
      String? username = await getLoggedInUserName();
      obj.fromUserName = username!;
      obj.mailTemplateType = "MailTemplateTypeActionItemAssignment";
      obj.toRecipientEmailId = obj.toRecipientEmailId;
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
        var data = json.decode(objResponse.body);
        if (data[0]['response'] == true) {}
        return obj;
      } else {
        return obj;
        // if not sent correctly then obj.invitationstatus will be blank.
        //We will check if obj.invitationstatus='invited' then will be consider as sent.
        // throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AdvisorInvite> sendEmail(AdvisorInvite obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/SendEmail");
      String? username = await getLoggedInUserName();
      obj.invitationsendername = username!;

      // var body = json.encode(obj.toMap());

      /*  var body = json.encode({
        "ToRecipientEmailId": obj.invitedemail,
        "MailTemplateType": obj.invitationtype,
        "InvitationSenderName": username,
        "InvitationDaysLeft": obj.duration.toString(),
        "rolecode": obj.role.rolecode,
        "companycategory": obj.companycategory.categorycode
      }); */

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
        var data = json.decode(objResponse.body);
        if (data[0]['response'] == true) {
          obj.invitationstatus = 'invited';
          await insertAdvisorInvitation(obj);
        }
        return obj;
      } else {
        return obj;
        // if not sent correctly then obj.invitationstatus will be blank.
        //We will check if obj.invitationstatus='invited' then will be consider as sent.
        // throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CompanyCategory>> readCompanyCategory() async {
    try {
      List<CompanyCategory> lists = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorCompanyCategoryM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        lists = (jsonDecode(objResponse.body) as List)
            .map((listJson) => CompanyCategory.fromJson(listJson))
            .toList();

        return lists;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<BaseCompanyCategory>> readBaseCompanyCategory() async {
    try {
      List<BaseCompanyCategory> lists = [];
      Uri uri =
          Uri.parse("${serviceURL}Advisor/ReadAdvisorBaseCompanyCategoryM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        lists = (jsonDecode(objResponse.body) as List)
            .map((listJson) => BaseCompanyCategory.fromJson(listJson))
            .toList();

        return lists;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CompanyType>> readCompanyType() async {
    try {
      List<CompanyType> lists = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorCompanyTypeM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        lists = (jsonDecode(objResponse.body) as List)
            .map((listJson) => CompanyType.fromJson(listJson))
            .toList();

        return lists;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Payment>> readPayment() async {
    try {
      List<Payment> lists = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorPaymentM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        lists = (jsonDecode(objResponse.body) as List)
            .map((listJson) => Payment.fromJson(listJson))
            .toList();

        return lists;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Role>> readRoleG() async {
    try {
      List<Role> lists = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorRoleMGET?status=1");
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
        lists = (jsonDecode(objResponse.body) as List)
            .map((listJson) => Role.fromJson(listJson))
            .toList();

        return lists;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Role>> readRole() async {
    try {
      List<Role> lists = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorRoleM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        lists = (jsonDecode(objResponse.body) as List)
            .map((listJson) => Role.fromJson(listJson))
            .toList();

        return lists;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Employer>> readRooms(email) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/ReadAdvisorAccountToEmployersViaEmail");
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
          body: json.encode({"email": email}));

      if (objResponse.statusCode == 200) {
        List<Employer> oList = (jsonDecode(objResponse.body) as List)
            .map((oJson) => Employer.fromJson(oJson))
            .toList();

        return oList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Idea> addIdea(Idea obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/InsertAdvisorIdeaM");

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
        Idea objectR = Idea.fromJson(jsonDecode(objResponse.body));
        objectR.createdbydata = obj.createdbydata;
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<List<Idea>> readIdeas() async {
    try {
      List<Idea> dataList = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorIdeaM");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        dataList = (jsonDecode(objResponse.body) as List)
            .map((objectJson) => Idea.fromJson(objectJson))
            .toList();

        return dataList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Vote> voteOnIdea(Vote obj) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/InsertAdvisorVoteOnIdea");

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
        Vote objectR = Vote.fromJson(jsonDecode(objResponse.body));
        objectR.votedbydata = obj.votedbydata;
        return objectR;
      }
      return obj;
    } catch (e) {
      rethrow;

      //return null;
    }
  }

  Future<List<Vote>> readVotes() async {
    try {
      List<Vote> dataList = [];
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorVoteOnIdea");
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
          body: json.encode({"status": "1"}));

      if (objResponse.statusCode == 200) {
        dataList = (jsonDecode(objResponse.body) as List)
            .map((objectJson) => Vote.fromJson(objectJson))
            .toList();

        return dataList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
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
}
