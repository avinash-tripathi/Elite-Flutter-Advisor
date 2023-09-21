import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/company.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_textfield_autocomplete/flutter_textfield_autocomplete.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class EmployerForm extends StatelessWidget {
  const EmployerForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final formKey = GlobalKey<FormState>();
    double screenWidth = SizeConfig.screenWidth / 2.5;
    EdgeInsets paddingConfig = const EdgeInsets.all(4);
    List<Partner> selectedPartners = [];
    final GlobalKey<TextFieldAutoCompleteState<String>> key = GlobalKey();
    var master = Provider.of<MasterProvider>(context, listen: false);
    final prvEntry = Provider.of<EmployerProvider>(context, listen: false);
    CompanyCategory objInviteWithCategory = master.companycategories
        .firstWhere((e) => e.categoryname == 'Employer');
    Company selectedCompany;
    selectedCompany = master.companies.firstWhere(
        (e) => e.companydomain == prvEntry.selectedEmployer!.companydomainname,
        orElse: () {
      return Company();
    });
    prvEntry.companydomainnameController.text =
        prvEntry.selectedEmployer!.companydomainname;
    prvEntry.decisionmakerController.text =
        prvEntry.selectedEmployer!.decisionmakeremail;
    prvEntry.contractsignatoryController.text =
        prvEntry.selectedEmployer!.contractsignatoryemail;
    prvEntry.daytodaycontactController.text =
        prvEntry.selectedEmployer!.daytodaycontactemail;
    /*   prvEntry.planeffectiveDate = DateFormat('yyyy-MM-dd')
          .parse(prvEntry.selectedEmployer!.planeffectivedate); */
    prvEntry.planeffectivedateController.text =
        convertDateString(prvEntry.selectedEmployer!.planeffectivedate);

    return Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Padding(
                padding: paddingConfig,
                child: SizedBox(
                  width: screenWidth,
                  child: SimpleTextFieldAutoComplete(
                    key: key,
                    suggestions:
                        master.companies.map((e) => e.companydomain).toList(),
                    controller: prvEntry.companydomainnameController,
                    decoration: CustomTextDecoration.textDecoration(
                      'Company Domain Name',
                      const Icon(
                        Icons.domain_add,
                        color: AppColors.secondary,
                      ),
                    ),
                    clearOnSubmit: false,
                    textChanged: (data) {},
                    textSubmitted: ((data) {
                      prvEntry.companydomainnameController.text = data;

                      Company res = master.companies.firstWhere(
                        (e) => e.companydomain == data,
                        orElse: () {
                          return Company();
                        },
                      );
                      if (res.companydomain.isNotEmpty) {}
                    }),
                  ),
                ),
              ),
              Padding(
                padding: paddingConfig,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: TextFormField(
                        controller: prvEntry.decisionmakerController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: CustomTextDecoration.textDecoration(
                          'Decision Maker Email',
                          const Icon(
                            Icons.email,
                            color: AppColors.secondary,
                          ),
                        ),
                        validator: (value) {
                          /*  if (value!.isEmpty) {
                            return 'Please Enter Decision maker Email.';
                          } */
                          if (value!.isNotEmpty) {
                            if (!validateEmailDomain(value,
                                prvEntry.companydomainnameController.text)) {
                              return 'Incorrect Domain In Decision maker Email.';
                            }
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<EmployerProvider>(
                          builder: (context, prvDM, child) {
                        AdvisorInvite invitedEmail = prvDM.invitedEmployers
                            .firstWhere(
                                (e) =>
                                    e.invitedemail ==
                                    prvEntry.decisionmakerController.text,
                                orElse: () => AdvisorInvite(
                                    role: Role(
                                        rolecode: '',
                                        rolename: '',
                                        roletype: ''),
                                    companycategory: objInviteWithCategory));
                        var buttonText =
                            (invitedEmail.invitationstatus.isEmpty &&
                                    prvDM.selectedEmployer == null)
                                ? "Send"
                                : (invitedEmail.invitationstatus.isEmpty &&
                                        prvDM.selectedEmployer != null)
                                    ? prvDM.selectedEmployer!
                                        .decisionmakeremailinvitationstatus
                                    : invitedEmail.invitationstatus;
                        if (buttonText.isEmpty) {
                          buttonText = "Send";
                        }

                        return SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: getButtonStyle(buttonText),
                              onPressed: () async {
                                if (buttonText == 'Send') {
                                  if (prvEntry
                                      .decisionmakerController.text.isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please enter a valid email!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }
                                  if (prvEntry.companydomainnameController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please enter domain name!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }
                                  Role userRole = master.accountroles
                                      .firstWhere((e) => e.rolename == 'User');
                                  AdvisorInvite obj = AdvisorInvite(
                                      role: userRole,
                                      companycategory: objInviteWithCategory);
                                  obj.duration = 7;
                                  obj.invitedemail =
                                      prvEntry.decisionmakerController.text;
                                  obj.invitationtype =
                                      'MailTemplateTypeInviteJoin';

                                  await prvEntry
                                      .sendEmail(obj, 'DECISIONMAKER')
                                      .then((value) => {
                                            prvDM.addNew
                                                ? prvEntry.currentEmployer
                                                        .decisionmakeremailinvitationstatus =
                                                    'INVITED'
                                                : prvEntry.selectedEmployer!
                                                        .decisionmakeremailinvitationstatus =
                                                    'INVITED',
                                            showSnackBar(context,
                                                'Invitation Sent Successfully!')
                                          });
                                }
                              },
                              child: prvDM.sendingEmail
                                  ? displaySpin()
                                  : Text(buttonText),
                            ));
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: paddingConfig,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: TextFormField(
                        controller: prvEntry.contractsignatoryController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: CustomTextDecoration.textDecoration(
                          'Contract Signatory Email',
                          const Icon(
                            Icons.email,
                            color: AppColors.secondary,
                          ),
                        ),
                        validator: (value) {
                          /* if (value!.isEmpty) {
                            return 'Please Enter Contract Signatory Email.';
                          } */
                          if (value!.isNotEmpty) {
                            if (!validateEmailDomain(value,
                                prvEntry.companydomainnameController.text)) {
                              return 'Incorrect Domain In Contract Signatory Email.';
                            }
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<EmployerProvider>(
                          builder: (context, prvCS, child) {
                        AdvisorInvite invitedEmail = prvCS.invitedEmployers
                            .firstWhere(
                                (e) =>
                                    e.invitedemail ==
                                    prvEntry.contractsignatoryController.text,
                                orElse: () => AdvisorInvite(
                                    role: Role(
                                        rolecode: '',
                                        rolename: '',
                                        roletype: ''),
                                    companycategory: objInviteWithCategory));
                        var buttonText =
                            (invitedEmail.invitationstatus.isEmpty &&
                                    prvCS.selectedEmployer == null)
                                ? "Send"
                                : (invitedEmail.invitationstatus.isEmpty &&
                                        prvCS.selectedEmployer != null)
                                    ? prvCS.selectedEmployer!
                                        .contractsignatoryemailinvitationstatus
                                    : invitedEmail.invitationstatus;
                        if (buttonText.isEmpty) {
                          buttonText = "Send";
                        }

                        return SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: getButtonStyle(buttonText),
                              onPressed: () async {
                                if (buttonText == 'Send') {
                                  if (prvEntry.contractsignatoryController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please enter a valid email!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }
                                  if (prvEntry.companydomainnameController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please enter domain name!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }

                                  Role userRole = master.accountroles
                                      .firstWhere((e) => e.rolename == 'User');

                                  AdvisorInvite obj = AdvisorInvite(
                                      role: userRole,
                                      companycategory: objInviteWithCategory);
                                  obj.duration = 7;
                                  obj.invitedemail =
                                      prvEntry.contractsignatoryController.text;

                                  obj.invitationtype =
                                      'MailTemplateTypeInviteJoin';

                                  await prvEntry
                                      .sendEmail(obj, 'CONTRACTSIGNATORY')
                                      .then((value) => {
                                            prvCS.addNew
                                                ? prvEntry.currentEmployer
                                                        .contractsignatoryemailinvitationstatus =
                                                    'INVITED'
                                                : prvEntry.selectedEmployer!
                                                        .contractsignatoryemailinvitationstatus =
                                                    'INVITED',
                                            showSnackBar(context,
                                                'Invitation Sent Successfully!')
                                          });
                                }
                              },
                              child: prvCS.sendingEmail1
                                  ? displaySpin()
                                  : Text(buttonText),
                            ));
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: paddingConfig,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: TextFormField(
                        controller: prvEntry.daytodaycontactController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: CustomTextDecoration.textDecoration(
                          'Day to Day Contact Email',
                          const Icon(
                            Icons.email,
                            color: AppColors.secondary,
                          ),
                        ),
                        validator: (value) {
                          /* if (value!.isEmpty) {
                            return 'Please Enter Day to Day Contact Email.';
                          } */
                          if (value!.isNotEmpty) {
                            if (!validateEmailDomain(value,
                                prvEntry.companydomainnameController.text)) {
                              return 'Incorrect Domain In Day to Day Contact Email.';
                            }
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<EmployerProvider>(
                          builder: (context, prvDD, child) {
                        AdvisorInvite invitedEmail = prvDD.invitedEmployers
                            .firstWhere(
                                (e) =>
                                    e.invitedemail ==
                                    prvEntry.daytodaycontactController.text,
                                orElse: () => AdvisorInvite(
                                    role: Role(
                                        rolecode: '',
                                        rolename: '',
                                        roletype: ''),
                                    companycategory: objInviteWithCategory));
                        var buttonText =
                            (invitedEmail.invitationstatus.isEmpty &&
                                    prvDD.selectedEmployer == null)
                                ? "Send"
                                : (invitedEmail.invitationstatus.isEmpty &&
                                        prvDD.selectedEmployer != null)
                                    ? prvDD.selectedEmployer!
                                        .daytodaycontactemailinvitationstatus
                                    : invitedEmail.invitationstatus;
                        if (buttonText.isEmpty) {
                          buttonText = "Send";
                        }

                        return SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: getButtonStyle(buttonText),
                              onPressed: () async {
                                if (buttonText == 'Send') {
                                  if (prvEntry
                                      .daytodaycontactController.text.isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please enter a valid email!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }
                                  if (prvEntry.companydomainnameController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please enter domain name!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }

                                  Role userRole = master.accountroles
                                      .firstWhere((e) => e.rolename == 'User');

                                  AdvisorInvite obj = AdvisorInvite(
                                      role: userRole,
                                      companycategory: objInviteWithCategory);
                                  obj.duration = 7;
                                  obj.invitedemail =
                                      prvEntry.daytodaycontactController.text;
                                  obj.invitationtype =
                                      'MailTemplateTypeInviteJoin';

                                  await prvEntry
                                      .sendEmail(obj, 'DAYTODAY')
                                      .then((value) => {
                                            prvDD.addNew
                                                ? prvEntry.currentEmployer
                                                        .daytodaycontactemailinvitationstatus =
                                                    'INVITED'
                                                : prvEntry.selectedEmployer!
                                                        .daytodaycontactemailinvitationstatus =
                                                    'INVITED',
                                            showSnackBar(context,
                                                'Invitation Sent Successfully!')
                                          });
                                }
                              },
                              child: prvDD.sendingEmail2
                                  ? displaySpin()
                                  : Text(buttonText),
                            ));
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: paddingConfig,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth,
                        child: Tooltip(
                          textStyle: const TextStyle(color: AppColors.black),
                          message:
                              'If you choose a date in the past, the Employer is treated as a Renewal Client.\nIf you choose a date in the future, the Employer is treated as a New Client ready for launch.',
                          decoration: tooltipdecoration,
                          child: Consumer<EmployerProvider>(
                              builder: (context, value, child) {
                            return TextFormField(
                                controller: value.planeffectivedateController,
                                readOnly: true,
                                decoration: CustomTextDecoration.textDecoration(
                                  'Plan Effective Date.',
                                  const Icon(
                                    Icons.date_range,
                                    color: AppColors.secondary,
                                  ),
                                ));
                          }),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000, 8, 1),
                            lastDate: DateTime(2101),
                          );
                          if (date != null) {
                            prvEntry.planeffectiveDate = (date);
                            prvEntry.planeffectivedateController.text =
                                DateFormat('MM-dd-yyyy')
                                    .format(date)
                                    .toString();
                          }
                        },
                        icon: const Icon(
                          Icons.date_range_sharp,
                          color: AppColors.action,
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: paddingConfig,
                child:
                    Consumer<MasterProvider>(builder: (context, value, child) {
                  return SizedBox(
                    width: screenWidth,
                    child: InputDecorator(
                      decoration: CustomDropDownDecoration.textDecoration(
                        'Select Company Type',
                        const Icon(
                          Icons.business,
                          color: AppColors.secondary,
                        ),
                        const Icon(
                          Icons.business,
                          color: Colors.transparent,
                        ),
                      ),
                      child: DropdownButton<CompanyType>(
                        value: value.selectedEmployerCompanyType,
                        onChanged: (CompanyType? newValue) {
                          value.selectedEmployerCompanyType = newValue!;
                        },
                        items: value.companytypes
                            .map((CompanyType obj) {
                              return DropdownMenuItem<CompanyType>(
                                value: obj,
                                child: Text(obj.typename),
                              );
                            })
                            .toSet()
                            .toList(),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: paddingConfig,
                child: Consumer<PartnerProvider>(
                  builder: (context, model, child) => SizedBox(
                    width: screenWidth,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        prefix: Icon(
                          FontAwesomeIcons.users,
                          color: AppColors.secondary,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: AppColors.hint,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: MultiSelectDialogField(
                          searchable: true,
                          dialogHeight: SizeConfig.screenHeight / 6,
                          dialogWidth: SizeConfig.screenWidth / 6,
                          listType: MultiSelectListType.LIST,
                          initialValue: (model.selectedPartners == null)
                              ? prvEntry.selectedEmployer!.partners
                              : model.selectedPartners!,
                          items: model.partners
                              .map((partner) =>
                                  MultiSelectItem(partner, partner.companyname))
                              .toSet()
                              .toList(),
                          title: const Text(
                            "Add Partners",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: AppColors.hint,
                            ),
                          ),
                          selectedColor: const Color.fromARGB(255, 17, 53, 84),
                          decoration: const BoxDecoration(
                            color: AppColors.sidemenu,
                          ),
                          buttonIcon: const Icon(
                            Icons.pattern,
                            color: AppColors.black,
                          ),
                          buttonText: const Text(
                            "Add Partners",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: AppColors.hint,
                            ),
                          ),
                          onConfirm: (results) {
                            model.selectedPartners = results.cast<Partner>();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: paddingConfig,
                child: SizedBox(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 150,
                          child: Consumer<EmployerProvider>(
                              builder: (context, prvSave, child) {
                            return ElevatedButton(
                              style: buttonStyleGreen,
                              child: (prvSave.adding || prvSave.updating)
                                  ? displaySpin()
                                  : Text(
                                      (prvSave.addNew) ? 'Save' : 'Update',
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                              onPressed: () async {
                                try {
                                  // ignore: unnecessary_new
                                  if (!formKey.currentState!.validate()) {
                                    showSnackBar(
                                        context, validationFailMessage);
                                    return;
                                  }
                                  if (prvEntry.companydomainnameController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please Enter Company Domain Name.",
                                        "Ok",
                                        "Close");

                                    return;
                                  }
                                  if (prvEntry.planeffectivedateController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please Enter Plan Effective Date.",
                                        "Ok",
                                        "Close");

                                    return;
                                  }

                                  if (prvSave.addNew &&
                                      prvSave.invitedEmployers.isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please send an invite to atleast one person!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }

                                  final prvLogin = Provider.of<LoginProvider>(
                                      context,
                                      listen: false);
                                  final prvMaster = Provider.of<MasterProvider>(
                                      context,
                                      listen: false);

                                  prvMaster
                                      .selectedEmployerCompanyType?.typecode;

                                  final prvPartner =
                                      Provider.of<PartnerProvider>(context,
                                          listen: false);
                                  selectedPartners =
                                      prvPartner.selectedPartners!;
                                  if (selectedPartners.isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please select at least one Partner!",
                                        "Ok",
                                        "Close");

                                    return;
                                  }
                                  if (prvMaster.selectedEmployerCompanyType!
                                      .typecode.isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please Select Company Type!",
                                        "Ok",
                                        "Close");
                                    return;
                                  }
                                  Employer obj = prvSave.selectedEmployer!;
                                  obj.accountcode =
                                      prvLogin.logedinUser.accountcode;
                                  obj.companydomainname =
                                      prvEntry.companydomainnameController.text;

                                  obj.companytype = prvMaster
                                      .selectedEmployerCompanyType!.typecode;
                                  /*  obj.companyname = companynameController.text;
                                obj.companyaddress =
                                    companyaddressController.text;
                                    obj.companyphonenumber =
                                    companyphoneController.text;
                                     */
                                  /*  obj.companyname = '';
                                  obj.companyaddress = '';
                                  obj.companyphonenumber = ''; */

                                  obj.planeffectivedate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(prvSave.planeffectiveDate!);

                                  obj.daytodaycontactemail =
                                      prvEntry.daytodaycontactController.text;
                                  obj.contractsignatoryemail =
                                      prvEntry.contractsignatoryController.text;
                                  obj.decisionmakeremail =
                                      prvEntry.decisionmakerController.text;
                                  obj.partners = selectedPartners;

                                  if (prvSave.addNew) {
                                    Role userRole = master.accountroles
                                        .firstWhere(
                                            (e) => e.rolename == 'User');
                                    await prvSave.addEmployer(
                                        obj, userRole, objInviteWithCategory);
                                    showSnackBar(context, "Employer Created!.");
                                  }
                                  if (prvSave.edit) {
                                    obj.employercode =
                                        prvSave.selectedEmployer!.employercode;
                                    //prvSave.selectedEmployer = obj;
                                    await prvSave.updateEmployer(obj);

                                    showSnackBar(context, "Employer Updated!.");
                                  }
                                } catch (e) {
                                  /*  showSnackBar(context, "Transaction Fail."); */
                                } finally {
                                  prvEntry.addNew = false;
                                  prvEntry.edit = false;
                                }
                              },
                            );
                          }),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: buttonStyleBlue,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              prvEntry.addNew = false;
                              prvEntry.edit = false;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
