// ignore: file_names

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/service/authservice.dart';
import 'package:flutter/material.dart';

class MicrosoftAuthProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKeyMicrosoftAuth =
      GlobalKey<NavigatorState>();
  late AadOAuth oauth;
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

  AadOAuth? _aadOAuth;
  AadOAuth? get aadOAuth => _aadOAuth;

  set setaadOAuth(AadOAuth obj) {
    _aadOAuth = obj;
    notifyListeners();
  }

  String? _accessToken;
  String? get accessToken => _accessToken;

  set setaccessToken(String obj) {
    _accessToken = obj;
    notifyListeners();
  }

  Future<void> microsoftLogout() async {
    await oauth.logout();
  }

  Future<void> microsoftLogin() async {
    try {
      final Config config = Config(
          tenant: 'common',
          clientId: microsoftClientId,
          scope: 'User.Read',
          navigatorKey: navigatorKeyMicrosoftAuth,
          webUseRedirect: false,
          redirectUri: microsoftAuthredirectUri,
          loader: const SizedBox() //optional
          );

      oauth = AadOAuth(config);

      final result = await oauth.login();
      result.fold(
        (l) => setMicrosoftFailure = l,
        (r) => setMicrosoftToken = r,
      );
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        _accessToken = accessToken;
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

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
