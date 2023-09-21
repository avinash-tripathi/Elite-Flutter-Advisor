import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';

class AdvisorInvite {
  String invitedby;
  String invitedemail;
  String invitationstatus;
  String invitationtype;
  String invitationsendername;
  Role role;
  CompanyCategory companycategory;
  int duration;
  bool isvalid;

  AdvisorInvite(
      {this.invitedby = '0',
      this.invitedemail = '',
      this.invitationstatus = '',
      this.invitationtype = '',
      this.invitationsendername = '',
      required this.role,
      required this.companycategory,
      this.duration = 0,
      this.isvalid = false});

  factory AdvisorInvite.fromJson(Map<String, dynamic> json) {
    Role objRole = Role(rolecode: '', rolename: '', roletype: '');
    CompanyCategory objcategory = CompanyCategory(
        categorycode: '', categoryname: '', basecategorycode: '');

    List<Role> roles = (json['invitedrole'] as List).map((data) {
      return Role(
          rolecode: data['rolecode'],
          rolename: data['rolename'],
          roletype: data['roletype']);
    }).toList();
    objRole = roles[0];
    List<CompanyCategory> categories =
        (json['companycategorycode'] as List).map((data) {
      return CompanyCategory(
          categorycode: data['categorycode'],
          categoryname: data['categoryname'],
          basecategorycode: data['basecategorycode']);
    }).toList();
    objcategory = categories[0];

    return AdvisorInvite(
      invitedby: json['invitedby'] ?? '',
      invitedemail: json['invitedemail'] ?? '',
      invitationstatus: json['invitationstatus'] ?? '',
      invitationtype: json['invitationtype'] ?? '',
      invitationsendername: json['invitationsendername'] ?? '',
      role: objRole,
      companycategory: objcategory,
      isvalid: json['isvalid'] ?? false,
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['ToRecipientEmailId'] = invitedemail;
    map['MailTemplateType'] = invitationtype;
    map['invitationSenderName'] = invitationsendername;
    map['invitationDaysLeft'] = duration.toString();
    map['rolecode'] = role.rolecode;
    map['companycategory'] = companycategory.categorycode;
    return map;
  }
}
