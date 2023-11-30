import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';

class AddotherProvider extends ChangeNotifier {
  /* Map<int, bool> _loadingStatus = {};

  void setLoadingStatus(int index, bool isLoading) {
    _loadingStatus[index] = isLoading;
    notifyListeners();
  }

  bool isLoading(int index) {
    return _loadingStatus[index] ?? false;
  } */

  Map<int, bool> _sendingEmail = {};

  void setEmailStatus(int index, bool isSending) {
    _sendingEmail[index] = isSending;
    notifyListeners();
  }

  bool isSending(int index) {
    return _sendingEmail[index] ?? false;
  }

  //List<EmailModel> _emails = [];
  //List<EmailModel> get emailFields => _emails;

/*   void setEmailValidStaus(int index, bool valid) {
    _emails[index].isvalid = valid;
    notifyListeners();
  }

  set initEmail(int noOffields) {
    _emails.clear();
    for (var i = 0; i < noOffields; i++) {
      _emails.add(EmailModel(email: '', isvalid: false));
    }
    // notifyListeners();
  }

  void addEmail() {
    _emails.add(EmailModel(email: '', isvalid: false));
    notifyListeners();
  }
 */

  bool _invitingNew = false;
  bool get invitingNew => _invitingNew;

  set invitingNew(bool obj) {
    _invitingNew = obj;
    notifyListeners();
  }

  void addEmail() {
    _invitingNew = true;
    _advisorinvites.add(AdvisorInvite(
        role: Role(rolecode: '', rolename: '', roletype: ''),
        companycategory: CompanyCategory(
            categorycode: '', categoryname: '', basecategorycode: ''),
        invitedby: '',
        invitedemail: '',
        invitationstatus: '',
        isvalid: false));
    _currentInvite = AdvisorInvite(
        role: Role(rolecode: '', rolename: '', roletype: ''),
        companycategory: CompanyCategory(
            categorycode: '', categoryname: '', basecategorycode: ''));
    notifyListeners();
  }

  void addFilteredEmail(Role role, CompanyCategory category) {
    _filteredinvites.add(AdvisorInvite(
        role: role,
        companycategory: category,
        invitedby: '',
        invitedemail: '',
        invitationstatus: '',
        isvalid: false));
    _currentInvite = AdvisorInvite(role: role, companycategory: category);
    notifyListeners();
  }

  void setEmailValidStaus(int index, bool valid) {
    _advisorinvites[index].isvalid = valid;
    notifyListeners();
  }

  void setFilteredEmailValidStatus(int index, bool valid) {
    _filteredinvites[index].isvalid = valid;
    notifyListeners();
  }

  void setInvitePersonRole(int index, Role role) {
    _advisorinvites[index].role = role;
    notifyListeners();
  }

  void setFilteredInvitePersonRole(int index, Role role) {
    _filteredinvites[index].role = role;
    notifyListeners();
  }

  void setFilteredInvitePersonCategory(int index, CompanyCategory category) {
    _filteredinvites[index].companycategory = category;
    notifyListeners();
  }

  AdvisorInvite _currentInvite = AdvisorInvite(
      role: Role(rolecode: '', rolename: '', roletype: ''),
      companycategory: CompanyCategory(
          categorycode: '', categoryname: '', basecategorycode: ''));
  AdvisorInvite get currentInvite => _currentInvite;
  set currentInvite(AdvisorInvite obj) {
    _currentInvite = obj;
    notifyListeners();
  }

  Future<void> sendEmail(AdvisorInvite obj, int index) async {
    try {
      _sendingEmail[index] = true;
      await HttpService()
          .sendEmail(obj)
          .then((value) => _currentInvite = value);
      _sendingEmail[index] = false;
      _invitingNew = false;
      notifyListeners();
    } catch (e) {
      _sendingEmail[index] = false;
    } finally {
      _sendingEmail[index] = false;
    }
  }

  List<AdvisorInvite> _advisorinvites = [];
  List<AdvisorInvite> get advisorinvites => _advisorinvites;
  List<AdvisorInvite> _filteredinvites = [];
  List<AdvisorInvite> get filteredinvites => _filteredinvites;

  List<AdvisorInvite> getFilteredAdvisorInvites(String domain) {
    return _advisorinvites
        .where((invite) => !invite.invitedemail.endsWith(domain))
        .toList();
  }

  bool readingInvite = false;

  Future<void> readAdvisorInvite(String invitedby) async {
    try {
      readingInvite = true;
      _advisorinvites.clear();
      _filteredinvites.clear();

      Account objAcc = await HttpService().getLoggedInCredential();
      await HttpService().readAdvisorInvite(invitedby).then((value) {
        _advisorinvites = value.map((invite) {
          invite.isvalid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(invite.invitedemail);
          return invite;
        }).toList();

        _filteredinvites = _advisorinvites
            .where((invite) =>
                !invite.invitedemail
                    .endsWith(objAcc.workemail.split('@').last) &&
                invite.companycategory.basecategorycode == 'advisor')
            .toList();
        _advisorinvites = _advisorinvites
            .where((invite) =>
                invite.invitedemail.endsWith(objAcc.workemail.split('@').last))
            .toList();
      });

      readingInvite = false;
      notifyListeners();
    } catch (e) {
      readingInvite = false;
    } finally {
      readingInvite = false;
    }
  }
}
