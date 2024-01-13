import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class SLEmployerForm extends StatelessWidget {
  const SLEmployerForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final formKey = GlobalKey<FormState>();
    double screenWidth = SizeConfig.screenWidth / 2.5;
    EdgeInsets paddingConfig = const EdgeInsets.all(4);
    List<Partner> selectedPartners = [];
    //final GlobalKey<TextFieldAutoCompleteState<String>> key = GlobalKey();
    var master = Provider.of<MasterProvider>(context, listen: false);
    final prvEntry = Provider.of<EmployerProvider>(context, listen: false);
    CompanyCategory objInviteWithCategory = master.companycategories
        .firstWhere((e) => e.categoryname == 'Employer');
    /* Company selectedCompany;
    selectedCompany = master.companies.firstWhere(
        (e) => e.companydomain == prvEntry.selectedEmployer!.companydomainname,
        orElse: () {
      return Company();
    }); */
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Padding(
                padding: paddingConfig,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: Tooltip(
                        message:
                            'Please invite the main executive from your Employer client \nwho can serve as the primary account owner for their organization.',
                        decoration: tooltipdecoration,
                        textStyle: const TextStyle(color: AppColors.black),
                        child: TextFormField(
                          readOnly: (prvEntry.selectedEmployer!
                                      .decisionmakeremailinvitationstatus
                                      .toUpperCase() ==
                                  'JOINED' ||
                              prvEntry.selectedEmployer!
                                      .decisionmakeremailinvitationstatus
                                      .toUpperCase() ==
                                  'INVITED'),
                          controller: prvEntry.decisionmakerController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: CustomTextDecoration.emailDecoration(
                              'First Contact:',
                              const Icon(
                                Icons.email,
                                color: AppColors.secondary,
                              ),
                              true),
                          validator: (value) {
                            /* if (value!.isNotEmpty) {
                              if (!validateEmailDomain(value,
                                  prvEntry.companydomainnameController.text)) {
                                return 'Incorrect Domain In Decision maker Email.';
                              }
                            } */
                            if (value!.isEmpty) {
                              return 'Please Enter Email Id.';
                            }
                            if (!isEmailValid(value)) {
                              return 'Invalid Email Format.';
                            }
                            if (checkProhibitedEmailDomain(value) == true) {
                              return 'Email With Domain: ${value.split('@')[1]} Is Not Allowed.';
                            }

                            return null;
                          },
                        ),
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
                            child: buttonText == 'Send'
                                ? const Text('')
                                : ElevatedButton(
                                    style: getButtonStyle(buttonText),
                                    onPressed: () async {
                                      /*  if (buttonText == 'Send') {
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
                                 */
                                    },
                                    child: Text(prvDM.sendingEmail
                                        ? 'Sending Email...'
                                        : buttonText) /* prvDM.sendingEmail
                                  ? displaySpin()
                                  : Text(buttonText) */
                                    ,
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
                      child: Tooltip(
                        message:
                            'Please invite an additional person from your Employer client organization.',
                        decoration: tooltipdecoration,
                        textStyle: const TextStyle(color: AppColors.black),
                        child: TextFormField(
                          readOnly: (prvEntry.selectedEmployer!
                                      .contractsignatoryemailinvitationstatus
                                      .toUpperCase() ==
                                  "INVITED" ||
                              prvEntry.selectedEmployer!
                                      .contractsignatoryemailinvitationstatus
                                      .toUpperCase() ==
                                  "JOINED"),
                          controller: prvEntry.contractsignatoryController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: CustomTextDecoration.textDecoration(
                            'Second Contact (optional):',
                            const Icon(
                              Icons.email,
                              color: AppColors.secondary,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isNotEmpty && value.contains('@')) {
                              if (!isEmailValid(value)) {
                                return 'Invalid Email Format.';
                              }
                              if (prvEntry
                                  .decisionmakerController.text.isEmpty) {
                                return 'Please Enter Recipient To Email Id.';
                              }
                              if (checkProhibitedEmailDomain(value) == true) {
                                return 'Email With Domain: ${value.split('@')[1]} Is Not Allowed.';
                              }
                              if (!validateEmailDomain(
                                  value,
                                  prvEntry.decisionmakerController.text
                                      .split('@')[1])) {
                                return 'Email Domain Must Be Same As To Recipient Email.';
                              }
                              if (!isSingleValidEmail(value)) {
                                return 'Plese Enter Only One Email Id.';
                              }
                            }

                            return null;
                          },
                        ),
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
                            child: buttonText == 'Send'
                                ? const Text('')
                                : ElevatedButton(
                                    style: getButtonStyle(buttonText),
                                    onPressed: () async {
                                      /* if (buttonText == 'Send') {
                                  

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
                                } */
                                    },
                                    child: Text(prvCS.sendingEmail1
                                        ? 'Sending Email...'
                                        : buttonText) /* prvCS.sendingEmail1
                                  ? displaySpin()
                                  : Text(buttonText) */
                                    ,
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
                        onPressed: prvEntry.selectedEmployer!.launchstatus ==
                                'SENTLAUNCHPACK'
                            ? null
                            : () async {
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
              /* Padding(
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
                                enabled: (obj.typecode != 'select'),
                                child: Text(
                                  obj.typename,
                                  style: TextStyle(
                                      color: (obj.typecode == 'select')
                                          ? AppColors.iconGray
                                          : AppColors.black),
                                ),
                              );
                            })
                            .toSet()
                            .toList(),
                      ),
                    ),
                  );
                }),
              ), */
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
                        child: Tooltip(
                          message:
                              'Please select specific service Partners serving this Employer client.\nYou can add any missing Partners from the Partners section.',
                          decoration: tooltipdecoration,
                          textStyle: const TextStyle(color: AppColors.black),
                          child: MultiSelectDialogField(
                            searchable: true,
                            dialogHeight: SizeConfig.screenHeight / 6,
                            dialogWidth: SizeConfig.screenWidth / 6,
                            listType: MultiSelectListType.LIST,
                            initialValue: (model.selectedPartners == null)
                                ? prvEntry.selectedEmployer!.partners
                                : model.selectedPartners!,
                            items: model.partners
                                .map((partner) => MultiSelectItem(
                                    partner, partner.companyname))
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
                            selectedColor:
                                const Color.fromARGB(255, 17, 53, 84),
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
                                // ignore: unnecessary_new
                                if (formKey.currentState!.validate()) {
                                  try {
                                    /*  if (prvEntry.companydomainnameController.text
                                      .isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please Enter Company Domain Name.",
                                        "Ok",
                                        "Close");

                                    return;
                                  } */

                                    /*  if (prvSave.addNew &&
                                      prvSave.invitedEmployers.isEmpty) {
                                    EliteDialog(
                                        context,
                                        "Warning",
                                        "Please send an invite to atleast one person!",
                                        "Ok",
                                        "Close");
                                    return;
                                  } */

                                    final prvLogin = Provider.of<LoginProvider>(
                                        context,
                                        listen: false);
                                    final prvMaster =
                                        Provider.of<MasterProvider>(context,
                                            listen: false);
                                    if (prvEntry
                                        .decisionmakerController.text.isEmpty) {
                                      EliteDialog(
                                          context,
                                          "Warning",
                                          "Please Enter Employer Email.",
                                          "Ok",
                                          "Close");
                                      return;
                                    }

                                    if (prvEntry.planeffectivedateController
                                        .text.isEmpty) {
                                      EliteDialog(
                                          context,
                                          "Warning",
                                          "Please Enter Plan Effective Date.",
                                          "Ok",
                                          "Close");

                                      return;
                                    }
                                    /*  if (prvMaster.selectedEmployerCompanyType!
                                        .typecode.isEmpty) {
                                      EliteDialog(
                                          context,
                                          "Warning",
                                          "Please Select Company Type!",
                                          "Ok",
                                          "Close");
                                      return;
                                    } */

                                    final prvPartner =
                                        Provider.of<PartnerProvider>(context,
                                            listen: false);
                                    selectedPartners =
                                        prvPartner.selectedPartners!;
                                    if (selectedPartners.isEmpty) {
                                      EliteDialog(
                                          context,
                                          "Warning",
                                          "Please make sure to invite and assign all partners to the employer.\nIf you don’t see a specific partner name then either you have not invited that partner or that partner has not joined the advisor platform yet.",
                                          "Ok",
                                          "Close");

                                      return;
                                    }

                                    Employer obj = prvSave.selectedEmployer!;
                                    obj.accountcode =
                                        prvLogin.logedinUser.accountcode;

                                    obj.companydomainname = prvEntry
                                        .decisionmakerController.text
                                        .split("@")[1];

                                    /*  obj.companytype = prvMaster
                                        .selectedEmployerCompanyType!.typecode;
                                    */
                                    obj.companytype = prvMaster.companytypes
                                        .firstWhere(
                                            (e) => e.typecode == 'select')
                                        .typecode;

                                    obj.planeffectivedate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(prvSave.planeffectiveDate!);

                                    obj.daytodaycontactemail =
                                        prvEntry.daytodaycontactController.text;
                                    obj.contractsignatoryemail = prvEntry
                                        .contractsignatoryController.text;
                                    obj.decisionmakeremail =
                                        prvEntry.decisionmakerController.text;
                                    obj.partners = selectedPartners;
                                    Role userRole = master.accountroles
                                        .firstWhere(
                                            (e) => e.rolename == 'User');

                                    if (prvSave.addNew) {
                                      await prvSave
                                          .addEmployer(obj, userRole,
                                              objInviteWithCategory)
                                          .then((value) => {
                                                showSnackBar(context,
                                                    "Employer Created!."),
                                              });
                                    }
                                    if (prvSave.edit) {
                                      obj.employercode = prvSave
                                          .selectedEmployer!.employercode;
                                      await prvSave
                                          .updateEmployer(obj, userRole,
                                              objInviteWithCategory)
                                          .then((value) => {
                                                showSnackBar(context,
                                                    "Employer Updated!.")
                                              });
                                    }
                                    prvSave.addNew = false;
                                    prvSave.edit = false;
                                  } catch (e) {
                                    showSnackBar(
                                        context, "${e}Transaction Fail.");
                                    //prvSave.addNew = false;
                                    //prvSave.edit = false;
                                  } finally {
                                    /*  prvEntry.addNew = false;
                                  prvEntry.edit = false; */
                                  }
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

  /* Future<void> inviteEmail(
      CompanyCategory objInviteWithCategory,
      MasterProvider master,
      EmployerProvider prvEntry,
      String role,
      String invitedEmail) async {
    Role userRole = master.accountroles.firstWhere((e) => e.rolename == 'User');
    AdvisorInvite obj = AdvisorInvite(
        invitedemail: invitedEmail,
        role: userRole,
        companycategory: objInviteWithCategory);
    obj.duration = 7;
    obj.invitationtype = 'MailTemplateTypeInviteJoin';
    await prvEntry.sendEmail(obj, role);
  } */
}
