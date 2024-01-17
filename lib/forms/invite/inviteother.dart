import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/invite/newinvite.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/basecategory.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteOther extends StatelessWidget {
  const InviteOther({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    SizeConfig().init(context);
    double screenWidth = SizeConfig.screenWidth / 4;
    MasterProvider mPrv = Provider.of<MasterProvider>(context, listen: false);
    final addOtherProvider =
        Provider.of<AddotherProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    addOtherProvider.readAdvisorInvite(lgnProvider.logedinUser.accountcode);
    return Scaffold(
      key: scaffoldKey,
      body: Background(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                flex: 2,
                child: SideMenu(
                  key: null,
                  // currentGoogleAccount: loginProvider.currentGoogleUser!,
                ),
              ),
            Expanded(
              flex: 9,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Role objRole = mPrv.accountroles
                                    .firstWhere((e) => e.rolename == 'User');
                                BaseCompanyCategory objBaseC =
                                    mPrv.basecompanycategories.firstWhere(
                                        (e) => e.basecategorycode == 'advisor');
                                CompanyCategory objCat = mPrv.companycategories
                                    .firstWhere((e) =>
                                        e.basecategorycode ==
                                        objBaseC.basecategorycode);

                                /*  addOtherProvider.addFilteredEmail(
                                    objRole, objCat); */
                                addOtherProvider.newInvite(objRole, objCat);
                                addOtherProvider.addNewInvite = true;
                              },
                              child: const Text(
                                '+ Advisor platform is by invitation only. Please feel free to invite advisors from your network to join.',
                                style: appstyle,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Consumer<AddotherProvider>(
                                builder: (context, prvaddOther, child) {
                              return prvaddOther.addNewInvite
                                  ? const NewInvite()
                                  : const Text('');
                            }),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight * 3 / 4,
                              child: Consumer<AddotherProvider>(
                                  builder: (context, prvaddOther, child) {
                                /*    List<AdvisorInvite>  prvaddOther.filteredinvites =
                                    prvaddOther.filteredinvites; */
                                return prvaddOther.readingInvite
                                    ? displaySpin()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            prvaddOther.filteredinvites.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          /* int index = prvaddOther
                                                  .filteredinvites.length -
                                              1 -
                                              reversedIndex; */
                                          bool isSending =
                                              prvaddOther.isSending(index);

                                          {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: SizeConfig
                                                          .blockSizeHorizontal *
                                                      2,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 3 / 4,
                                                  child: TextFormField(
                                                    readOnly: prvaddOther
                                                        .filteredinvites[index]
                                                        .invitationstatus
                                                        .isNotEmpty,
                                                    initialValue: prvaddOther
                                                        .filteredinvites[index]
                                                        .invitedemail,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            AppColors.sidemenu,
                                                        icon: const Icon(
                                                            Icons.email),
                                                        iconColor: Colors.blue,
                                                        hintText:
                                                            'Invite a user with email',
                                                        errorText: (prvaddOther
                                                                .filteredinvites[
                                                                    index]
                                                                .isvalid)
                                                            ? ''
                                                            : 'Please enter a valid email.'),
                                                    onChanged: (value) {
                                                      var isValid =
                                                          checkValidEmail(
                                                              value);
                                                      var isProhibited =
                                                          checkProhibitedEmailDomain(
                                                              value);
                                                      // Check if the domain is valid (in this example, only gmail.com is accepted)
                                                      if (isValid &&
                                                          isProhibited ==
                                                              false) {
                                                        prvaddOther
                                                                .filteredinvites[
                                                                    index]
                                                                .invitedemail =
                                                            value;
                                                      }

                                                      prvaddOther
                                                          .setFilteredEmailValidStatus(
                                                              index,
                                                              (isValid &&
                                                                  isProhibited ==
                                                                      false));
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please Enter Email Id.';
                                                      }
                                                      if (!isEmailValid(
                                                          value)) {
                                                        return 'Invalid Email Format.';
                                                      }
                                                      if (checkProhibitedEmailDomain(
                                                              value) ==
                                                          true) {
                                                        return 'Email With Domain: ${value.split('@')[1]} Is Not Allowed.';
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 3 / 4,
                                                  child:
                                                      Consumer<MasterProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                    return value.basecompanycategories
                                                                .isEmpty ||
                                                            prvaddOther
                                                                .filteredinvites
                                                                .isEmpty
                                                        ? Container() // if the items list is empty, return an empty Container
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      3 /
                                                                      4,
                                                              color: AppColors
                                                                  .sidemenu,
                                                              child: DropdownButton<
                                                                  BaseCompanyCategory>(
                                                                key: Key(prvaddOther
                                                                    .filteredinvites[
                                                                        index]
                                                                    .role
                                                                    .rolecode),
                                                                hint: const Text(
                                                                    'Select Company Category',
                                                                    style:
                                                                        hinttextstyle),
                                                                value: (prvaddOther
                                                                        .filteredinvites[
                                                                            index]
                                                                        .companycategory
                                                                        .basecategorycode
                                                                        .isEmpty)
                                                                    ? null
                                                                    : value.basecompanycategories.firstWhere((element) =>
                                                                        element
                                                                            .basecategorycode ==
                                                                        prvaddOther
                                                                            .filteredinvites[index]
                                                                            .companycategory
                                                                            .basecategorycode),
                                                                onChanged:
                                                                    (BaseCompanyCategory?
                                                                        newValue) {
                                                                  if (newValue
                                                                          ?.basecategorycode ==
                                                                      'employer') {}
                                                                  prvaddOther.setFilteredInvitePersonCategory(
                                                                      index,
                                                                      value.companycategories.firstWhere((e) =>
                                                                          e.basecategorycode ==
                                                                          newValue
                                                                              ?.basecategorycode));
                                                                },
                                                                items: value
                                                                    .basecompanycategories
                                                                    .where((e) =>
                                                                        e.basecategorycode ==
                                                                        'advisor')
                                                                    .map((BaseCompanyCategory
                                                                        obj) {
                                                                      return DropdownMenuItem<
                                                                          BaseCompanyCategory>(
                                                                        value:
                                                                            obj,
                                                                        child: SizedBox(
                                                                            width: screenWidth * 3 / 4 -
                                                                                60,
                                                                            child:
                                                                                Text(obj.basecategoryname, overflow: TextOverflow.visible)),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          top: 8.0,
                                                          bottom: 8.0),
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: prvaddOther
                                                                .filteredinvites[
                                                                    index]
                                                                .invitationstatus ==
                                                            ""
                                                        ? ElevatedButton(
                                                            onPressed: isSending
                                                                ? null
                                                                : () async {
                                                                    try {
                                                                      if (formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        bool result = await EliteDialog(
                                                                            context,
                                                                            'Please confirm',
                                                                            'Please make sure that the invited person is an advisor.\nAdvsiors are also known as benefits consultants or brokers.',
                                                                            'Ok',
                                                                            'Cancel');
                                                                        if (!result) {
                                                                          return;
                                                                        }
                                                                        AdvisorInvite
                                                                            currInv =
                                                                            prvaddOther.filteredinvites[index];

                                                                        Role objRole = mPrv.accountroles.firstWhere((e) =>
                                                                            e.rolename ==
                                                                            'User');
                                                                        currInv.role =
                                                                            objRole;

                                                                        if (currInv.isvalid &&
                                                                            currInv.invitedemail.isNotEmpty) {
                                                                          prvaddOther.setEmailStatus(
                                                                              index,
                                                                              true);

                                                                          currInv.duration =
                                                                              7;
                                                                          currInv.invitationtype =
                                                                              'MailTemplateTypeInviteJoin';

                                                                          await prvaddOther.sendEmail(currInv, index).then((value) =>
                                                                              {
                                                                                prvaddOther.filteredinvites[index].invitationstatus = prvaddOther.currentInvite.invitationstatus,
                                                                                prvaddOther.currentInvite.invitationstatus == 'invited' ? showSnackBar(context, 'Invitation Sent Successfully!') : showSnackBar(context, 'Invitation Failed!')
                                                                              });
                                                                        }
                                                                        /*  else if (currInv
                                                                            .invitedemail
                                                                            .isEmpty) {
                                                                          showCustomSnackBar(
                                                                              context,
                                                                              "Please enter a valid email id.");
                                                                        } */
                                                                      }
                                                                    } catch (e) {
                                                                      prvaddOther.setEmailStatus(
                                                                          index,
                                                                          false);
                                                                    } finally {
                                                                      prvaddOther.setEmailStatus(
                                                                          index,
                                                                          false);
                                                                    }
                                                                  },
                                                            style:
                                                                buttonStyleBlue,
                                                            child: isSending
                                                                ? displaySpin()
                                                                : (prvaddOther
                                                                            .currentInvite
                                                                            .invitationstatus ==
                                                                        '')
                                                                    ? const Text(
                                                                        'Send',
                                                                        style:
                                                                            invitetextstyle)
                                                                    : Text(prvaddOther
                                                                        .currentInvite
                                                                        .invitationstatus),
                                                          )
                                                        : (prvaddOther
                                                                    .filteredinvites[
                                                                        index]
                                                                    .invitationstatus
                                                                    .toUpperCase() ==
                                                                "INVITED")
                                                            ? ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style:
                                                                    buttonStyleAmber,
                                                                child: const Text(
                                                                    'Invited'),
                                                              )
                                                            : (prvaddOther
                                                                        .filteredinvites[
                                                                            index]
                                                                        .invitationstatus
                                                                        .toUpperCase() ==
                                                                    "JOINED")
                                                                ? ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    style:
                                                                        buttonStyleGreen,
                                                                    child: const Text(
                                                                        'Joined'),
                                                                  )
                                                                : (prvaddOther
                                                                            .filteredinvites[
                                                                                index]
                                                                            .invitationstatus
                                                                            .toUpperCase() ==
                                                                        "EXPIRED")
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            if (formKey.currentState!.validate()) {
                                                                              bool result = await EliteDialog(context, 'Are you sure to reinvite?', 'Please make sure that the invited person is an advisor.\nAdvsiors are also known as benefits consultants or brokers.', 'Ok', 'Cancel');
                                                                              if (!result) {
                                                                                return;
                                                                              }
                                                                              AdvisorInvite currInv = prvaddOther.filteredinvites[index];

                                                                              Role objRole = mPrv.accountroles.firstWhere((e) => e.rolename == 'User');
                                                                              currInv.role = objRole;

                                                                              if (currInv.isvalid && currInv.invitedemail.isNotEmpty) {
                                                                                prvaddOther.setEmailStatus(index, true);

                                                                                currInv.duration = 7;
                                                                                currInv.invitationtype = 'MailTemplateTypeInviteJoin';

                                                                                await prvaddOther.sendEmail(currInv, index).then((value) => {
                                                                                      prvaddOther.filteredinvites[index].invitationstatus = prvaddOther.currentInvite.invitationstatus,
                                                                                      prvaddOther.currentInvite.invitationstatus == 'invited' ? showSnackBar(context, 'Invitation Sent Successfully!') : showSnackBar(context, 'Invitation Failed!')
                                                                                    });
                                                                              }
                                                                            }
                                                                          } catch (e) {
                                                                            prvaddOther.setEmailStatus(index,
                                                                                false);
                                                                          } finally {
                                                                            prvaddOther.setEmailStatus(index,
                                                                                false);
                                                                          }
                                                                        },
                                                                        style:
                                                                            buttonStyleBlue,
                                                                        child: const Text(
                                                                            'Reinvite'),
                                                                      )
                                                                    : const Text(
                                                                        ''),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        });
                              }),
                            ),
                          ],
                        ),
                      ),
                      /* Align(
                        alignment: const Alignment(0, .8),
                        child: Consumer<LoginProvider>(
                            builder: (context, loginProvider, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                    style: buttonStyleBlue,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .popAndPushNamed("/addLaunchPack");
                                    },
                                    child: const Text('Back')),
                              ),
                            ],
                          );
                        }),
                      ), */
                    ],
                  ),
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Consumer<LoginProvider>(
                builder: (context, prvRead, child) {
                  int flexValue = prvRead.isPanelShrinked ? 1 : 2;
                  return Expanded(
                    flex: flexValue,
                    child: SafeArea(
                      child: Container(
                        width: double.infinity,
                        height: SizeConfig.screenHeight,
                        decoration: const BoxDecoration(
                          color: AppColors.conversation,
                          border: Border(
                            left: BorderSide(
                              color: AppColors.conversation,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const SingleChildScrollView(
                          child: Column(
                            children: [EmployerInRoom()],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
