import 'package:advisorapp/models/admin/paymentmethod/paymentmethod.dart';
import 'package:advisorapp/service/stripeservice.dart';
import 'package:flutter/material.dart';

class PaymentMethodProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  bool _showEmailError = false;
  bool get showEmailError => _showEmailError;
  set showEmailError(bool newValue) {
    _showEmailError = newValue;
    notifyListeners();
  }

  TextEditingController cardholdernameController = TextEditingController();
  bool _showCardHolderNameError = false;
  bool get showCardHolderNameError => _showCardHolderNameError;
  set showCardHolderNameError(bool newValue) {
    _showCardHolderNameError = newValue;
    notifyListeners();
  }

  TextEditingController cardnumberController = TextEditingController();
  bool _showcardnumberError = false;
  bool get showcardnumberError => _showcardnumberError;
  set showcardnumberError(bool newValue) {
    _showcardnumberError = newValue;
    notifyListeners();
  }

  TextEditingController cvvController = TextEditingController();
  bool _showcvvError = false;
  bool get showcvvError => _showcvvError;
  set showcvvError(bool newValue) {
    _showcvvError = newValue;
    notifyListeners();
  }

  TextEditingController expirydateController = TextEditingController();
  bool _showexpirydateError = false;
  bool get showexpirydateError => _showexpirydateError;
  set showexpirydateError(bool newValue) {
    _showexpirydateError = newValue;
    notifyListeners();
  }

  TextEditingController zipcodeController = TextEditingController();
  bool _showzipcodeError = false;
  bool get showzipcodeError => _showzipcodeError;
  set showzipcodeError(bool newValue) {
    _showzipcodeError = newValue;
    notifyListeners();
  }

  TextEditingController banknameController = TextEditingController();
  bool _showbanknameError = false;
  bool get showbanknameError => _showbanknameError;
  set showbanknameError(bool newValue) {
    _showbanknameError = newValue;
    notifyListeners();
  }

  TextEditingController bankaccounttypeController = TextEditingController();
  bool _showbankaccounttypeError = false;
  bool get showbankaccounttypeError => _showbankaccounttypeError;
  set showbankaccounttypeError(bool newValue) {
    _showbankaccounttypeError = newValue;
    notifyListeners();
  }

  TextEditingController bankaccountnumberController = TextEditingController();
  bool _showbankaccountnumberError = false;
  bool get showbankaccountnumberError => _showbankaccountnumberError;
  set showbankaccountnumberError(bool newValue) {
    _showbankaccountnumberError = newValue;
    notifyListeners();
  }

  TextEditingController routingnumberController = TextEditingController();
  bool _showroutingnumberError = false;
  bool get showroutingnumberError => _showroutingnumberError;
  set showroutingnumberError(bool newValue) {
    _showroutingnumberError = newValue;
    notifyListeners();
  }

  String _selectedMethod = 'Card';
  String get selectedMethod => _selectedMethod;

  set selectedMethod(String obj) {
    _selectedMethod = obj;
    notifyListeners();
  }

  bool _consent = false;
  bool get consentStatus => _consent;

  set consentStatus(bool obj) {
    _consent = obj;
    notifyListeners();
  }

  List<PaymentMethod> _paymentmethods = [];
  List<PaymentMethod> get paymentmethods => _paymentmethods;
  Future<void> createPaymentMethod(accountcode, PaymentMethod obj) async {
    try {
      await StripeService()
          .createPaymentMethod(accountcode, obj)
          .then((value) => null);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
