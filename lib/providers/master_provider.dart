import 'package:advisorapp/models/basecategory.dart';
import 'package:advisorapp/models/company.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/payment.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';

class MasterProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  bool _loadingMasterData = false;
  bool get loadingMasterData => _loadingMasterData;
  set loadingMasterData(bool obj) {
    _loadingMasterData = obj;
    notifyListeners();
  }

  bool _askForPayment = false;
  bool get askForPayment => _askForPayment;
  set askForPayment(bool obj) {
    _askForPayment = obj;
    notifyListeners();
  }

  bool loading = false;

  Future<void> loadMasterData() async {
    try {
      //loading = true;
      _loadingMasterData = true;
      await getRoles();
      //await getEmployerRoles();
      await getCompanyCategories();
      await getCompanyTypes();
      await getPayments();
      await getCompanies();
      //loading = false;
      _loadingMasterData = false;
      //notifyListeners();

      /* if (!roleReading &&
          !companyCategoryLoaded &&
          !companyTypeLoaded &&
          !paymentLoaded &&
          !readCompanies) {
        loading = false;
        notifyListeners();
      } */
    } catch (e) {
      _loadingMasterData = false;
    }
  }

  bool companyCategoryLoaded = false;
  bool companyTypeLoaded = false;
  bool roleReading = false;
  bool roleEmployerLoaded = false;
  bool paymentLoaded = false;

  List<CompanyCategory> _companycategories = [];
  List<CompanyCategory> get companycategories => _companycategories;
  CompanyCategory? _selectedCompanyCategory;
  CompanyCategory? get selectedCompanyCategory => _selectedCompanyCategory;

  set selectedCompanyCategory(CompanyCategory? obj) {
    _selectedCompanyCategory = obj;
    if (_selectedCompanyCategory!.categoryname == 'Employer') {
      Payment nilPayment = payments.firstWhere(
        (element) => element.paymentcode == 'PC-20230424161840147',
      );
      if (nilPayment.paymentcode.isNotEmpty) {
        selectedPayment = nilPayment;
      }
    }
    notifyListeners();
  }

  List<BaseCompanyCategory> _basecompanycategories = [];
  List<BaseCompanyCategory> get basecompanycategories => _basecompanycategories;
  BaseCompanyCategory? _selectedBaseCompanyCategory;
  BaseCompanyCategory? get selectedBaseCompanyCategory =>
      _selectedBaseCompanyCategory;

  set selectedBaseCompanyCategory(BaseCompanyCategory? obj) {
    _selectedBaseCompanyCategory = obj;
    notifyListeners();
  }

  CompanyCategory? _selectedAccountCompanyCategory;
  CompanyCategory? get selectedAccountCompanyCategory =>
      _selectedAccountCompanyCategory;

  set selectedAccountCompanyCategory(CompanyCategory? obj) {
    _selectedAccountCompanyCategory = obj;
    notifyListeners();
  }

  /* CompanyCategory? _selectedPartnerCompanyCategory;
  CompanyCategory? get selectedPartnerCompanyCategory =>
      _selectedPartnerCompanyCategory;

  set selectedPartnerCompanyCategory(CompanyCategory? obj) {
    _selectedPartnerCompanyCategory = obj;
    notifyListeners();
  } */

  Future<void> getBaseCompanyCategories() async {
    _basecompanycategories.clear();
    await HttpService().readBaseCompanyCategory().then((value) => {
          _basecompanycategories = value,
        });

    notifyListeners();
  }

  Future<void> getCompanyCategories() async {
    _companycategories.clear();
    companyCategoryLoaded = true;
    await HttpService().readCompanyCategory().then((value) => {
          _companycategories = value,
        });
    companyCategoryLoaded = false;
    notifyListeners();
  }

  //Account Role
  List<Role> _accountroles = [];
  List<Role> get accountroles => _accountroles;
  Role? _selectedAccountRole;
  Role? get selectedAccountRole => _selectedAccountRole;

  set selectedAccountRole(Role? obj) {
    _selectedAccountRole = obj;
    notifyListeners();
  }

  //Partner/Advisor Role
  List<Role> _partnerroles = [];
  List<Role> get partnerroles => _partnerroles;

  Future<void> getRoles() async {
    roleReading = true;
    _accountroles.clear();
    _employerroles.clear();
    _partnerroles.clear();
    List<Role> roles = await HttpService().readRoleG();
    _accountroles = roles.where((obj) => obj.roletype == 'Account').toList();
    _employerroles = roles.where((obj) => obj.roletype == 'Employer').toList();
    //Here _partner means data of both advisor and parter as both are same
    _partnerroles = roles.where((obj) => obj.roletype == 'Partner').toList();
    roleReading = false;
    notifyListeners();
  }

  //Employer Role
  List<Role> _employerroles = [];
  List<Role> get employerroles => _employerroles;
  /* Role? _selectedEmployerRole;
  Role? get selectedEmployerRole => _selectedEmployerRole; */
  List<Role>? _selectedEmployerRole;
  List<Role>? get selectedEmployerRole => _selectedEmployerRole;

  set selectedEmployerRole(List<Role>? obj) {
    _selectedEmployerRole = obj;
    notifyListeners();
  }

  Future<void> getEmployerRoless() async {
    _employerroles.clear();
    roleEmployerLoaded = true;
    List<Role> roles = await HttpService().readRole();
    _employerroles = roles.where((obj) => obj.roletype == 'Employer').toList();
    roleEmployerLoaded = false;
    notifyListeners();
  }

  //Company Type
  List<CompanyType> _companytypes = [];
  List<CompanyType> get companytypes => _companytypes;
  CompanyType? _selectedAccountCompanyType;
  CompanyType? get selectedAccountCompanyType => _selectedAccountCompanyType;

  set selectedAccountCompanyType(CompanyType? obj) {
    _selectedAccountCompanyType = obj;
    notifyListeners();
  }

  CompanyType? _selectedEmployerCompanyType;
  CompanyType? get selectedEmployerCompanyType => _selectedEmployerCompanyType;

  set selectedEmployerCompanyType(CompanyType? obj) {
    _selectedEmployerCompanyType = obj;
    notifyListeners();
  }

  Future<void> getCompanyTypes() async {
    _companytypes.clear();
    companyTypeLoaded = true;
    await HttpService().readCompanyType().then((value) => {
          _companytypes = value,
        });
    companyTypeLoaded = false;
    notifyListeners();
  }

  //Payment Type
  List<Payment> _payments = [];
  List<Payment> get payments => _payments;
  Payment? _selectedPayment;
  Payment? get selectedPayment => _selectedPayment;

  set selectedPayment(Payment? obj) {
    _selectedPayment = obj;
    notifyListeners();
  }

  Future<void> getPayments() async {
    _payments.clear();
    try {
      paymentLoaded = true;
      await HttpService().readPayment().then((value) => {
            _payments = value,
          });
      paymentLoaded = false;
      notifyListeners();
    } catch (e) {
      paymentLoaded = false;
    }
  }

  bool readCompanies = false;
  List<Company> _companies = [];
  List<Company> get companies => _companies;

  Future<void> getCompanies() async {
    try {
      readCompanies = true;
      _companies.clear();
      _companies = await HttpService().readCompaniesG();
      notifyListeners();
      readCompanies = false;
    } catch (e) {
      readCompanies = false;
    }
  }
}
