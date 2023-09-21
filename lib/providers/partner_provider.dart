import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';
import '../models/partner.dart';

class PartnerProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  //'CC-20230224174603740': 'TPA'
  TextEditingController partnerdomainnameController = TextEditingController();
  TextEditingController salesLeadEmailController = TextEditingController();
  TextEditingController contractSignatoryEmailController =
      TextEditingController();
  TextEditingController accountLeadEmailController = TextEditingController();

  bool reading = false;

  bool _adding = false;
  bool get adding => _adding;
  set adding(bool obj) {
    _adding = obj;
    notifyListeners();
  }

  bool _updating = false;
  bool get updating => _updating;
  set updating(bool obj) {
    _updating = obj;
    notifyListeners();
  }

  bool _addNew = false;
  bool get addNew => _addNew;

  set addNew(bool obj) {
    _addNew = obj;
    notifyListeners();
  }

  bool _edit = false;
  bool get edit => _edit;

  set edit(bool obj) {
    _edit = obj;
    notifyListeners();
  }

  List<Partner> _partners = [];
  List<Partner> get partners => _partners;
  List<Partner>? _selectedPartners;
  List<Partner>? get selectedPartners => _selectedPartners;

  Partner? _selectedPartner;
  Partner? get selectedPartner => _selectedPartner;

  set selectedPartner(Partner? obj) {
    _selectedPartner = obj;
    notifyListeners();
  }

  set selectedPartners(List<Partner>? obj) {
    _selectedPartners = obj;
    // print(_selectedPartners);
    notifyListeners();
  }

  /*  List<CompanyCategory> _companycategories = [];
  List<CompanyCategory> get companycategories => _companycategories;
  CompanyCategory? _selectedCompanyCategory;
  CompanyCategory? get selectedCompanyCategory => _selectedCompanyCategory;

  set selectedCompanyCategory(CompanyCategory? obj) {
    _selectedCompanyCategory = obj;
    notifyListeners();
  } */

  /*  Future<void> getCompanyCategories() async {
    _companycategories.clear();
    await HttpService()
        .readCompanyCategory()
        .then((value) => {_companycategories = value});
    notifyListeners();
  } */
  bool _sendingmail = false;
  bool get sendingEmail => _sendingmail;
  set sendingEmail(bool obj) {
    _sendingmail = obj;
    notifyListeners();
  }

  bool _sendingmail1 = false;
  bool get sendingEmail1 => _sendingmail1;
  set sendingEmail1(bool obj) {
    _sendingmail1 = obj;
    notifyListeners();
  }

  bool _sendingmail2 = false;
  bool get sendingEmail2 => _sendingmail2;
  set sendingEmail2(bool obj) {
    _sendingmail2 = obj;
    notifyListeners();
  }

  Future<void> clearInvitation() async {
    _invitedPartners.clear();
    notifyListeners();
  }

  List<AdvisorInvite> _invitedPartners = [];
  List<AdvisorInvite> get invitedPartners => _invitedPartners;

  Future<void> sendEmail(AdvisorInvite obj, String role) async {
    try {
      if (role == 'SALESLEAD') {
        sendingEmail = true;
      } else if (role == 'CONTRACTSIGNATORY') {
        sendingEmail1 = true;
      } else if (role == 'ACCOUNTLEAD') {
        sendingEmail2 = true;
      }

      AdvisorInvite objReturn = await HttpService().sendEmail(obj);
      _invitedPartners.add(objReturn);

      notifyListeners();
    } catch (e) {
      sendingEmail = false;
      sendingEmail1 = false;
      sendingEmail2 = false;
    } finally {
      if (role == 'SALESLEAD') {
        sendingEmail = false;
      } else if (role == 'CONTRACTSIGNATORY') {
        sendingEmail1 = false;
      } else if (role == 'ACCOUNTLEAD') {
        sendingEmail2 = false;
      }
    }
  }

  CompanyCategory? _selectedPartnerCompanyCategory;
  CompanyCategory? get selectedPartnerCompanyCategory =>
      _selectedPartnerCompanyCategory;

  set selectedPartnerCompanyCategory(CompanyCategory? obj) {
    _selectedPartnerCompanyCategory = obj;
    notifyListeners();
  }

  Future<void> addPartner(
      Partner obj, Role? userRole, CompanyCategory? companycategory) async {
    try {
      adding = true;
      AdvisorInvite objAdv = AdvisorInvite(
          invitedemail: obj.salesleademail,
          role: userRole!,
          companycategory: companycategory!);
      objAdv.duration = 7;
      objAdv.invitationtype = 'MailTemplateTypeInviteJoin';
      AdvisorInvite objAdv1 = AdvisorInvite(
          invitedemail: obj.contractsignatoryemail,
          role: userRole,
          companycategory: companycategory);
      objAdv1.duration = 7;
      objAdv1.invitationtype = 'MailTemplateTypeInviteJoin';
      sendingEmail = true;
      await sendEmail(objAdv, 'SALESLEAD');
      sendingEmail = false;
      sendingEmail1 = true;
      await sendEmail(objAdv1, 'CONTRACTSIGNATORY');
      sendingEmail1 = false;

      await HttpService().addPartner(obj).then((value) => {
            _partners.add(value),
          });
      adding = false;
      notifyListeners();
    } catch (e) {
      adding = false;
    }
  }

  Future<void> updatePartner(Partner obj) async {
    try {
      updating = true;
      await HttpService().updatePartner(obj);
      /* await HttpService().updatePartner(obj).then((value) => {
            _partners
                .removeWhere((object) => object.partnercode == obj.partnercode),
            _partners.add(value), 
          });*/
      updating = false;
      notifyListeners();
    } catch (e) {
      updating = false;
    }
  }

  Future<void> getPartner() async {
    try {
      _partners.clear();
      reading = true;
      _partners = await HttpService().fetchPartnerG('');
      reading = false;
      notifyListeners();
    } catch (e) {
      reading = false;
    }
  }

  bool _readingAccPartner = false;
  bool get readingAccPartner => _readingAccPartner;
  set readingAccPartner(bool obj) {
    _readingAccPartner = obj;
    notifyListeners();
  }
  //bool readingAccPartner = false;

  /*  List<Partner> _accountpartners = [];
  List<Partner> get accountpartners => _accountpartners; */

  Future<void> getPartnerAddedByAccount(String accountcode) async {
    try {
      /*  _accountpartners.clear();
      readingAccPartner = true;
      _accountpartners = await HttpService().fetchPartner(accountcode);
      readingAccPartner = false; */
      _partners.clear();
      readingAccPartner = true;
      _partners = await HttpService().fetchPartner(accountcode);
      readingAccPartner = false;

      notifyListeners();
    } catch (e) {
      readingAccPartner = false;
    }
  }
}
