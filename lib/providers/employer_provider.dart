import 'dart:convert';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/employerassistant.dart';
import 'package:advisorapp/models/employerprofile.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/esign/esigndocument.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/mail/newactionitemmail.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/models/visibilitystatus.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';
import '../models/accountaction.dart';
import '../models/launchstatus.dart';
import 'dart:html' as html;

class EmployerProvider extends ChangeNotifier {
  // ignore: prefer_final_fields

  String basePathOfLogo =
      'https://advisorformsftp.blob.core.windows.net/advisorimages/employerlogo/';

  TextEditingController companydomainnameController = TextEditingController();
  TextEditingController decisionmakerController = TextEditingController();
  TextEditingController contractsignatoryController = TextEditingController();
  TextEditingController daytodaycontactController = TextEditingController();
  TextEditingController planeffectivedateController = TextEditingController();

  Future<void> sendAssignmentEmail(NewActionItemMail obj) async {
    try {
      await HttpService().sendEmailForNewActionItem(obj);
      notifyListeners();
    } catch (e) {
    } finally {}
  }

  Employer _currentEmployer = Employer(partners: []);
  Employer get currentEmployer => _currentEmployer;

  set currentEmployer(Employer obj) {
    _currentEmployer = obj;
    notifyListeners();
  }

  Map<int, bool> _loadingStatus = {};

  void setLoadingStatus(int index, bool isLoading) {
    _loadingStatus[index] = isLoading;
    notifyListeners();
  }

  bool isLoading(int index) {
    return _loadingStatus[index] ?? false;
  }

  bool _reading = false;
  bool get reading => _reading;
  set reading(bool obj) {
    _reading = obj;
    notifyListeners();
  }

  bool _initlaunch = false;
  bool get initLaunch => _initlaunch;
  set initLaunch(bool obj) {
    _initlaunch = obj;
    notifyListeners();
  }

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

  CompanyCategory? _selectedEmployerCompanyCategory;
  CompanyCategory? get selectedEmployerCompanyCategory =>
      _selectedEmployerCompanyCategory;

  set selectedEmployerCompanyCategory(CompanyCategory? obj) {
    _selectedEmployerCompanyCategory = obj;
    notifyListeners();
  }

  bool _readingLaunchPack = false;
  bool get readingLaunchPack => _readingLaunchPack;

  set readingLaunchPack(bool obj) {
    _readingLaunchPack = obj;
    notifyListeners();
  }

  bool _insertingLaunchPack = false;
  bool get insertingLaunchPack => _insertingLaunchPack;

  set insertingLaunchPack(bool obj) {
    _insertingLaunchPack = obj;
    notifyListeners();
  }

  Future<void> insertLaunchPackForEmployer(LaunchPack obj) async {
    try {
      insertingLaunchPack = true;
      await HttpService().insertLaunchPackForEmployer(obj);
      insertingLaunchPack = false;
      notifyListeners();
    } catch (e) {
      insertingLaunchPack = false;
    } finally {
      insertingLaunchPack = false;
    }
  }

  bool _updatelaunchstatus = false;
  bool get updatelaunchstatus => _updatelaunchstatus;
  set updatelaunchstatus(bool obj) {
    _updatelaunchstatus = obj;
    notifyListeners();
  }

  DateTime? _planeffectiveDate = DateTime.now();
  DateTime? get planeffectiveDate => _planeffectiveDate;
  set planeffectiveDate(DateTime? obj) {
    _planeffectiveDate = obj;
    notifyListeners();
  }

  List<LaunchPack> _launchpacks = [];
  List<LaunchPack> get launchpacks => _launchpacks;

  List<Employer> _employers = [];
  List<Employer> get employers => _employers;
  Employer? _selectedEmployer;
  Employer? get selectedEmployer => _selectedEmployer;

  set selectedEmployer(Employer? obj) {
    edit = true;
    _selectedEmployer = obj;
    if (employerprofiles.isNotEmpty && obj?.accountcode != '0') {
      _selectedEmployerProfile = employerprofiles
          .firstWhere((e) => e.employerCode == obj?.employercode, orElse: (() {
        return EmployerProfile(
            employerCode: '', fileextension: '', filebase64: '');
      }));
    }
    notifyListeners();
  }

  EmployerProfile? _selectedEmployerProfile;
  EmployerProfile? get selectedEmployerProfile => _selectedEmployerProfile;
  set selectedEmployerProfile(EmployerProfile? obj) {
    _selectedEmployerProfile = obj;
    notifyListeners();
  }

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

  AdvisorInvite _currentInvite = AdvisorInvite(
      role: Role(rolecode: '', rolename: '', roletype: ''),
      companycategory: CompanyCategory(
          categorycode: '', categoryname: '', basecategorycode: ''));
  AdvisorInvite get currentInvite => _currentInvite;
  set currentInvite(AdvisorInvite obj) {
    _currentInvite = obj;
    notifyListeners();
  }

  Future<void> clearInvitation() async {
    _invitedEmployers.clear();
    notifyListeners();
  }

  Future<void> clearEmployees() async {
    _employers.clear();
    notifyListeners();
  }

  Future<void> clearLaunchPacks() async {
    _launchpacks.clear();
    notifyListeners();
  }

  List<AdvisorInvite> _invitedEmployers = [];
  List<AdvisorInvite> get invitedEmployers => _invitedEmployers;

  Future<void> sendEmail(AdvisorInvite obj, String role) async {
    try {
      if (role == 'DECISIONMAKER') {
        sendingEmail = true;
      } else if (role == 'CONTRACTSIGNATORY') {
        sendingEmail1 = true;
      } else if (role == 'DAYTODAY') {
        sendingEmail2 = true;
      }
      AdvisorInvite objReturn = await HttpService().sendEmail(obj);
      _invitedEmployers.add(objReturn);
      notifyListeners();
    } catch (e) {
      sendingEmail = false;
      sendingEmail1 = false;
      sendingEmail2 = false;
    } finally {
      if (role == 'DECISIONMAKER') {
        sendingEmail = false;
      } else if (role == 'CONTRACTSIGNATORY') {
        sendingEmail1 = false;
      } else if (role == 'DAYTODAY') {
        sendingEmail2 = false;
      }
    }
  }

  Future<void> updateLaunchStatus(
      accountcode, employercode, launchstatus) async {
    try {
      updatelaunchstatus = true;
      await HttpService()
          .updateLaunchStatus(accountcode, employercode, launchstatus);
      notifyListeners();
      updatelaunchstatus = false;
    } catch (e) {
      updatelaunchstatus = false;
    }
  }

  Map<int, bool> _launchFormSavingStatus = {};

  void setLaunchFormSavingStatus(int index, bool isSaving) {
    _launchFormSavingStatus[index] = isSaving;
    notifyListeners();
  }

  bool isLaunchFormSaving(int index) {
    return _launchFormSavingStatus[index] ?? false;
  }

  Future<void> updateLaunchFormStatus(
      accountcode, employercode, formcode, formstatus, duedate) async {
    try {
      updatelaunchstatus = true;
      await HttpService().updateLaunchFormStatus(
          accountcode, employercode, formcode, formstatus, duedate);
      notifyListeners();
      updatelaunchstatus = false;
    } catch (e) {
      updatelaunchstatus = false;
    }
  }

  Future<void> clearActionLaunchPack() async {
    _actionlaunchpacks.clear();
    notifyListeners();
  }

  Future<void> clearEmployerAssist() async {
    employerAssistList.clear();
    notifyListeners();
  }

  Future<void> getInitialLaunchPack(accountcode, employercode, type) async {
    try {
      readingLaunchPack = true;
      _launchpacks.clear();
      _launchpacks = await HttpService()
          .readInitialLaunchPack(accountcode, employercode, type);
      notifyListeners();
      readingLaunchPack = false;
    } catch (e) {
      readingLaunchPack = false;
    }
  }

  Future<void> readAccountsAssociatedtoEmployer(
      accountcode, employercode) async {
    try {
      employerAssistList.clear();
      List<Account> accounts = await HttpService()
          .readAccountsAssociatedtoEmployer(accountcode, employercode);

      employerAssistList = accounts
          .map((oJson) => EmployerAssist.fromJson(oJson.toJson()))
          .toSet()
          .toList();
      notifyListeners();
    } catch (e) {
      employerAssistList.clear();
    }
  }

  Future<void> getEmployers(accountcode) async {
    try {
      _employers.clear();
      _employerprofiles.clear();
      reading = true;
      await HttpService().readEmployers(accountcode).then((value) => {
            _employers = value,
          });
      for (var e in _employers) {
        EmployerProfile o = EmployerProfile(
            employerCode: e.employercode, fileextension: '', filebase64: '');
        o.companylogo = "$basePathOfLogo${e.employercode}.png";
        //o.companylogo = "";
        _employerprofiles.add(o);
      }

      reading = false;
      notifyListeners();
    } catch (e) {
      reading = false;
    }
  }

  Future<void> addEmployer(
      Employer obj, Role? userRole, CompanyCategory? companycategory) async {
    try {
      adding = true;
      AdvisorInvite objAdv = AdvisorInvite(
          invitedemail: obj.decisionmakeremail,
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
      await sendEmail(objAdv, 'DECISIONMAKER');
      sendingEmail = false;
      sendingEmail1 = true;
      await sendEmail(objAdv1, 'CONTRACTSIGNATORY');
      sendingEmail1 = false;

      Employer lastAdded = await HttpService().addEmployer(obj);
      _employers.add(lastAdded);
      /* 
      await HttpService().addEmployer(obj).then((value) => {
            _employers.add(value),
          }); */

      EmployerProfile o = EmployerProfile(
          employerCode: lastAdded.employercode,
          fileextension: '',
          filebase64: '');
      o.companylogo = "$basePathOfLogo${lastAdded.employercode}.png";
      _employerprofiles.add(o);
      adding = false;
      notifyListeners();
    } catch (e) {
      adding = false;
      sendingEmail = false;
      sendingEmail1 = false;
    }
  }

  Future<void> updateEmployer(
      Employer obj, Role? userRole, CompanyCategory? companycategory) async {
    try {
      updating = true;
      if (obj.contractsignatoryemailinvitationstatus == "") {
        AdvisorInvite objAdv1 = AdvisorInvite(
            invitedemail: obj.contractsignatoryemail,
            role: userRole!,
            companycategory: companycategory!);
        objAdv1.duration = 7;
        objAdv1.invitationtype = 'MailTemplateTypeInviteJoin';
        sendingEmail1 = true;
        await sendEmail(objAdv1, 'CONTRACTSIGNATORY');
        sendingEmail1 = false;
      }
      Employer returnObject = await HttpService().updateEmployer(obj);
      returnObject.contractsignatoryemailinvitationstatus =
          obj.contractsignatoryemailinvitationstatus;
      returnObject.daytodaycontactemailinvitationstatus =
          obj.daytodaycontactemailinvitationstatus;
      returnObject.decisionmakeremailinvitationstatus =
          obj.decisionmakeremailinvitationstatus;
      int index = _employers
          .indexWhere((element) => element.employercode == obj.employercode);
      _employers.removeAt(index);
      _employers.insert(index, returnObject);
      updating = false;
      notifyListeners();
    } catch (e) {
      updating = false;
    }
  }

  Future<void> initiateLaunch(LaunchPack obj) async {
    try {
      initLaunch = true;
      await HttpService().initiateLaunchPack(obj);
      initLaunch = false;
      notifyListeners();
    } catch (e) {
      initLaunch = false;
    }
  }

  // Adding action
  List<ActionLaunchPack> _actionlaunchpacks = [];
  List<ActionLaunchPack> get actionlaunchpacks => _actionlaunchpacks;

  bool _savingLaunchPack = false;
  bool get savingLaunchPack => _savingLaunchPack;
  set savingLaunchPack(bool obj) {
    _savingLaunchPack = obj;
    notifyListeners();
  }

  Future<void> pickFile(ActionLaunchPack obj, int index) async {
    final input = html.InputElement(type: 'file');

    input.click();
    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final file = input.files?.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file!);
      await reader.onLoad.first;
      final encoded = base64Encode(reader.result as List<int>);
      final fileext = ".${file.name.toString().split('.')[1]}";

      actionlaunchpacks[index].filename = file.name;
      actionlaunchpacks[index].fileextension = fileext;
      actionlaunchpacks[index].filebase64 = encoded;
      actionlaunchpacks[index].contentmimetype = file.type;

      notifyListeners();
    }
  }

  bool _viewIframe = false;
  bool get viewIframe => _viewIframe;
  set viewIframe(bool obj) {
    _viewIframe = obj;
    notifyListeners();
  }

  ESignEmbeddedResponse? _esignembededdata;
  ESignEmbeddedResponse? get esignembededdata => _esignembededdata;
  set esignembededdata(ESignEmbeddedResponse? obj) {
    _esignembededdata = obj;
    notifyListeners();
  }

  Future<void> generateESignEmbeddedURL(documentid, formdefinitionid) async {
    _esignembededdata = await HttpService()
        .generateESignEmbeddedURL(documentid, formdefinitionid);
    // return _esignembededdata!;
    notifyListeners();
  }

  Future<void> addActionLaunchPack() async {
    _actionlaunchpacks.clear();
    _actionlaunchpacks.add(ActionLaunchPack(
        filebase64: '',
        fileextension: '',
        filename: '',
        formcode: '',
        formname: '',
        attachmenttype: 'none',
        esigndocumentdata:
            ESignDocument(esigndocumentid: '', formdefinitionid: ''),
        newAction: true));

    /* if (_actionlaunchpacks.isEmpty) {
      
    } */

    notifyListeners();
  }

  Future<void> saveActionLaunchPack(AccountAction obj, int index) async {
    try {
      savingLaunchPack = true;
      await HttpService().addAction(obj).then((value) {
        ActionLaunchPack? retObj = value?.formfileupload[0];
        _actionlaunchpacks[index].filebase64 = retObj!.filebase64;

        _actionlaunchpacks[index].filename = retObj.filename;
        _actionlaunchpacks[index].formcode = retObj.formcode;
        _actionlaunchpacks[index].formname = retObj.formname;
        _actionlaunchpacks[index].fileextension = retObj.fileextension;
        _actionlaunchpacks[index].launchpack = retObj.launchpack;
        _actionlaunchpacks[index].renewalpack = retObj.renewalpack;
        _actionlaunchpacks[index].attachmenttype = retObj.attachmenttype;
        _actionlaunchpacks[index].esigndocumentdata = retObj.esigndocumentdata;
      });

      savingLaunchPack = false;

      notifyListeners();
    } catch (e) {
      savingLaunchPack = false;
    }
  }

  // Launch Status / form Status
  String? _selectedFormStatus;
  String? get selectedFormStatus => _selectedFormStatus;

  set selectedFormStatus(String? obj) {
    _selectedFormStatus = obj;
    notifyListeners();
  }

  // From and To data
  String _toDotooltip = '';
  String get toDotooltip => _toDotooltip;

  set toDotooltip(String val) {
    _toDotooltip = val;
    notifyListeners();
  }

  EmployerAssist? _selectedFromAssist;
  EmployerAssist? get selectedFromAssist => _selectedFromAssist;

  setSelectedFromAssistToNull() {
    _selectedFromAssist = null;
    notifyListeners();
  }

  setSelectedToAssistToNull() {
    _selectedToAssist = null;
    notifyListeners();
  }

  set selectedFromAssist(EmployerAssist? obj) {
    _selectedFromAssist = obj;
    if (_selectedToAssist != null &&
        (_selectedToAssist!.account == _selectedFromAssist!.account)) {
      _selectedVisibilityStatus = true;
    } else {
      _selectedVisibilityStatus = false;
    }
    if (_selectedToAssist != null &&
        _selectedToAssist!.account.companydomainname ==
            _selectedFromAssist!.account.companydomainname) {
      _toDotooltip =
          "Private items will be visible only to the Sender and Receiver within your company";
    } else {
      _toDotooltip =
          "Private items will be visible only to the Sender, Receiver and the Advisor";
    }
    notifyListeners();
  }

  DateTime? _assistDueDate = DateTime.now();
  DateTime? get assistDueDate => _assistDueDate;
  set assistDueDate(DateTime? obj) {
    _assistDueDate = obj;
    notifyListeners();
  }

  EmployerAssist? _selectedToAssist;
  EmployerAssist? get selectedToAssist => _selectedToAssist;

  set selectedToAssist(EmployerAssist? obj) {
    _selectedToAssist = obj;
    if (_selectedFromAssist != null &&
        (_selectedToAssist!.account == _selectedFromAssist!.account)) {
      _selectedVisibilityStatus = true;
    } else {
      _selectedVisibilityStatus = false;
    }
    if (_selectedFromAssist != null &&
        _selectedToAssist!.account.companydomainname ==
            _selectedFromAssist!.account.companydomainname) {
      _toDotooltip =
          "Private items will be visible only to the Sender and Receiver within your company";
    } else {
      _toDotooltip =
          "Private items will be visible only to the Sender, Receiver and the Advisor";
    }

    notifyListeners();
  }

  List<EmployerAssist> employerAssistList = [];

  /*  Future<void> setEmployerAssistList() async {
    /* for (var element in launchpacks) {
      var returnIndex =
          employerAssistList.indexWhere((obj) => obj.code == element.fromcode);
      var returnIndex1 =
          employerAssistList.indexWhere((obj) => obj.code == element.tocode);
      if (returnIndex < 0) {
        employerAssistList.add(
            EmployerAssist(code: element.fromcode, name: element.fromname));
      }
      if (returnIndex1 < 0) {
        employerAssistList
            .add(EmployerAssist(code: element.tocode, name: element.toname));
      }
    } */
    employerAssistList.clear();
    List<Account> accounts = await HttpService()
        .readAccountsAssociatedtoEmployer(
            launchpacks[0].accountcode, launchpacks[0].employercode);

    accounts.map((acc) {
      employerAssistList
          .add(EmployerAssist(code: acc.accountcode, name: acc.accountname));
    });

    notifyListeners();
  } */

  void setSelectedOption(int index, EmployerAssist value) {
    employerAssistList[index] = value;
    notifyListeners();
  }

  bool _selectedVisibilityStatus = false;
  bool get selectedVisibilityStatus => _selectedVisibilityStatus;

  set selectedVisibilityStatus(bool obj) {
    _selectedVisibilityStatus = obj;
    notifyListeners();
  }

  List<VisibilityStatus> visibileStatusList = [];

  Future<void> loadVisibleStatusList() async {
    visibileStatusList.clear();
    visibileStatusList.add(VisibilityStatus(code: 'self', name: 'Self'));
    visibileStatusList.add(VisibilityStatus(code: 'private', name: 'Private'));
    visibileStatusList.add(VisibilityStatus(code: 'public', name: 'Public'));
    notifyListeners();
  }

  void setVisibilityStatus(int index, VisibilityStatus value) {
    visibileStatusList[index].code = value.code;
    notifyListeners();
  }

  void setAttachmentType(int index, AttachmentType value) {
    actionlaunchpacks[index].attachmenttype = value.code;
    notifyListeners();
  }

  List<LaunchStatus> launchStatusList = [];

  Future<void> getLaunchStatusList() async {
    launchStatusList.clear();
    launchStatusList.add(
        LaunchStatus(code: 'InProgress', name: 'In Progress', key: 'file'));
    launchStatusList
        .add(LaunchStatus(code: 'complete', name: 'Complete', key: 'file'));
    launchStatusList
        .add(LaunchStatus(code: 'hold', name: 'On Hold', key: 'file'));
    launchStatusList
        .add(LaunchStatus(code: 'notsent', name: 'Not sent', key: 'file'));

    launchStatusList
        .add(LaunchStatus(code: 'none', name: 'Not sent', key: 'none'));
    launchStatusList.add(
        LaunchStatus(code: 'noneInProgress', name: 'In Progress', key: 'none'));
    launchStatusList
        .add(LaunchStatus(code: 'nonecomplete', name: 'Complete', key: 'none'));
    launchStatusList
        .add(LaunchStatus(code: 'nonehold', name: 'On Hold', key: 'none'));

    launchStatusList.add(LaunchStatus(
        code: 'esigninprogress', name: 'In Progress', key: 'esign'));
    launchStatusList.add(
        LaunchStatus(code: 'esigncanceled', name: 'Canceled', key: 'esign'));
    launchStatusList.add(
        LaunchStatus(code: 'esigncomplete', name: 'Complete', key: 'esign'));
    notifyListeners();
  }

  List<AttachmentType> attachmentTypeList = [];

  Future<void> getAttachmentTypeList() async {
    attachmentTypeList.clear();
    attachmentTypeList.add(AttachmentType(code: 'file', name: 'File'));
    attachmentTypeList.add(AttachmentType(code: 'esign', name: 'esign'));
    attachmentTypeList.add(AttachmentType(code: 'none', name: 'None'));

    //notifyListeners();
  }

  void setLaunchStatus(int index, LaunchStatus value) {
    launchpacks[index].formstatus = value.code;
    notifyListeners();
  }

  void setLaunchDueDate(int index, DateTime value) {
    launchpacks[index].duedate = value.toString();
    notifyListeners();
  }

  String defaultcompanylogo =
      'https://advisorformsftp.blob.core.windows.net/advisorimages/employerlogo/default.png';

  List<EmployerProfile> _employerprofiles = [];
  List<EmployerProfile> get employerprofiles => _employerprofiles;

  bool _uploadingLogo = false;
  bool get uploadingLogo => _uploadingLogo;

  set uploadingLogo(bool obj) {
    _uploadingLogo = obj;
    notifyListeners();
  }

  Future<void> uploadEmployerLogo(EmployerProfile obj) async {
    try {
      uploadingLogo = true;
      await HttpService().uploadEmployerLogo(obj);
      obj.companylogo = "$basePathOfLogo${obj.employerCode}.png";
      uploadingLogo = false;

      int indexValue = employerprofiles
          .indexWhere((e) => e.employerCode == obj.employerCode);
      employerprofiles.removeAt(indexValue);
      employerprofiles.add(obj);
      selectedEmployerProfile = obj;
      notifyListeners();
    } catch (e) {
      uploadingLogo = false;
    }
  }
}
