import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/auth.dart';
import 'package:advisorapp/models/naics.dart';
import 'package:advisorapp/models/resetpassword.dart';
import 'package:advisorapp/service/httpservice.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'profile',
  ]);
  GoogleSignIn get googleSignIn => _googleSignIn;

/*    final GoogleSignIn googleSignIn; */

  /*  LoginProvider() {
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // However, in the web...
      if (kIsWeb && account != null) {
        currentGoogleUser = account;
      }
    });
  } */
  // ignore: prefer_final_fields
  final companydomainController = TextEditingController();
  final companynameController = TextEditingController();

  final eincodeController = TextEditingController();
  final companyaddressController = TextEditingController();
  final companyphoneController = TextEditingController();
  TextEditingController naicscodeController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final worktitleController = TextEditingController();
  final phoneController = TextEditingController();
  final mobileController = TextEditingController();
  final workemailController = TextEditingController();

  bool _isPanelShrinked = false;
  bool get isPanelShrinked => _isPanelShrinked;
  set isPanelShrinked(bool obj) {
    _isPanelShrinked = obj;
    notifyListeners();
  }

  Naics? _selectedNAICSCode;
  Naics? get selectedNAICSCode => _selectedNAICSCode;
  set selectedNAICSCode(Naics? obj) {
    _selectedNAICSCode = obj;
    notifyListeners();
  }

  bool naicscodeLoaded = false;
  List<Naics> _naicscodes = [];
  List<Naics> get naicscodes => _naicscodes;
  Future<void> getNaicsCodes() async {
    try {
      _naicscodes.clear();
      naicscodeLoaded = true;
      await HttpService().getNaicsCodesg().then((value) => {
            _naicscodes = value,
          });
      naicscodeLoaded = false;
      notifyListeners();
    } catch (e) {
      naicscodeLoaded = false;
    }
  }

  bool _invalidCredential = false;
  bool get invalidCredential => _invalidCredential;

  set invalidCredential(bool obj) {
    _invalidCredential = obj;
    notifyListeners();
  }

  bool _displaySubscription = false;
  bool get displaySubscription => _displaySubscription;
  set displaySubscription(bool obj) {
    _displaySubscription = obj;
    notifyListeners();
  }

  bool _adding = false;
  bool get adding => _adding;
  set adding(bool obj) {
    _adding = obj;
    notifyListeners();
  }

  bool _addingProfile = false;
  bool get addingProfile => _addingProfile;
  set addingProfile(bool obj) {
    _addingProfile = obj;
    notifyListeners();
  }

  bool _updating = false;
  bool get updating => _updating;
  set updating(bool obj) {
    _updating = obj;
    notifyListeners();
  }

  bool _verifying = false;
  bool get verifying => _verifying;
  set verifying(bool obj) {
    _verifying = obj;
    notifyListeners();
  }

  bool _addingPref = false;
  bool get addingPref => _addingPref;
  set addingPref(bool obj) {
    _addingPref = obj;
    notifyListeners();
  }

  Future<void> googleSignOut() async {
    try {
      currentGoogleUser = null;
      _googleSignIn.signOut();
      _googleSignIn.disconnect();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setLoggedInCredential(Account obj) async {
    try {
      addingPref = true;
      await HttpService().setLoggedInCredential(obj);
      addingPref = false;
      notifyListeners();
    } catch (e) {
      addingPref = false;
    }
  }

  Future<void> clearLoggedInCredential() async {
    try {
      await HttpService().clearLoggedInCredential();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  late ResetPassword _resetPassword;
  ResetPassword get resetPasswordStatus => _resetPassword;
  set resetPasswordStatus(ResetPassword obj) {
    _resetPassword = obj;
    notifyListeners();
  }

  bool _resettingPwd = false;
  bool get resettingPwd => _resettingPwd;
  set resettingPwd(bool obj) {
    _resettingPwd = obj;
    notifyListeners();
  }

  Future<void> accountResetPassword(accountcode, password) async {
    try {
      resettingPwd = true;
      await HttpService()
          .resetPassword(accountcode, password)
          .then((value) => resetPasswordStatus = value);
      resettingPwd = false;
      notifyListeners();
    } catch (e) {
      resettingPwd = false;
    }
  }

  Account? _cachedAccount;
  Account? get cachedAccount => _cachedAccount;
  void clearCachedAccount() {
    _cachedAccount = null;
    notifyListeners();
  }

  /*  set cachedAccount(Account? obj) {
    _cachedAccount = obj;
    notifyListeners();
  } */

  bool _caching = false;
  bool get caching => _caching;
  set caching(bool obj) {
    _caching = obj;
    notifyListeners();
  }

  Future<void> addInCache(Account obj) async {
    try {
      caching = true;
      await HttpService().setAccountInfo(obj);
      _cachedAccount = obj;
      caching = false;
      notifyListeners();
    } catch (e) {
      caching = false;
    }
  }

  Future<void> getFromCache() async {
    try {
      var obj = await HttpService().getAccountInfo();
      _cachedAccount = obj;
      notifyListeners();
    } catch (e) {
      caching = false;
    }
  }

  bool _sendingmail = false;
  bool get sendingEmail => _sendingmail;
  set sendingEmail(bool obj) {
    _sendingmail = obj;
    notifyListeners();
  }

  Account _logedinUser = Account(rolewithemployer: []);
  Account get logedinUser => _logedinUser;
  set logedinUser(Account obj) {
    _logedinUser = obj;
    notifyListeners();
  }

  Future<void> verifyCredential(Auth obj) async {
    try {
      verifying = true;
      await HttpService().verifyCredential(obj).then((value) {
        logedinUser = value!;
      });
      verifying = false;
      notifyListeners();
    } catch (e) {
      verifying = false;
    } finally {
      verifying = false;
    }
  }

  bool _isAuthorized = false;
  bool get isAuthorized => _isAuthorized;
  set isAuthorized(bool obj) {
    _isAuthorized = obj;
    notifyListeners();
  }

  bool _isGoogleVerified = false;
  bool get isGoogleVerified => _isGoogleVerified;
  set isGoogleVerified(bool obj) {
    _isGoogleVerified = obj;
    notifyListeners();
  }

  GoogleSignInAccount? _currentGoogleUser;
  GoogleSignInAccount? get currentGoogleUser => _currentGoogleUser;
  set currentGoogleUser(GoogleSignInAccount? obj) {
    _currentGoogleUser = obj;
    notifyListeners();
  }

  Future<void> handleGoogleSignIn() async {
    try {
      _isGoogleVerified = true;
      await _googleSignIn.signIn();
      _isGoogleVerified = false;
      notifyListeners();
    } catch (error) {
      _isGoogleVerified = false;
    }
    return null;
  }

  Future<void> getLoggedInUser() async {
    //isBack = true;
    await HttpService().getLoggedInCredential();
    // isBack = false;
    notifyListeners();
  }

  Future<void> sendEmail(AdvisorInvite obj) async {
    try {
      sendingEmail = true;
      await HttpService().sendEmail(obj);
      sendingEmail = false;
      notifyListeners();
    } catch (e) {
      sendingEmail = false;
    } finally {
      sendingEmail = false;
    }
  }

  Future<void> updateAccount(Account obj) async {
    try {
      updating = true;
      await HttpService().updateAccount(obj);
      updating = false;
      notifyListeners();
    } catch (e) {
      updating = false;
    } finally {
      updating = false;
    }
  }
}
