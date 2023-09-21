import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOther extends StatefulWidget {
  const AddOther({Key? key}) : super(key: key);

  @override
  State<AddOther> createState() => _AddOtherState();
}

class _AddOtherState extends State<AddOther> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final addOtherProvider =
        Provider.of<AddotherProvider>(context, listen: false);
    //addOtherProvider.initEmail = 5;
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    addOtherProvider.readAdvisorInvite(lgnProvider.logedinUser.accountcode);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    double screenWidth = SizeConfig.screenWidth / 3.5;

    return Scaffold(
      key: _scaffoldKey,
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
              flex: 8,
              child: Form(
                key: _formKey,
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
                                final addOtherProvider =
                                    Provider.of<AddotherProvider>(context,
                                        listen: false);
                                addOtherProvider.addEmail();
                              },
                              child: const Text(
                                '+Add other users dfsdfdsfsd from your company',
                                style: appstyle,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: SizeConfig.screenHeight * 3 / 4,
                              child: Consumer<AddotherProvider>(
                                  builder: (context, prvaddOther, child) {
                                return prvaddOther.readingInvite
                                    ? displaySpin()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            prvaddOther.advisorinvites.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                                                  width: screenWidth,
                                                  child: TextFormField(
                                                    readOnly: prvaddOther
                                                        .advisorinvites[index]
                                                        .invitedemail
                                                        .isNotEmpty,
                                                    initialValue: prvaddOther
                                                        .advisorinvites[index]
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
                                                                .advisorinvites[
                                                                    index]
                                                                .isvalid)
                                                            ? ''
                                                            : 'Email should be valid and of your company domain.'),
                                                    onChanged: (value) {
                                                      var isValid = RegExp(
                                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                          .hasMatch(value);
                                                      final domain = isValid
                                                          ? value.split('@')[1]
                                                          : '';
                                                      bool sameDomain = false;

                                                      // Check if the domain is valid (in this example, only gmail.com is accepted)
                                                      if (domain ==
                                                          loginProvider
                                                              .logedinUser
                                                              .companydomainname) {
                                                        sameDomain = true;
                                                        prvaddOther
                                                                .advisorinvites[
                                                                    index]
                                                                .invitedemail =
                                                            value;
                                                      }

                                                      prvaddOther
                                                          .setEmailValidStaus(
                                                              index,
                                                              isValid &&
                                                                  sameDomain);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth / 2.5,
                                                  child:
                                                      Consumer<MasterProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                    return value.accountroles
                                                                .isEmpty ||
                                                            prvaddOther
                                                                .advisorinvites
                                                                .isEmpty
                                                        ? Container() // if the items list is empty, return an empty Container
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Container(
                                                              color: AppColors
                                                                  .sidemenu,
                                                              child:
                                                                  DropdownButton<
                                                                      Role>(
                                                                key: Key(prvaddOther
                                                                    .advisorinvites[
                                                                        index]
                                                                    .role
                                                                    .rolecode),
                                                                hint: const Text(
                                                                    'Select Role',
                                                                    style:
                                                                        hinttextstyle),
                                                                value: (prvaddOther
                                                                        .advisorinvites[
                                                                            index]
                                                                        .role
                                                                        .rolecode
                                                                        .isEmpty)
                                                                    ? null
                                                                    : value.accountroles.firstWhere((element) =>
                                                                        element
                                                                            .rolecode ==
                                                                        prvaddOther
                                                                            .advisorinvites[index]
                                                                            .role
                                                                            .rolecode),
                                                                onChanged: (Role?
                                                                    newValue) {
                                                                  prvaddOther
                                                                      .setInvitePersonRole(
                                                                          index,
                                                                          newValue!);
                                                                },
                                                                items: value
                                                                    .accountroles
                                                                    .map((Role
                                                                        obj) {
                                                                      return DropdownMenuItem<
                                                                          Role>(
                                                                        value:
                                                                            obj,
                                                                        child: Text(
                                                                            obj.rolename),
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
                                                                .advisorinvites[
                                                                    index]
                                                                .invitationstatus ==
                                                            ""
                                                        ? ElevatedButton(
                                                            onPressed: isSending
                                                                ? null
                                                                : () async {
                                                                    try {
                                                                      if (!_formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        showSnackBar(
                                                                            context,
                                                                            validationFailMessage);
                                                                        return;
                                                                      }
                                                                      AdvisorInvite
                                                                          currInv =
                                                                          prvaddOther
                                                                              .advisorinvites[index];
                                                                      if (currInv
                                                                              .isvalid &&
                                                                          currInv
                                                                              .invitedemail
                                                                              .isNotEmpty) {
                                                                        prvaddOther.setEmailStatus(
                                                                            index,
                                                                            true);

                                                                        currInv.duration =
                                                                            7;
                                                                        currInv.invitationtype =
                                                                            'MailTemplateTypeInviteJoin';

                                                                        await prvaddOther
                                                                            .sendEmail(currInv,
                                                                                index)
                                                                            .then((value) =>
                                                                                {
                                                                                  prvaddOther.advisorinvites[index].invitationstatus = prvaddOther.currentInvite.invitationstatus,
                                                                                  prvaddOther.currentInvite.invitationstatus.toUpperCase() == 'INVITED' ? showSnackBar(context, 'Invitation Sent Successfully!') : showSnackBar(context, 'Invitation Failed!')
                                                                                });
                                                                      } else if (currInv
                                                                          .invitedemail
                                                                          .isEmpty) {
                                                                        showCustomSnackBar(
                                                                            context,
                                                                            "Please enter a valid email id.");
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
                                                                    .advisorinvites[
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
                                                                        .advisorinvites[
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
                                                                            .advisorinvites[
                                                                                index]
                                                                            .invitationstatus
                                                                            .toUpperCase() ==
                                                                        "EXPIRED")
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {},
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
                      Align(
                          alignment: const Alignment(0, .8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                    style: buttonStyleBlue,
                                    onPressed: () {
                                      final mPrv = Provider.of<MasterProvider>(
                                          context,
                                          listen: false);
                                      CompanyCategory? companyCate = mPrv
                                          .companycategories
                                          .firstWhere((e) =>
                                              e.categorycode ==
                                              loginProvider
                                                  .logedinUser.companycategory);

                                      if (companyCate.categoryname !=
                                          'Employer') {
                                        Navigator.of(context)
                                            .popAndPushNamed("/addLaunchPack");
                                      } else {
                                        Navigator.of(context)
                                            .popAndPushNamed("/yourProfile");
                                      }

                                      /*  Navigator.of(context)
                                          .popAndPushNamed("/addLaunchPack"); */
                                    },
                                    child: const Text('Back')),
                              ),
                              /* SizedBox(
                                width: 150,
                                height: 30,
                                child: ElevatedButton(
                                  style: buttonStyleGreen,
                                  onPressed: loginProvider.updating
                                      ? null
                                      : () async {
                                          try {
                                            if (loginProvider.cachedAccount !=
                                                null) {
                                              Account obj = Account();
                                              obj =
                                                  loginProvider.cachedAccount!;
                                              await loginProvider
                                                  .updateAccount(obj)
                                                  .then((value) => {
                                                        showSnackBar(context,
                                                            'Account Saved!')
                                                      });
                                            }
                                          } catch (e) {
                                            null;
                                          }
                                        },
                                  child: loginProvider.updating
                                      ? displaySpin()
                                      : const Text(
                                          'Save',
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            */
                            ],
                          )),
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
