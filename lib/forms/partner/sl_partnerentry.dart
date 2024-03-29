import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/advisorinvitation.dart';

import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SLPartnerEntry extends StatelessWidget {
  const SLPartnerEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final formKey = GlobalKey<FormState>();
    double screenWidth = SizeConfig.screenWidth / 2;
    EdgeInsets paddingConfig = const EdgeInsets.all(4);
    //GlobalKey<TextFieldAutoCompleteState<String>> key = GlobalKey();
    var master = Provider.of<MasterProvider>(context, listen: false);
    CompanyCategory objPartnerCategory =
        master.companycategories.firstWhere((j) => j.categorycode == 'select');

    CompanyCategory objInviteWithCategory =
        master.companycategories.firstWhere((e) => e.basecategorycode == 'tpa');

    final prvPartner = Provider.of<PartnerProvider>(context, listen: false);
    if (prvPartner.edit) {
      prvPartner.partnerdomainnameController.text =
          prvPartner.selectedPartner!.partnerdomainname;
      prvPartner.salesLeadEmailController.text =
          prvPartner.selectedPartner!.salesleademail;
      prvPartner.contractSignatoryEmailController.text =
          prvPartner.selectedPartner!.contractsignatoryemail;
      prvPartner.accountLeadEmailController.text =
          prvPartner.selectedPartner!.accountleademail;
      objPartnerCategory = master.companycategories.firstWhere(
        (e) => e.categorycode == prvPartner.selectedPartner!.companycategory,
        orElse: () {
          return master.companycategories
              .firstWhere((j) => j.categorycode == 'select');
        },
      );
    }

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: paddingConfig,
            child: Consumer<PartnerProvider>(builder: (context, value, child) {
              return SizedBox(
                width: screenWidth,
                child: InputDecorator(
                  decoration: CustomDropDownDecoration.textDecoration(
                      'Select Company Category',
                      const Icon(
                        Icons.business,
                        color: AppColors.secondary,
                      ),
                      const Icon(
                        Icons.business,
                        color: Colors.transparent,
                      )),
                  child: DropdownButton<CompanyCategory>(
                    key: UniqueKey(),
                    value: (value.selectedPartnerCompanyCategory == null)
                        ? objPartnerCategory
                        : value.selectedPartnerCompanyCategory,
                    onChanged: (CompanyCategory? newValue) {
                      value.selectedPartnerCompanyCategory = newValue!;
                      objPartnerCategory = newValue;
                    },
                    items: master.companycategories
                        .map((CompanyCategory obj) {
                          return DropdownMenuItem<CompanyCategory>(
                            value: obj,
                            enabled: (obj.categoryname != 'Employer' &&
                                obj.categoryname != 'Advisor' &&
                                obj.categoryname != 'Select Company Category'),
                            child: Text(obj.categoryname,
                                style: TextStyle(
                                    color: (obj.categoryname == 'Employer' ||
                                            obj.categoryname == 'Advisor' ||
                                            obj.categorycode ==
                                                'Select Company Category')
                                        ? AppColors.iconGray
                                        : AppColors.black)),
                          );
                        })
                        .toSet()
                        .toList(),
                  ),
                ),
              );
            }),
          ),
          /* Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: SimpleTextFieldAutoComplete(
                key: key,
                suggestions:
                    master.companies.map((e) => e.companydomain).toList(),
                controller: prvPartner.partnerdomainnameController,
                decoration: CustomTextDecoration.textDecoration(
                  'Company Domain Name',
                  const Icon(
                    Icons.domain_add,
                    color: AppColors.secondary,
                  ),
                ),
                clearOnSubmit: false,
                textChanged: (data) {
                  /*  companynameController.text = '';
                  companyaddressController.text = '';
                  companyphoneController.text = ''; */
                },
                textSubmitted: ((data) {
                  prvPartner.partnerdomainnameController.text = data;
                  Company res = master.companies.firstWhere(
                    (e) => e.companydomain == data,
                    orElse: () {
                      return Company();
                    },
                  );
                  if (res.companydomain.isNotEmpty) {
                    /*  companynameController.text = res.companyname;
                    companyaddressController.text = res.companyaddress;
                    companyphoneController.text = res.companyphoneno; */
                  }
                }),
              ),
            ),
          ), */
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
                        'A Partner organization is a service provider supporting Employer clients.\nPlease invite the main executive from the Partner organization who can serve as the primary account owner for their organization.',
                    decoration: tooltipdecoration,
                    textStyle: const TextStyle(color: AppColors.black),
                    child: TextFormField(
                      readOnly: prvPartner.edit,
                      controller: prvPartner.salesLeadEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: CustomTextDecoration.textDecoration(
                        'First Contact:',
                        const Icon(
                          Icons.email,
                          color: AppColors.secondary,
                        ),
                      ),
                      validator: (value) {
                        /*  if (value!.isNotEmpty) {
                          if (!validateEmailDomain(value,
                              prvPartner.partnerdomainnameController.text)) {
                            return 'Incorrect Domain In Sales Lead Email.';
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

                      /*  validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Email.';
                        }
                          
                        return null;
                      }, */
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<PartnerProvider>(
                      builder: (context, prvSL, child) {
                    AdvisorInvite invitedEmail = prvSL.invitedPartners
                        .firstWhere(
                            (e) =>
                                e.invitedemail ==
                                prvPartner.salesLeadEmailController.text,
                            orElse: () => AdvisorInvite(
                                role: Role(
                                    rolecode: '', rolename: '', roletype: ''),
                                companycategory: objInviteWithCategory));
                    var buttonText = (invitedEmail.invitationstatus.isEmpty &&
                            prvSL.selectedPartner == null)
                        ? "Send"
                        : (invitedEmail.invitationstatus.isEmpty &&
                                prvSL.selectedPartner != null)
                            ? prvSL
                                .selectedPartner!.salesleademailinvitationstatus
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
                              if (prvPartner
                                  .salesLeadEmailController.text.isEmpty) {
                                EliteDialog(
                                    context,
                                    "Warning",
                                    "Please enter a valid email!",
                                    "Ok",
                                    "Close");
                                return;
                              }
                              if (prvPartner
                                  .partnerdomainnameController.text.isEmpty) {
                                EliteDialog(context, "Warning",
                                    "Please enter domain name!", "Ok", "Close");
                                return;
                              }

                              Role userRole = master.accountroles
                                  .firstWhere((e) => e.rolename == 'User');

                              AdvisorInvite obj = AdvisorInvite(
                                  role: userRole,
                                  companycategory:
                                      prvSL.selectedPartnerCompanyCategory!);
                              obj.duration = 7;
                              obj.invitedemail =
                                  prvPartner.salesLeadEmailController.text;
                              obj.invitationtype = 'MailTemplateTypeInviteJoin';

                              await prvPartner
                                  .sendEmail(obj, 'SALESLEAD')
                                  .then((value) => {
                                        prvPartner.selectedPartner!
                                                .salesleademailinvitationstatus =
                                            'INVITED',
                                        showSnackBar(context,
                                            'Invitation Sent Successfully!')
                                      });
                            } */
                                },
                                child: Text(prvSL.sendingEmail
                                    ? 'Sending Email...'
                                    : buttonText),
                              ));
                  }),
                )
              ],
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Tooltip(
                    message:
                        'Please invite an additional person from the Partner organization.',
                    decoration: tooltipdecoration,
                    textStyle: const TextStyle(color: AppColors.black),
                    child: TextFormField(
                      readOnly: (prvPartner.selectedPartner!
                                  .contractsignatoryemailinvitationstatus
                                  .toUpperCase() ==
                              "JOINED" ||
                          prvPartner.selectedPartner!
                                  .contractsignatoryemailinvitationstatus
                                  .toUpperCase() ==
                              "INVITED"),
                      controller: prvPartner.contractSignatoryEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: CustomTextDecoration.textDecoration(
                        'Second Contact (Optional):',
                        const Icon(
                          Icons.email,
                          color: AppColors.secondary,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (!isEmailValid(value)) {
                            return 'Invalid Email Format.';
                          }
                          if (prvPartner
                              .salesLeadEmailController.text.isEmpty) {
                            return 'Please Enter Recipient To Email Id.';
                          }
                          if (checkProhibitedEmailDomain(value) == true) {
                            return 'Email With Domain: ${value.split('@')[1]} Is Not Allowed.';
                          }
                          if (!validateEmailDomain(
                              value,
                              prvPartner.salesLeadEmailController.text
                                  .split('@')[1])) {
                            return 'Email Domain Must Be Same As To Recipient Email.';
                          }
                        }

                        return null;
                      },

                      /*  validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Contract Signatory Email.';
                        }
                        
                        return null;
                      }, */
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<PartnerProvider>(
                      builder: (context, prvCS, child) {
                    AdvisorInvite invitedEmail = prvCS.invitedPartners
                        .firstWhere(
                            (e) =>
                                e.invitedemail ==
                                prvPartner
                                    .contractSignatoryEmailController.text,
                            orElse: () => AdvisorInvite(
                                role: Role(
                                    rolecode: '', rolename: '', roletype: ''),
                                companycategory: objInviteWithCategory));
                    var buttonText = (invitedEmail.invitationstatus.isEmpty &&
                            prvCS.selectedPartner == null)
                        ? "Send"
                        : (invitedEmail.invitationstatus.isEmpty &&
                                prvCS.selectedPartner != null)
                            ? prvCS.selectedPartner!
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
                              if (prvCS.selectedPartnerCompanyCategory ==
                                  null) {
                                EliteDialog(
                                    context,
                                    "Warning",
                                    "Please select company category!",
                                    "Ok",
                                    "Close");
                                return;
                              }
                              if (prvPartner.contractSignatoryEmailController
                                  .text.isEmpty) {
                                EliteDialog(
                                    context,
                                    "Warning",
                                    "Please enter a valid email id!",
                                    "Ok",
                                    "Close");
                                return;
                              }
                              if (prvPartner
                                  .partnerdomainnameController.text.isEmpty) {
                                EliteDialog(context, "Warning",
                                    "Please enter domain name!", "Ok", "Close");
                                return;
                              }

                              Role userRole = master.accountroles
                                  .firstWhere((e) => e.rolename == 'User');

                              AdvisorInvite obj = AdvisorInvite(
                                  role: userRole,
                                  companycategory:
                                      prvCS.selectedPartnerCompanyCategory!);
                              obj.duration = 7;
                              obj.invitedemail = prvPartner
                                  .contractSignatoryEmailController.text;
                              obj.invitationtype = 'MailTemplateTypeInviteJoin';

                              await prvPartner
                                  .sendEmail(obj, 'CONTRACTSIGNATORY')
                                  .then((value) => {
                                        prvPartner.selectedPartner!
                                                .contractsignatoryemailinvitationstatus =
                                            'INVITED',
                                        showSnackBar(context,
                                            'Invitation Sent Successfully!')
                                      });
                            } */
                                },
                                child: prvCS.sendingEmail1
                                    ? displaySpin()
                                    : Text(prvCS.sendingEmail1
                                        ? 'Sending Email...'
                                        : buttonText),
                              ));
                  }),
                )
              ],
            ),
          ),
          /* Padding(
            padding: paddingConfig,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: TextFormField(
                    readOnly: (prvPartner.accountLeadEmailController.text
                        .trim()
                        .isNotEmpty),
                    controller: prvPartner.accountLeadEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: CustomTextDecoration.textDecoration(
                      'Account Lead Email.',
                      const Icon(
                        Icons.email,
                        color: AppColors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!validateEmailDomain(value,
                            prvPartner.partnerdomainnameController.text)) {
                          return 'Incorrect Domain In Account Lead Email.';
                        }
                      }

                      return null;
                    },

                    /*  validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Email.';
                      }
        
                      return null;
                    }, */
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<PartnerProvider>(
                      builder: (context, prvAL, child) {
                    AdvisorInvite invitedEmail = prvAL.invitedPartners
                        .firstWhere(
                            (e) =>
                                e.invitedemail ==
                                prvPartner.accountLeadEmailController.text,
                            orElse: () => AdvisorInvite(
                                role: Role(
                                    rolecode: '', rolename: '', roletype: ''),
                                companycategory: objInviteWithCategory));
                    var buttonText = (invitedEmail.invitationstatus.isEmpty &&
                            prvAL.selectedPartner == null)
                        ? "Send"
                        : (invitedEmail.invitationstatus.isEmpty &&
                                prvAL.selectedPartner != null)
                            ? prvAL.selectedPartner!
                                .accountleademailinvitationstatus
                            : invitedEmail.invitationstatus;
                    if (buttonText.isEmpty) {
                      buttonText = "Send";
                    }

                    return SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            style: getButtonStyle(buttonText),
                            child: prvAL.sendingEmail2
                                ? displaySpin()
                                : Text(buttonText),
                            onPressed: () async {
                              if (buttonText == 'Send') {
                                if (prvAL.selectedPartnerCompanyCategory ==
                                    null) {
                                  EliteDialog(
                                      context,
                                      "Warning",
                                      "Please select company category!",
                                      "Ok",
                                      "Close");
                                  return;
                                }
                                if (prvAL.selectedPartnerCompanyCategory ==
                                    null) {
                                  EliteDialog(
                                      context,
                                      "Warning",
                                      "Please select company category!",
                                      "Ok",
                                      "Close");
                                  return;
                                }
                                if (prvPartner
                                    .accountLeadEmailController.text.isEmpty) {
                                  EliteDialog(
                                      context,
                                      "Warning",
                                      "Please enter a valid email!",
                                      "Ok",
                                      "Close");

                                  return;
                                }
                                if (prvPartner
                                    .partnerdomainnameController.text.isEmpty) {
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
                                    companycategory:
                                        prvAL.selectedPartnerCompanyCategory!);
                                obj.duration = 7;
                                obj.invitedemail =
                                    prvPartner.accountLeadEmailController.text;
                                obj.invitationtype =
                                    'MailTemplateTypeInviteJoin';

                                await prvPartner
                                    .sendEmail(obj, 'ACCOUNTLEAD')
                                    .then((value) => {
                                          prvPartner.selectedPartner!
                                                  .accountleademailinvitationstatus =
                                              'INVITED',
                                          showSnackBar(context,
                                              'Invitation Sent Successfully!')
                                        });
                              }
                            }));
                  }),
                ),
              ],
            ),
          ), */

          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(
              width: screenWidth,
              child: Align(
                alignment: const Alignment(0, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Consumer<PartnerProvider>(
                          builder: (context, prvSave, child) {
                        return ElevatedButton(
                          style: buttonStyleGreen,
                          onPressed: (prvSave.adding || prvSave.updating)
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      if (objPartnerCategory.categorycode ==
                                          'select') {
                                        EliteDialog(
                                            context,
                                            "Warning",
                                            "Please Select Company Category!",
                                            "Ok",
                                            "Close");
                                        return;
                                      }

                                      final prvLogin =
                                          Provider.of<LoginProvider>(context,
                                              listen: false);

                                      Partner obj = Partner();
                                      obj.accountcode =
                                          prvLogin.logedinUser.accountcode;
                                      obj.partnerdomainname = prvPartner
                                          .salesLeadEmailController.text
                                          .split("@")[1];
                                      obj.companyname = '';
                                      //obj.companyname = companynameController.text;
                                      obj.companycategory = prvSave
                                              .selectedPartnerCompanyCategory!
                                              .categorycode
                                              .isEmpty
                                          ? objPartnerCategory.categorycode
                                          : prvSave
                                              .selectedPartnerCompanyCategory!
                                              .categorycode;
                                      obj.companyaddress = '';
                                      obj.companyphonenumber = '';
                                      obj.salesleademail = prvPartner
                                          .salesLeadEmailController.text;
                                      obj.contractsignatoryemail = prvPartner
                                          .contractSignatoryEmailController
                                          .text;
                                      obj.accountleademail = prvPartner
                                          .accountLeadEmailController.text;
                                      if (prvSave.addNew) {
                                        Role userRole = master.accountroles
                                            .firstWhere(
                                                (e) => e.rolename == 'User');

                                        await prvSave
                                            .addPartner(
                                                obj,
                                                userRole,
                                                prvSave
                                                    .selectedPartnerCompanyCategory)
                                            .then((value) => {
                                                  showSnackBar(context,
                                                      "Partner Created!."),
                                                  prvSave.addNew = false
                                                });
                                      }
                                      if (prvSave.edit) {
                                        obj.partnercode = prvSave
                                            .selectedPartner!.partnercode;
                                        obj.accountleademailinvitationstatus =
                                            prvSave.selectedPartner!
                                                .accountleademailinvitationstatus;
                                        obj.salesleademailinvitationstatus =
                                            prvSave.selectedPartner!
                                                .salesleademailinvitationstatus;
                                        obj.contractsignatoryemailinvitationstatus =
                                            prvSave.selectedPartner!
                                                .contractsignatoryemailinvitationstatus;
                                        obj.companycategory = prvSave
                                                .selectedPartnerCompanyCategory!
                                                .categorycode
                                                .isEmpty
                                            ? objPartnerCategory.categorycode
                                            : prvSave
                                                .selectedPartnerCompanyCategory!
                                                .categorycode;
                                        prvSave.selectedPartner = obj;

                                        await prvSave.updatePartner(obj).then(
                                          (value) {
                                            showSnackBar(
                                                context, "Partner Updated!.");
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      showSnackBar(
                                          context, "Unable to update Partner.");
                                    } finally {
                                      /*   prvPartner.addNew = false;
                                    prvPartner.edit = false; */
                                    }
                                  }
                                },
                          child: (prvSave.adding || prvSave.updating)
                              ? displaySpin()
                              : Text(
                                  (prvSave.edit) ? 'Update' : 'Save',
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                        );
                      }),
                    ),
                    SizedBox(
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
                          prvPartner.addNew = false;
                          prvPartner.edit = false;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
