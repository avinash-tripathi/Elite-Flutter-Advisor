// ignore: file_names

import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/service/authservice.dart';
import 'package:flutter/material.dart';

class MicrosoftAuthProvider extends ChangeNotifier {
  Config? _config;
  Config? get config => _config;
  set config(Config? obj) {
    _config = obj;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  set setMicrosoftFailure(Failure obj) {
    _failure = obj;
    notifyListeners();
  }

  Token? _microsoftToken;
  Token? get microsoftToken => _microsoftToken;

  set setMicrosoftToken(Token obj) {
    _microsoftToken = obj;
    notifyListeners();
  }

  String? _accessToken;
  String? get accessToken => _accessToken;

  set setaccessToken(String obj) {
    _accessToken = obj;
    notifyListeners();
  }

  /* Future<void> microsoftLogin() async {
    try {
      final navigatorKey = GlobalKey<NavigatorState>();
      final AadOAuth oauth = AadOAuth(Config(
          tenant: 'common',
          clientId: 'a5489f64-06e7-4dfa-920c-196436ea8c46',
          scope: 'User.Read',
          navigatorKey: navigatorKey,
          redirectUri: 'http://localhost:5000/',
          loader: const SizedBox()));
      final result = await oauth.login();
      result.fold(
        (l) => setMicrosoftFailure = l,
        (r) => setMicrosoftToken = r,
      );
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        _accessToken = accessToken;
        getAuthenticatedUserData();
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  } */

  Auth? _authUser;
  Auth? get authUser => _authUser;

  set setauthUser(Auth obj) {
    _authUser = obj;
    notifyListeners();
  }

  Future<void> getAuthenticatedUserData() async {
    try {
      await AuthService()
          .getUserInfo(_accessToken!)
          .then((value) => _authUser = value);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
