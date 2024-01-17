import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/models/basecategory.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class NewInvite extends StatelessWidget {
  const NewInvite({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double screenWidth = SizeConfig.screenWidth / 4;
    LoginProvider lPrv = Provider.of<LoginProvider>(context, listen: false);
    MasterProvider mPrv = Provider.of<MasterProvider>(context, listen: false);
    final addOtherProvider =
        Provider.of<AddotherProvider>(context, listen: false);
    bool isSending = addOtherProvider.isSending(0);

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SizedBox(
        width: SizeConfig.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 3 / 4,
              child: TextFormField(
                onChanged: (value) {
                  var isValid = checkValidEmail(value);
                  var isProhibited = checkProhibitedEmailDomain(value);
                  // Check if the domain is valid (in this example, only gmail.com is accepted)
                  if (isValid && isProhibited == false) {
                    addOtherProvider.currentInvite.invitedemail = value;
                    // addOtherProvider.emailController.text = value;
                  }

                  addOtherProvider.currentInvite.isvalid =
                      (isValid && isProhibited == false);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Email Id.';
                  }
                  if (!isEmailValid(value)) {
                    return 'Invalid Email Format.';
                  }
                  if (checkProhibitedEmailDomain(value) == true) {
                    return 'Email With Domain: \n${value.split('@')[1]} Is Not Allowed.';
                  }
                  if (ifSameDomain(
                          lPrv.logedinUser.companydomainname.isNotEmpty
                              ? lPrv.logedinUser.companydomainname
                              : lPrv.logedinUser.workemail.split('@')[1],
                          value) ==
                      true) {
                    return 'Email With Domain: \n${value.split('@')[1]} Is Not Allowed.';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.sidemenu,
                  icon: Icon(Icons.email),
                  iconColor: Colors.blue,
                  hintText: 'Invite a user with email',
                ),
                controller: addOtherProvider.emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: screenWidth * 3 / 4,
                color: AppColors.sidemenu,
                child: DropdownButton<BaseCompanyCategory>(
                  hint: const Text('Select Company Category',
                      style: hinttextstyle),
                  onChanged: (BaseCompanyCategory? newValue) {
                    if (newValue?.basecategorycode == 'employer') {}
                  },
                  value: mPrv.basecompanycategories.firstWhere((e) =>
                      e.basecategorycode ==
                      addOtherProvider
                          .currentInvite.companycategory.basecategorycode),
                  items: mPrv.basecompanycategories
                      .where((e) => e.basecategorycode == 'advisor')
                      .map((BaseCompanyCategory obj) {
                        return DropdownMenuItem<BaseCompanyCategory>(
                          value: obj,
                          child: SizedBox(
                              width: SizeConfig.screenWidth / 7,
                              child: Text(obj.basecategoryname,
                                  overflow: TextOverflow.visible)),
                        );
                      })
                      .toSet()
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: screenWidth / 4,
                  child: Consumer<AddotherProvider>(
                    builder: (context, prvSend, child) {
                      return ElevatedButton(
                        style: buttonStyleBlue,
                        onPressed: isSending
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  bool result = await EliteDialog(
                                      context,
                                      'Please confirm',
                                      'Please make sure that the invited person is an advisor. Advsiors are also known as benefits consultants or brokers.',
                                      'Ok',
                                      'Cancel');
                                  if (!result) {
                                    return;
                                  }

                                  if (addOtherProvider.currentInvite.isvalid &&
                                      addOtherProvider.currentInvite
                                          .invitedemail.isNotEmpty) {
                                    addOtherProvider.setEmailStatus(0, true);

                                    addOtherProvider.currentInvite.duration = 7;
                                    addOtherProvider
                                            .currentInvite.invitationtype =
                                        'MailTemplateTypeInviteJoin';
                                    await addOtherProvider
                                        .sendEmail(
                                            addOtherProvider.currentInvite, 0)
                                        .then((value) => {
                                              prvSend.currentInvite
                                                          .invitationstatus ==
                                                      'invited'
                                                  ? showSnackBar(context,
                                                      'Invitation Sent Successfully!')
                                                  : showSnackBar(context,
                                                      'Invitation Failed!')
                                            });
                                  }
                                }
                              },
                        child: isSending
                            ? displaySpin()
                            : (prvSend.currentInvite.invitationstatus == '')
                                ? const Text('Send', style: invitetextstyle)
                                : Text(prvSend.currentInvite.invitationstatus),
                      );
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: screenWidth / 4,
                child: ElevatedButton(
                    style: buttonStyleRed,
                    onPressed: () {
                      addOtherProvider.addNewInvite = false;
                    },
                    child: const Text('Close')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
