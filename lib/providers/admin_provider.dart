import 'dart:js_interop';

import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/admin/adminuser.dart';
import 'package:advisorapp/models/admin/paymentmethod/attachedpaymentmethod.dart';
import 'package:advisorapp/models/admin/paymentmethod/invoice.dart';
import 'package:advisorapp/models/admin/setupIntent/inputsetupintent.dart';
import 'package:advisorapp/models/admin/subscription.dart';
import 'package:advisorapp/models/admin/subscriptionLicense.dart';
import 'package:advisorapp/models/status.dart';
import 'package:advisorapp/models/stripe/customer.dart';
import 'package:advisorapp/models/stripe/payment/paymentintent.dart';
import 'package:advisorapp/models/stripe/stripesession.dart';
import 'package:advisorapp/service/adminservice.dart';
import 'package:advisorapp/service/stripeservice.dart';
import 'package:flutter/material.dart';
import 'package:advisorapp/models/role.dart';

class AdminProvider extends ChangeNotifier {
  bool readingAdminuser = false;
  List<AdminUser> _adminusers = [];
  List<AdminUser> get adminusers => _adminusers;
  Future<void> readAdminUsers() async {
    try {
      readingAdminuser = true;
      _adminusers = await AdminService().readAdminUsers();
      readingAdminuser = false;

      notifyListeners();
    } catch (e) {
      readingAdminuser = true;
    }
  }

  bool _viewIframe = false;
  bool get viewIframe => _viewIframe;

  set viewIframe(bool obj) {
    _viewIframe = obj;
    notifyListeners();
  }

  bool _updatestatus = false;

  Future<void> updateStatus(
      Account accountowner, Account account, userstatus) async {
    try {
      _updatestatus = true;

      await AdminService().updateStatus(accountowner, account, userstatus);
      _updatestatus = false;

      notifyListeners();
    } catch (e) {
      _updatestatus = false;
    }
  }

  bool _updaterole = false;

  Future<void> updateRole(accountcode, accountrole) async {
    try {
      _updaterole = true;

      await AdminService().updateRole(accountcode, accountrole);
      _updaterole = false;

      notifyListeners();
    } catch (e) {
      _updaterole = false;
    }
  }

  Map<int, bool> _selectedSubscription = {};

  void selectedSubscription(int index, bool isSelected) {
    _selectedSubscription[index] = isSelected;
    notifyListeners();
  }

  bool isSubscriptionSelected(int index) {
    return _selectedSubscription[index] ?? false;
  }

  bool reading = false;
  bool readingLicense = false;
  List<Subscription> _subscriptions = [];
  List<Subscription> get subscriptions => _subscriptions;

  List<SubscriptionLicense> _subscriptionLicenses = [];
  List<SubscriptionLicense> get subscriptionLicenses => _subscriptionLicenses;

  Customer? _newCustomer;
  Customer? get newCustomer => _newCustomer;

  AttachedPaymentMethod? _attachedpaymentmethod;
  AttachedPaymentMethod? get attachedpaymentmethod => _attachedpaymentmethod;
  bool readingPaymentMethod = false;
  Future<void> readAttachedPaymentMethod(accountcode) async {
    try {
      readingPaymentMethod = true;
      _attachedpaymentmethod =
          await AdminService().readAttachedPaymentMethod(accountcode);
      readingPaymentMethod = false;
      (_attachedpaymentmethod?.paymentmethoddata != null)
          ? _validpaymentmethodexist = true
          : _validpaymentmethodexist = false;

      notifyListeners();
    } catch (e) {
      readingPaymentMethod = false;
    }
  }

  bool readingInvoice = false;
  List<Invoice> _invoices = [];
  List<Invoice> get invoices => _invoices;
  Future<void> readInvoices(createdbyaccount) async {
    try {
      readingInvoice = true;
      _invoices = await AdminService().readInvoices(createdbyaccount);
      readingInvoice = false;

      notifyListeners();
    } catch (e) {
      readingInvoice = true;
    }
  }

  bool _deletePaymentMethod = false;

  bool get deletePaymentMethod => _deletePaymentMethod;
  set deletePaymentMethod(bool obj) {
    _deletePaymentMethod = obj;
    notifyListeners();
  }

  dynamic _deletePaymentMethodResponse;
  dynamic get deletePaymentMethodResponse => _deletePaymentMethodResponse;

  Future<void> deleteAttachedPaymentMethod(accountcode, paymentmethodid) async {
    try {
      _deletePaymentMethod = true;
      _deletePaymentMethodResponse = await AdminService()
          .deleteAttachedPaymentMethod(accountcode, paymentmethodid);
      _deletePaymentMethod = false;
      _attachedpaymentmethod?.paymentmethoddata = null;
      _validpaymentmethodexist = false;
      notifyListeners();
    } catch (e) {
      _deletePaymentMethod = false;
    }
  }

  Future<void> getsubscriptions() async {
    try {
      _subscriptions.clear();
      reading = true;
      _subscriptions = await AdminService().readSubscription();
      reading = false;
      notifyListeners();
    } catch (e) {
      reading = false;
    }
  }

  Future<void> readSubscriptionLicense(accountcode) async {
    try {
      _subscriptionLicenses.clear();
      readingLicense = true;
      _subscriptionLicenses =
          await AdminService().readSubscriptionLicense(accountcode);
      readingLicense = false;
      notifyListeners();
    } catch (e) {
      readingLicense = false;
    }
  }

  Future<void> createCustomer(Account obj) async {
    try {
      _newCustomer = await StripeService().createCustomer(
          obj.accountcode,
          obj.companydomainname,
          obj.workemail,
          '${obj.accountname} ${obj.lastname}');
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  StripePaymentIntent? _stripepaymentIntent;
  StripePaymentIntent? get stripepaymentIntent => _stripepaymentIntent;

  Future<void> createPaymentIntent() async {
    try {
      _stripepaymentIntent = await StripeService().createPaymentIntent();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool _validpaymentmethodexist = false;
  bool get validpaymentmethodexist => _validpaymentmethodexist;
  set validpaymentmethodexist(bool obj) {
    _validpaymentmethodexist = obj;
    notifyListeners();
  }

  Invoice? _invoicetoprint;
  Invoice get invoicetoprint => _invoicetoprint!;
  set invoicetoprint(Invoice obj) {
    _invoicetoprint = obj;
    notifyListeners();
  }

  StripeSession? _checkoutsession;
  StripeSession get checkoutsession => _checkoutsession!;
  set checkoutsession(StripeSession obj) {
    _checkoutsession = obj;
    notifyListeners();
  }

  bool _clickedTodownload = false;
  bool get clickedTodownload => _clickedTodownload;

  set clickedTodownload(bool obj) {
    _clickedTodownload = obj;
    notifyListeners();
  }

  Future<void> createCheckOutSession(
      quantity, createdby, subscriptioncode) async {
    try {
      _checkoutsession = (await StripeService()
          .createCheckOutSession(quantity, createdby, subscriptioncode))!;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  String _setupintentUrl = '';
  String get setupintentUrl => _setupintentUrl;
  set setupintentUrl(String obj) {
    _setupintentUrl = obj;
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<void> createSetupIntentCheckOutSession(InputSetupIntent obj) async {
    try {
      _setupintentUrl =
          (await StripeService().createSetupIntentCheckOutSession(obj));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool _initSubscription = false;
  bool get initSubscription => _initSubscription;
  set initSubscription(bool obj) {
    _initSubscription = obj;
    notifyListeners();
  }

  List<Status> statusList = [];
  Future<void> loadStatusList() async {
    statusList.clear();
    statusList.add(Status(code: 'active', name: 'Active'));
    statusList.add(Status(code: 'inactive', name: 'Terminated'));

    // notifyListeners();
  }

  void setStatus(int index, Status value) {
    subscriptionLicenses[index].accountstatus = value.code;
    notifyListeners();
  }

  void setAccountRole(int index, Role value) {
    subscriptionLicenses[index].accountrole = value;
    notifyListeners();
  }
}
