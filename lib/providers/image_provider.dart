import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/employerprofile.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';

class EliteImageProvider extends ChangeNotifier {
  bool _uploadingEmployerLogo = false;
  bool get uploadingEmployerLogo => _uploadingEmployerLogo;

  set uploadingEmployerLogo(bool obj) {
    _uploadingEmployerLogo = obj;
    notifyListeners();
  }

  EmployerProfile? _uploadedEmployerProfile;
  EmployerProfile? get uploadedEmployerProfile => _uploadedEmployerProfile;
  set uploadedEmployerProfile(EmployerProfile? obj) {
    _uploadedEmployerProfile = obj;
    notifyListeners();
  }

  Future<void> uploadEmployerLogo(EmployerProfile obj) async {
    try {
      uploadingEmployerLogo = true;
      EmployerProfile objReturn = await HttpService().uploadEmployerLogo(obj);
      objReturn.companylogo = "$basePathOfLogo${objReturn.employerCode}.png";
      uploadedEmployerProfile = objReturn;
      uploadingEmployerLogo = false;

      notifyListeners();
    } catch (e) {
      uploadingEmployerLogo = false;
    }
  }

//PROILE PIC
  bool _uploadingPersonalLogo = false;
  bool get uploadingPersonalLogo => _uploadingPersonalLogo;

  set uploadingPersonalLogo(bool obj) {
    _uploadingPersonalLogo = obj;
    notifyListeners();
  }

  EmployerProfile? _uploadedPersonalProfile;
  EmployerProfile? get uploadedPersonalProfile => _uploadedPersonalProfile;
  set uploadedPersonalProfile(EmployerProfile? obj) {
    _uploadedPersonalProfile = obj;
    notifyListeners();
  }

  Future<void> uploadPersonalLogo(EmployerProfile obj) async {
    try {
      uploadingPersonalLogo = true;
      EmployerProfile objReturn = await HttpService().uploadEmployerLogo(obj);
      objReturn.companylogo = "$basePathOfLogo${objReturn.employerCode}.png";
      uploadedPersonalProfile = objReturn;
      uploadingPersonalLogo = false;

      notifyListeners();
    } catch (e) {
      uploadingPersonalLogo = false;
    }
  }
}
