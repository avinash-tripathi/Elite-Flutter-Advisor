import 'dart:convert';
import 'dart:math';
import 'package:advisorapp/checkout/constants.dart';
import 'package:advisorapp/models/admin/paymentmethod/paymentmethod.dart';
import 'package:advisorapp/models/admin/setupIntent/inputsetupintent.dart';
import 'package:advisorapp/models/stripe/customer.dart';
import 'package:advisorapp/models/stripe/payment/paymentintent.dart';
import 'package:advisorapp/models/stripe/stripesession.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class StripeService {
  static const stipeserviceURL = 'https://api.stripe.com/v1/';
  static const serviceURL = webApiserviceURL;

  Future<Customer> createCustomer(accountcode, desc, email, name) async {
    try {
      // String secretKey = secretKey;

      Uri uri = Uri.parse("${stipeserviceURL}customers");
      final Map<String, String> body = {
        'description': desc,
        'email': email,
        'name': name,
        'metadata[accountcode]': accountcode
      };

      var objResponse = await http.Client().post(uri,
          headers: <String, String>{
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
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
      Customer retObject = Customer.fromJson(jsonDecode(objResponse.body));
      return retObject;
    } catch (e) {
      rethrow;
    }
  }

  Future<StripePaymentIntent> createPaymentIntent() async {
    try {
      // String secretKey = secretKey;

      Uri uri = Uri.parse("${stipeserviceURL}payment_intents ");
      final Map<String, String> body = {
        'amount': '99',
        'currency': 'usd',
        'payment_method_types[]': 'card'
      };

      var objResponse = await http.Client().post(uri,
          headers: <String, String>{
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body);
      StripePaymentIntent retObject =
          StripePaymentIntent.fromJson(jsonDecode(objResponse.body));
      return retObject;
    } catch (e) {
      rethrow;
    }
  }

  Future<StripeSession?> createCheckOutSession(
      quantity, createdby, subscriptioncode) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}StripeCheckout/CreateCheckoutSession?quantity=$quantity&createdby=$createdby&subscriptioncode=$subscriptioncode");
      /* Uri uri = Uri.parse(
          "https://localhost:44395/create-checkout-session?accountcode=$accountcode"); */
      var objResponse = await http.Client().get(
        uri,
      );
      if (objResponse.statusCode == 200) {
        /* final locationHeader = objResponse.headers['Location'];
        if (locationHeader != null) {
          // Make a GET request to the new URL
          final redirectedResponse = await http.get(Uri.parse(locationHeader));

          // Handle the redirected response as needed
          return redirectedResponse.body;
        } */
        return StripeSession.fromJson(jsonDecode(objResponse.body));
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createSetupIntentCheckOutSession(InputSetupIntent obj) async {
    try {
      Uri uri =
          Uri.parse("${serviceURL}Stripe/CreateCustomerSetupIntentViaSession");

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
          body: json.encode(obj.toJson()));
      if (objResponse.statusCode == 200) {
        return objResponse.body.toString();
      } else {
        return '';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCustomerPaymentMethod(String accountcode) async {
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
        return objResponse.body.toString();
      } else {
        return '';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSessionStatus(sessionid) async {
    try {
      String username = secretKey;
      String password = '';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Uri uri = Uri.parse(
          "${serviceURL}StripeCheckout/FetchSessionService?sessionid=$sessionid");
      /* Uri uri = Uri.parse(
          "https://localhost:44395/create-checkout-session?accountcode=$accountcode"); */
      var objResponse = await http.Client().get(
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        uri,
      );
      if (objResponse.statusCode == 200) {
        return objResponse.body;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentMethod> createPaymentMethod(
      accountcode, PaymentMethod obj) async {
    try {
      Uri uri = Uri.parse(
          "${serviceURL}Advisor/InsertAdvisorStripeAccountPaymentMethod");
      var body = json.encode(
          {"accountcode": accountcode, "paymentmethod": jsonEncode(obj)});
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
        PaymentMethod objectR =
            PaymentMethod.fromJson(jsonDecode(jsonDecode(objResponse.body)));
        return objectR;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      return obj;
    }
  }

  Future<PaymentMethod> readPaymentMethod(accountcode) async {
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

      if (objResponse.statusCode == 200) {
        //List<AdvisorInvite> data = json.decode(objResponse.body);
        PaymentMethod objectR =
            PaymentMethod.fromJson(jsonDecode(jsonDecode(objResponse.body)));
        return objectR;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data');
    }
  }
}
