import 'dart:convert';

import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/employerassistant.dart';
import 'package:advisorapp/models/esign/anonymousesignentry.dart';
import 'package:advisorapp/models/esign/anonymousmodel.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/esign/esigndocument.dart';
import 'package:advisorapp/models/launchpack.dart';
import 'package:advisorapp/models/launchstatus.dart';
import 'package:advisorapp/models/visibilitystatus.dart';
import 'package:advisorapp/service/esignservice.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';
import '../models/account.dart';
import 'dart:html' as html;

class RoomsProvider extends ChangeNotifier {
  TextEditingController anonymousemailController = TextEditingController();
  TextEditingController anonymousfirstnameController = TextEditingController();
  TextEditingController anonymouslastnameController = TextEditingController();

  late List<AnonymousEsignEntry> _anonymousEntries = [];
  List<AnonymousEsignEntry> get anonymousEntries => _anonymousEntries;
  bool _readingAnonymousEntries = false;
  bool get readingAnonymousEntries => _readingAnonymousEntries;
  set readingAnonymousEntries(bool obj) {
    _readingAnonymousEntries = obj;
    notifyListeners();
  }

  Future<void> readAnonymousEsignEntries(String accountcode) async {
    try {
      _readingAnonymousEntries = true;
      _anonymousEntries.clear();
      await EsignService()
          .getAnonymousList(accountcode)
          .then((value) => {_anonymousEntries = value!});
      _readingAnonymousEntries = false;
      notifyListeners();
    } catch (e) {
      _readingAnonymousEntries = false;
    }
  }

  bool _newEsign = false;
  bool get newEsign => _newEsign;

  set newEsign(bool obj) {
    _newEsign = obj;
    notifyListeners();
  }

  bool _uploadingDocument = false;
  bool get uploadingDocument => _uploadingDocument;

  set uploadingDocument(bool obj) {
    _uploadingDocument = obj;
    notifyListeners();
  }

  /*  ESignEmbeddedResponse? _esignembededdata;
  ESignEmbeddedResponse? get esignembededdata => _esignembededdata;
  set esignembededdata(ESignEmbeddedResponse? obj) {
    _esignembededdata = obj;
    notifyListeners();
  } */

  /*  Future<ESignEmbeddedResponse> generateESignEmbeddedURL(
      documentid, formdefinitionid) async {
    _esignembededdata = await EsignService()
        .generateESignEmbeddedURL(documentid, formdefinitionid);
    return _esignembededdata!;
    //notifyListeners();
  } */
  bool _viewIframe = false;
  bool get viewIframe => _viewIframe;
  set viewIframe(bool obj) {
    _viewIframe = obj;
    notifyListeners();
  }

  AnonymousModel? _anonymousUser;
  AnonymousModel? get anonymousUser => _anonymousUser;
  set anonymousUser(AnonymousModel? obj) {
    _anonymousUser = obj;
    notifyListeners();
  }

  Future<void> uploadAnonymousDocumentGenerateEmbedURL(
      AnonymousModel obj) async {
    try {
      _uploadingDocument = true;
      _anonymousUser =
          await EsignService().uploadAnonymousDocumentGenerateEmbedURL(obj);
      _uploadingDocument = false;

      notifyListeners();
    } catch (e) {
      _uploadingDocument = false;
    }
  }

  bool _startESign = false;
  bool get startESign => _startESign;

  set startESign(bool obj) {
    _startESign = obj;
    notifyListeners();
  }

  Future<void> startAnonESignatureProcess(AnonymousModel obj) async {
    try {
      _startESign = true;
      _anonymousUser = await EsignService().startAnonESignatureProcess(obj);
      _startESign = false;

      notifyListeners();
    } catch (e) {
      _startESign = false;
    }
  }

  Future<AnonymousModel> pickAnonymousUserFile(AnonymousModel obj) async {
    final input = html.InputElement(type: 'file');
    // MyFile objdummy = MyFile(name: '', base64: '', fileextension: '');
    input.click();
    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final file = input.files?.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file!);
      await reader.onLoad.first;

      final encoded = base64Encode(reader.result as List<int>);
      //final fileext = ".${file.name.toString().split('.')[1]}";

      obj.documentname = file.name;
      obj.filebase64 = encoded;
      obj.contentmimetype = file.type;
      return obj;

      /*   notifyListeners(); */
    }
    return obj;
  }

  List<LaunchStatus> launchStatusList = [];

  Future<void> getLaunchStausList() async {
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
    // notifyListeners();
  }

  List<AttachmentType> attachmentTypeList = [];

  Future<void> getAttachmentTypeList() async {
    attachmentTypeList.clear();
    attachmentTypeList.add(AttachmentType(code: 'file', name: 'File'));
    attachmentTypeList.add(AttachmentType(code: 'esign', name: 'eSign'));
    attachmentTypeList.add(AttachmentType(code: 'none', name: 'None'));

    //notifyListeners();
  }

  void setAttachmentType(int index, AttachmentType value) {
    actionlaunchpacks[index].attachmenttype = value.code;
    notifyListeners();
  }

  List<VisibilityStatus> visibileStatusList = [];
  Future<void> loadVisibleStatusList() async {
    visibileStatusList.clear();
    visibileStatusList.add(VisibilityStatus(code: 'self', name: 'Self'));
    visibileStatusList.add(VisibilityStatus(code: 'private', name: 'Private'));
    visibileStatusList.add(VisibilityStatus(code: 'public', name: 'Public'));
    // notifyListeners();
  }

  List<Employer> _employers = [];
  List<Employer> get employers => _employers;
  Employer? _selectedEmployer;
  Employer? get selectedEmployer => _selectedEmployer;

  /*  bool _readingRooms = false;
  bool get readingRooms => _readingRooms;

  set readingRooms(bool obj) {
    _readingRooms = obj;
    notifyListeners();
  } */
  bool readingRooms = false;

  Future<void> clearEmployees() async {
    _employers.clear();
    notifyListeners();
  }

  Future<void> clearLaunchPacks() async {
    _launchpacks.clear();
    notifyListeners();
  }

  Future<void> readRooms(String email) async {
    try {
      readingRooms = true;
      _employers.clear();
      await HttpService()
          .readRooms(email)
          .then((value) => {_employers = value});
      readingRooms = false;
      notifyListeners();
    } catch (e) {
      readingRooms = false;
    }
  }

  List<EmployerAssist> employerAssistList = [];

  Future<void> readAccountsAssociatedtoEmployer(
      accountcode, employercode) async {
    try {
      employerAssistList.clear();
      List<Account> accounts = await HttpService()
          .readAccountsAssociatedtoEmployer(accountcode, employercode);
      employerAssistList = accounts
          .map((oJson) => EmployerAssist.fromJson(oJson.toJson()))
          .toList();
      notifyListeners();
    } catch (e) {
      employerAssistList.clear();
    }
  }

  void setSelectedOption(int index, EmployerAssist value) {
    employerAssistList[index] = value;
    notifyListeners();
  }

  /*  bool _readingLaunchPack = false;
  bool get readingLaunchPack => _readingLaunchPack;

  set readingLaunchPack(bool obj) {
    _readingLaunchPack = obj;
    notifyListeners();
  }
 */
  bool readingLaunchPack = false;

  List<LaunchPack> _launchpacks = [];
  List<LaunchPack> get launchpacks => _launchpacks;
  void setLaunchStatus(int index, LaunchStatus value) {
    launchpacks[index].formstatus = value.code;
    notifyListeners();
  }

  void setLaunchDueDate(int index, DateTime value) {
    launchpacks[index].duedate = value.toString();
    notifyListeners();
  }

  bool _updatelaunchstatus = false;
  bool get updatelaunchstatus => _updatelaunchstatus;
  set updatelaunchstatus(bool obj) {
    _updatelaunchstatus = obj;
    notifyListeners();
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

  Future<void> getInitialLaunchPack(accountcode, employercode, type) async {
    try {
      readingLaunchPack = true;
      _launchpacks.clear();
      _launchpacks = await HttpService()
          .readInitialLaunchPack(accountcode, employercode, type);

      /* if (employerAssistList.isEmpty) {
        // employerAssistList.clear();
        List<Account> accounts = await HttpService()
            .readAccountsAssociatedtoEmployer(accountcode, employercode);
        employerAssistList = accounts
            .map((oJson) => EmployerAssist.fromJson(oJson.toJson()))
            .toList();
      } */

      notifyListeners();
      readingLaunchPack = false;
    } catch (e) {
      readingLaunchPack = false;
    }
  }

  DateTime? _assistDueDate = DateTime.now();
  DateTime? get assistDueDate => _assistDueDate;
  set assistDueDate(DateTime? obj) {
    _assistDueDate = obj;
    notifyListeners();
  }

  bool _selectedVisibilityStatus = false;
  bool get selectedVisibilityStatus => _selectedVisibilityStatus;

  set selectedVisibilityStatus(bool obj) {
    _selectedVisibilityStatus = obj;
    notifyListeners();
  }

  EmployerAssist? _selectedFromAssist;
  EmployerAssist? get selectedFromAssist => _selectedFromAssist;
  EmployerAssist? _selectedToAssist;
  EmployerAssist? get selectedToAssist => _selectedToAssist;

  set selectedFromAssist(EmployerAssist? obj) {
    _selectedFromAssist = obj;
    if (_selectedToAssist != null &&
        (_selectedToAssist!.account.accountcode ==
            _selectedFromAssist!.account.accountcode)) {
      _selectedVisibilityStatus = true;
    } else {
      _selectedVisibilityStatus = false;
    }
    notifyListeners();
  }

  set selectedToAssist(EmployerAssist? obj) {
    _selectedToAssist = obj;
    if (_selectedFromAssist != null &&
        (_selectedToAssist!.account.accountcode ==
            _selectedFromAssist!.account.accountcode)) {
      _selectedVisibilityStatus = true;
    } else {
      _selectedVisibilityStatus = false;
    }
    notifyListeners();
  }

  // Adding action
  List<ActionLaunchPack> _actionlaunchpacks = [];
  List<ActionLaunchPack> get actionlaunchpacks => _actionlaunchpacks;

  Future<void> pickFile(ActionLaunchPack obj, int index) async {
    final input = html.InputElement(type: 'file');
    // MyFile objdummy = MyFile(name: '', base64: '', fileextension: '');
    input.click();
    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final file = input.files?.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file!);
      await reader.onLoad.first;
      final encoded = base64Encode(reader.result as List<int>);
      final fileext = ".${file.name.toString().split('.')[1]}";
      /*  MyFile objMyFile =
          MyFile(name: file.name, base64: encoded, fileextension: fileext); */
      actionlaunchpacks[index].filename = file.name;
      actionlaunchpacks[index].fileextension = fileext;
      actionlaunchpacks[index].filebase64 = encoded;
      notifyListeners();
    }
  }

  Future<void> addActionLaunchPack() async {
    if (_actionlaunchpacks.isEmpty) {
      _actionlaunchpacks.add(ActionLaunchPack(
          filebase64: '',
          fileextension: '',
          filename: '',
          formcode: '',
          formname: '',
          attachmenttype: 'file',
          esigndocumentdata:
              ESignDocument(esigndocumentid: '', formdefinitionid: '')));
    }

    notifyListeners();
  }

  bool _savingLaunchPack = false;
  bool get savingLaunchPack => _savingLaunchPack;
  set savingLaunchPack(bool obj) {
    _savingLaunchPack = obj;
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
      });

      savingLaunchPack = false;

      notifyListeners();
    } catch (e) {
      savingLaunchPack = false;
    }
  }

  Future<void> clearActionLaunchPack() async {
    _actionlaunchpacks.clear();
    // notifyListeners();
  }

  bool insertingLaunchPack = false;
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
}
