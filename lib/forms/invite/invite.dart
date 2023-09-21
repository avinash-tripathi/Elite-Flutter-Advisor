import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/accountform/groupconversation.dart';
import 'package:advisorapp/models/advisorinvitation.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteForm extends StatefulWidget {
  const InviteForm({Key? key}) : super(key: key);

  @override
  State<InviteForm> createState() => _InviteFormState();
}

class _InviteFormState extends State<InviteForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final addOtherProvider =
        Provider.of<AddotherProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    addOtherProvider.readAdvisorInvite(lgnProvider.logedinUser.accountcode);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenWidth = SizeConfig.screenWidth / 4;

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
                                MasterProvider mPrv =
                                    Provider.of<MasterProvider>(context,
                                        listen: false);
                                Role objRole = mPrv.accountroles
                                    .firstWhere((e) => e.rolename == 'User');
                                CompanyCategory objCat = mPrv.companycategories
                                    .firstWhere((e) => e.categoryname == 'TPA');
                                addOtherProvider.addFilteredEmail(
                                    objRole, objCat);
                              },
                              child: const Text(
                                '+ Advisor platform access is by invitation only. Invite your contacts',
                                style: appstyle,
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                          bool isSending =
                                              prvaddOther.isSending(index);
                                          // Check if the domain is valid (in this example, only gmail.com is accepted)
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
                                                      var isValid = RegExp(
                                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                          .hasMatch(value);
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
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 3 / 4,
                                                  child:
                                                      Consumer<MasterProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                    return value.companycategories
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
                                                                  CompanyCategory>(
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
                                                                        .categorycode
                                                                        .isEmpty)
                                                                    ? null
                                                                    : value.companycategories.firstWhere((element) =>
                                                                        element
                                                                            .categorycode ==
                                                                        prvaddOther
                                                                            .filteredinvites[index]
                                                                            .companycategory
                                                                            .categorycode),
                                                                onChanged:
                                                                    (CompanyCategory?
                                                                        newValue) {
                                                                  prvaddOther
                                                                      .setFilteredInvitePersonCategory(
                                                                          index,
                                                                          newValue!);
                                                                },
                                                                items: value
                                                                    .companycategories
                                                                    .map((CompanyCategory
                                                                        obj) {
                                                                      return DropdownMenuItem<
                                                                          CompanyCategory>(
                                                                        value:
                                                                            obj,
                                                                        child: SizedBox(
                                                                            width: screenWidth * 3 / 4 -
                                                                                60,
                                                                            child:
                                                                                Text(obj.categoryname, overflow: TextOverflow.visible)),
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
                                                                              .filteredinvites[index];
                                                                      MasterProvider
                                                                          mPrv =
                                                                          Provider.of<MasterProvider>(
                                                                              context,
                                                                              listen: false);

                                                                      Role objRole = mPrv
                                                                          .accountroles
                                                                          .firstWhere((e) =>
                                                                              e.rolename ==
                                                                              'User');
                                                                      currInv.role =
                                                                          objRole;

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
                                                                                  prvaddOther.filteredinvites[index].invitationstatus = prvaddOther.currentInvite.invitationstatus,
                                                                                  prvaddOther.currentInvite.invitationstatus == 'invited' ? showSnackBar(context, 'Invitation Sent Successfully!') : showSnackBar(context, 'Invitation Failed!')
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
              Expanded(
                flex: 4,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        children: [
                          GroupConversation(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
