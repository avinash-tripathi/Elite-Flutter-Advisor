import 'dart:convert';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/paymentmethod/attachedpaymentmethod.dart';
import 'package:advisorapp/models/admin/paymentmethod/invoice.dart';
import 'package:advisorapp/models/admin/subscription.dart';
import 'package:advisorapp/models/admin/subscriptionLicense.dart';
import 'package:http/http.dart' as http;

class AdminService {
  static const serviceURL = webApiserviceURL;

  Future<dynamic> updateStatus(accountcode, userstatus) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UpdateAdvisorUpdateUserStatus");
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
              .encode({"accountcode": accountcode, "userstatus": userstatus}));

      if (objResponse.statusCode == 200) {
        return jsonDecode(objResponse.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> updateRole(accountcode, accountrole) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/UpdateAdvisorUpdateRole");
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
              {"accountcode": accountcode, "accountrole": accountrole}));

      if (objResponse.statusCode == 200) {
        return jsonDecode(objResponse.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> deleteAttachedPaymentMethod(
      accountcode, paymentmethodid) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/DeleteAdvisorStripeAccountPaymentMethod");
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
            "metadata": {"accountcode": accountcode},
            "userPaymentMethodDetail": {"id": paymentmethodid}
          }));

      if (objResponse.statusCode == 200) {
        return jsonDecode(objResponse.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<AttachedPaymentMethod?> readAttachedPaymentMethod(accountcode) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/ReadAdvisorStripeAccountPaymentMethod");
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
        AttachedPaymentMethod retObj =
            AttachedPaymentMethod.fromJson(jsonDecode(objResponse.body)[0]);
        return retObj;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return null; /* AttachedPaymentMethod(
          customerdata: AttachedCustomerData(
              id: '',
              object: '',
              address: '',
              currency: '',
              description: '',
              email: '',
              name: '',
              phone: ''),
          paymentmethoddata: AttachedPaymentMethodData(
            billingDetails: BillingDetails(email: '', name: ''),
            id: '',
            object: '',
            card: CardDetails(
                brand: '',
                checks: Checks(addressPostalCodeCheck: '', cvcCheck: ''),
                country: '',
                expMonth: 01,
                expYear: 2001,
                fingerprint: '',
                funding: '',
                last4: '0000',
                networks: Networks(available: []),
                threeDSecureUsage: ThreeDSecureUsage(supported: false)),
            created: 0,
            customer: '',
            metadata: {},
          )); */
    }
  }

  Future<List<Invoice>> readInvoices(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/AdvisorGenerateInvoice");
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

      List<Invoice> list = [];
      if (objResponse.statusCode == 200) {
        //List<AdvisorInvite> data = json.decode(objResponse.body);
        list = (jsonDecode(objResponse.body) as List)
            .map((slist) => Invoice.fromJson(slist))
            .toList();

        return list;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Subscription>> readSubscription() async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorAdminSubscriptionM");
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
      List<Subscription> list = [];
      if (objResponse.statusCode == 200) {
        //List<AdvisorInvite> data = json.decode(objResponse.body);
        list = (jsonDecode(objResponse.body) as List)
            .map((slist) => Subscription.fromJson(slist))
            .toList();

        return list;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SubscriptionLicense>> readSubscriptionLicense(accountcode) async {
    try {
      Uri uri = Uri.parse("${serviceURL}Advisor/ReadAdvisorGetLicensedUser");
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
      List<SubscriptionLicense> list = [];
      if (objResponse.statusCode == 200) {
        //List<AdvisorInvite> data = json.decode(objResponse.body);
        list = (jsonDecode(objResponse.body) as List)
            .map((slist) => SubscriptionLicense.fromJson(slist))
            .toList();

        return list;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return [];
    }
  }
}
