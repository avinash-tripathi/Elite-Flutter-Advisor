import 'dart:convert';
import 'package:advisorapp/models/accountaction.dart';
import 'package:advisorapp/models/actionlaunchpack.dart';
import 'package:advisorapp/models/attachmenttype.dart';
import 'package:advisorapp/models/esign/eSignEmbeddedResponse.dart';
import 'package:advisorapp/models/esign/esigndocument.dart';
import 'package:advisorapp/models/launchstatus.dart';
import 'package:advisorapp/service/esignservice.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class LaunchProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  //'CC-20230224174603740': 'TPA'

  bool reading = false;
  // bool isSavingData = false;
  List<ActionLaunchPack> _launchpacks = [];
  List<ActionLaunchPack> get launchpacks => _launchpacks;
  List<ActionLaunchPack>? _selectedLaunchPacks;
  List<ActionLaunchPack>? get selectedLaunchPacks => _selectedLaunchPacks;

  ActionLaunchPack? _selectedLaunchPack;
  ActionLaunchPack? get selectedLaunchPack => _selectedLaunchPack;

  set selectedLaunchPack(ActionLaunchPack? obj) {
    _selectedLaunchPack = obj;
    notifyListeners();
  }

  Map<int, bool> _accountActionIndexSaved = {};

  void setAccountActionIndexSaved(int index, bool isLoading) {
    _accountActionIndexSaved[index] = isLoading;
    notifyListeners();
  }

  bool accountActionIndexSaved(int index) {
    return _accountActionIndexSaved[index] ?? false;
  }

  void resetAccountActionIndexSaved() {
    _accountActionIndexSaved.forEach((key, _) {
      _accountActionIndexSaved[key] = false;
    });
    notifyListeners();
  }

  AccountAction? _savedAccountAction;
  AccountAction? get savedAccountAction => _savedAccountAction;

  set savedAccountAction(AccountAction? obj) {
    _savedAccountAction = obj;
    notifyListeners();
  }

  Map<int, bool> _isaccoutActionSaved = {};

  void setaccountActionSaved(int index, bool isSaving) {
    _isaccoutActionSaved[index] = isSaving;
    notifyListeners();
  }

  bool accountActionSaved(int index) {
    return _isaccoutActionSaved[index] ?? false;
  }

  set selectedLaunchPacks(List<ActionLaunchPack>? obj) {
    _selectedLaunchPacks = obj;
    notifyListeners();
  }

  Future<void> removeAndInsertLaunchPack(
      ActionLaunchPack obj, int index) async {
    _launchpacks.removeAt(index);
    _launchpacks.insert(index, obj);
    notifyListeners();
  }

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
      //print(file.type);
      /*  MyFile objMyFile =
          MyFile(name: file.name, base64: encoded, fileextension: fileext); */
      _launchpacks[index].filename = file.name;
      _launchpacks[index].fileextension = fileext;
      _launchpacks[index].filebase64 = encoded;
      _launchpacks[index].contentmimetype = file.type;

      notifyListeners();
    }
  }

  dynamic _esigndocument;
  dynamic get esigndocument => _esigndocument;
  set esigndocument(dynamic obj) {
    _esigndocument = obj;
    notifyListeners();
  }

  bool _viewIframe = false;
  bool get viewIframe => _viewIframe;
  set viewIframe(dynamic obj) {
    _viewIframe = obj;
    notifyListeners();
  }

  Future<dynamic> downloadEsignDocument(documentid) async {
    _esigndocument = await EsignService().downloadEsignDocument(documentid);
    notifyListeners();
  }

  ESignEmbeddedResponse? _esignembededdata;
  ESignEmbeddedResponse? get esignembededdata => _esignembededdata;
  set esignembededdata(ESignEmbeddedResponse? obj) {
    _esignembededdata = obj;
    notifyListeners();
  }

  Future<ESignEmbeddedResponse> generateESignEmbeddedURL(
      documentid, formdefinitionid) async {
    _esignembededdata = await EsignService()
        .generateESignEmbeddedURL(documentid, formdefinitionid);
    return _esignembededdata!;
    //notifyListeners();
  }

  /* bool _newAction = false;
  bool get newAction => _newAction;
  set newAction(dynamic obj) {
    _newAction = obj;
    notifyListeners();
  } */

  Future<void> addLaunchPack() async {
    _launchpacks.add(ActionLaunchPack(
        filebase64: '',
        fileextension: '',
        filename: '',
        formcode: '',
        formname: '',
        itemstatus: 'active',
        attachmenttype: 'none',
        esigndocumentdata:
            ESignDocument(esigndocumentid: '', formdefinitionid: ''),
        newAction: true));
    //_newAction = true;
    notifyListeners();
  }

  Future<void> saveLaunchPack(
      String accountcode, String employercode, int index) async {
    try {
      setaccountActionSaved(index, true);
      AccountAction objL = AccountAction(
          accountcode: accountcode,
          employercode: employercode,
          formfileupload: selectedLaunchPacks!);
      AccountAction returnObject = (await HttpService().addAction(objL))!;

      ActionLaunchPack? retObj = returnObject.formfileupload[0];
      _launchpacks[index].filebase64 = retObj.filebase64;

      _launchpacks[index].filename = retObj.filename;
      _launchpacks[index].formcode = retObj.formcode;
      _launchpacks[index].formname = retObj.formname;
      _launchpacks[index].fileextension = retObj.fileextension;
      _launchpacks[index].launchpack = retObj.launchpack;
      _launchpacks[index].renewalpack = retObj.renewalpack;
      _launchpacks[index].attachmenttype = retObj.attachmenttype;
      _launchpacks[index].esigndocumentdata = retObj.esigndocumentdata;

      _savedAccountAction = returnObject;
      setaccountActionSaved(index, false);
      //_newAction = false;
    } catch (e) {
      setaccountActionSaved(index, false);
      //_newAction = false;
    }

    notifyListeners();
  }

  Future<void> updateLaunchPack(
      String accountcode, String employercode, int index) async {
    try {
      setaccountActionSaved(index, true);
      AccountAction objL = AccountAction(
          accountcode: accountcode,
          employercode: employercode,
          formfileupload: selectedLaunchPacks!);
      AccountAction returnObject = (await HttpService().updateAction(objL))!;

      _savedAccountAction = returnObject;
      setaccountActionSaved(index, false);
    } catch (e) {
      setaccountActionSaved(index, false);
    }

    notifyListeners();
  }

  Future<void> removeLaunchPack(index) async {
    _launchpacks.removeAt(index);
    notifyListeners();
  }

  Future<void> readLaunchPack(accountcode, employercode) async {
    _launchpacks.clear();
    _accountActionIndexSaved.clear();
    try {
      reading = true;
      await HttpService()
          .readLaunchPackAction(accountcode, employercode)
          .then((value) => {_launchpacks = value, reading = false});
      reading = false;

      notifyListeners();
    } catch (e) {
      reading = false;
    }
  }

  List<LaunchStatus> itemStatusList = [];

  Future<void> getItemsStatus() async {
    itemStatusList.clear();
    itemStatusList
        .add(LaunchStatus(code: 'active', name: 'Active', key: 'itemstatus'));
    itemStatusList
        .add(LaunchStatus(code: 'archive', name: 'Archive', key: 'itemstatus'));
    itemStatusList.add(
        LaunchStatus(code: 'inactive', name: 'Inactive', key: 'itemstatus'));
    //notifyListeners();
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
    launchpacks[index].attachmenttype = value.code;
    notifyListeners();
  }

  void setItemStatus(int index, LaunchStatus value) {
    launchpacks[index].itemstatus = value.code;
    notifyListeners();
  }
}
