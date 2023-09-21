// ignore_for_file: unused_local_variable
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/image_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/employerprofile.dart';

class YourProfileForm extends StatelessWidget {
  const YourProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final formKey = GlobalKey<FormState>();

    double screenWidth = SizeConfig.screenWidth / 2;
    EdgeInsets paddingConfig = const EdgeInsets.all(4);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final prvMaster = Provider.of<MasterProvider>(context, listen: false);

    /* List<Role> selectedRoles = [];
    for (var e in prvMaster.employerroles) {
      for (var c in loginProvider.logedinUser.rolewithemployer) {
        if (c.rolecode == e.rolecode) {
          selectedRoles.add(e);
        }
      }
    } */

    Role? objAccRole;
    List<CompanyCategory> companycategories = [];
    String? roleforaccount = '';
    CompanyCategory? companyCate = prvMaster.companycategories.firstWhere(
        (e) => e.categorycode == loginProvider.logedinUser.companycategory);

    try {
      objAccRole = prvMaster.accountroles[0];

      if (loginProvider.cachedAccount!.accountrole.isNotEmpty) {
        objAccRole = prvMaster.accountroles.firstWhere((element) =>
            element.rolecode == loginProvider.cachedAccount!.accountrole);
      } else {
        objAccRole = prvMaster.accountroles.firstWhere((element) =>
            element.rolecode == loginProvider.logedinUser.accountrole);
      }

      if (loginProvider.cachedAccount!.rolewithemployer.isNotEmpty) {
        //selectedRoles = loginProvider.cachedAccount!.rolewithemployer;
        //objEmpRoles = loginProvider.cachedAccount!.rolewithemployer;
      } else {
        //selectedRoles = loginProvider.logedinUser.rolewithemployer;
      }
    } on StateError catch (e) {
      print(e);
    }

    loginProvider.nameController.text =
        loginProvider.cachedAccount!.accountname.isEmpty
            ? loginProvider.logedinUser.accountname
            : loginProvider.cachedAccount!.accountname;
    loginProvider.lastnameController.text =
        loginProvider.cachedAccount!.lastname.isEmpty
            ? loginProvider.logedinUser.lastname
            : loginProvider.cachedAccount!.lastname;
    loginProvider.worktitleController.text =
        loginProvider.cachedAccount!.worktitle.isEmpty
            ? loginProvider.logedinUser.worktitle
            : loginProvider.cachedAccount!.worktitle;
    loginProvider.phoneController.text =
        loginProvider.cachedAccount!.phonenumber.isEmpty
            ? loginProvider.logedinUser.phonenumber
            : loginProvider.cachedAccount!.phonenumber;
    loginProvider.workemailController.text =
        loginProvider.cachedAccount!.workemail.isEmpty
            ? loginProvider.logedinUser.workemail
            : loginProvider.cachedAccount!.workemail;

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: loginProvider.nameController,
                      keyboardType: TextInputType.text,
                      decoration: CustomTextDecoration.textDecoration(
                        'First Name',
                        const Icon(
                          Icons.man_sharp,
                          color: AppColors.secondary,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: loginProvider.lastnameController,
                      keyboardType: TextInputType.text,
                      decoration: CustomTextDecoration.textDecoration(
                        'Last Name',
                        const Icon(
                          Icons.man_sharp,
                          color: Colors.transparent,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: TextFormField(
                //initialValue: loginProvider.logedinUser?.companyname,
                controller: loginProvider.worktitleController,
                keyboardType: TextInputType.text,
                decoration: CustomTextDecoration.textDecoration(
                  'Work Title',
                  const Icon(
                    Icons.business_sharp,
                    color: AppColors.secondary,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Work Title';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: TextFormField(
                // initialValue: loginProvider.logedinUser?.companyaddress,
                controller: loginProvider.phoneController,
                keyboardType: TextInputType.number,
                decoration: CustomTextDecoration.textDecoration(
                  'Phone Number',
                  const Icon(
                    Icons.phone,
                    color: AppColors.secondary,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Phone Number';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: TextFormField(
                //initialValue: loginProvider.logedinUser?.phonenumber,
                controller: loginProvider.workemailController,
                keyboardType: TextInputType.text,
                decoration: CustomTextDecoration.textDecoration(
                  'Work Email',
                  const Icon(
                    Icons.email,
                    color: AppColors.secondary,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Work Email';
                  }

                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: Consumer<MasterProvider>(builder: (context, value, child) {
                return value.accountroles.isEmpty
                    ? Container() // if the items list is empty, return an empty Container
                    : InputDecorator(
                        decoration: CustomDropDownDecoration.textDecoration(
                          'Your Role In Managing This Account',
                          const Icon(
                            Icons.business,
                            color: AppColors.secondary,
                          ),
                          const Icon(
                            Icons.business,
                            color: Colors.transparent,
                          ),
                        ),
                        child: DropdownButton<Role>(
                          value: (value.selectedAccountRole == null)
                              ? prvMaster.accountroles.firstWhere((element) =>
                                  element.rolecode == objAccRole!.rolecode)
                              : value.selectedAccountRole,
                          onChanged: (Role? newValue) {
                            //value.selectedAccountRole = newValue!;
                          },
                          items: prvMaster.accountroles
                              .map((Role obj) {
                                return DropdownMenuItem<Role>(
                                  value: obj,
                                  child: Text(obj.rolename),
                                );
                              })
                              .toSet()
                              .toList(),
                        ),
                      );
              }),
            ),
          ),
          Visibility(
            visible: (companyCate.categoryname != 'Employer'),
            child: Padding(
              padding: paddingConfig,
              child: Consumer<MasterProvider>(
                builder: (context, prvNew, child) => SizedBox(
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
                        initialValue: (prvNew.selectedEmployerRole == null)
                            ? prvNew.employerroles.where((employerRole) {
                                return (loginProvider.cachedAccount == null)
                                    ? loginProvider.logedinUser.rolewithemployer
                                        .any((currentRole) =>
                                            employerRole.rolecode ==
                                            currentRole.rolecode)
                                    : loginProvider
                                        .cachedAccount!.rolewithemployer
                                        .any((currentRole) =>
                                            employerRole.rolecode ==
                                            currentRole.rolecode);
                              }).toList()
                            : prvNew.selectedEmployerRole!,
                        items: prvNew.employerroles
                            .map((role) => MultiSelectItem(role, role.rolename))
                            .toSet()
                            .toList(),
                        title: const Text(
                          "Add Roles",
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
                          "Your Role With Employers",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            color: AppColors.hint,
                          ),
                        ),
                        onConfirm: (results) {
                          //model.selectedPartners.clear();
                          prvNew.selectedEmployerRole = results.cast<Role>();
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
              child: GestureDetector(
                onTap: (() {
                  selectImage(loginProvider.logedinUser.accountcode, context);
                }),
                child: SizedBox(
                  width: screenWidth,
                  child: Column(children: [
                    Center(
                        child: Stack(children: [
                      Consumer<EliteImageProvider>(
                          builder: (context, pvrLogo, child) {
                        String? imgPath = defaultimagePath;
                        String uniqueImageUrl = imgPath;
                        if (pvrLogo.uploadedPersonalProfile == null) {
                          imgPath =
                              "$basePathOfLogo${loginProvider.logedinUser.accountcode}.png";
                          uniqueImageUrl = Uri.parse(imgPath).toString();
                        } else if (pvrLogo
                                .uploadedPersonalProfile!.employerCode ==
                            loginProvider.logedinUser.accountcode) {
                          imgPath =
                              pvrLogo.uploadedPersonalProfile?.companylogo;
                          uniqueImageUrl = Uri.parse(imgPath!)
                              .replace(queryParameters: {
                            'timestamp':
                                DateTime.now().millisecondsSinceEpoch.toString()
                          }).toString();
                        } else {
                          imgPath =
                              "$basePathOfLogo${loginProvider.logedinUser.accountcode}.png";
                          uniqueImageUrl = Uri.parse(imgPath).toString();
                        }

                        /*  uniqueImageUrl = Uri.parse(imgPath).replace(
                            queryParameters: {
                              'timestamp':
                                  DateTime.now().millisecondsSinceEpoch.toString()
                            }).toString();  */

                        return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              shape: BoxShape.circle,
                              /*  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(uniqueImageUrl)) */
                            ),
                            child: Tooltip(
                              message:
                                  'Please upload a JPEG or PNG file\nwith a maximum of 180 x 180 pixels',
                              textStyle:
                                  const TextStyle(color: AppColors.black),
                              decoration: tooltipdecoration,
                              child: ClipOval(
                                child: pvrLogo.uploadingPersonalLogo
                                    ? displaySpin()
                                    : Image.network(
                                        uniqueImageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fill,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return const Center(
                                              child: Text(
                                            'Profile Picture',
                                            style: appstyle,
                                            textAlign: TextAlign.center,
                                          ));
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                              ),
                            ));
                      }),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                color: Colors.blue),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ))
                    ]))
                  ]),
                ),
              )),
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: buttonStyleBlue,
                        onPressed: () {
                          Navigator.of(context)
                              .popAndPushNamed("/companyProfile");
                        },
                        child: const Text('Back'),
                      )),
                  SizedBox(
                    width: 150,
                    child: Consumer<LoginProvider>(
                        builder: (context, lgnSave, child) {
                      return ElevatedButton(
                        style: buttonStyleGreen,
                        onPressed: lgnSave.updating
                            ? null
                            : () async {
                                try {
                                  if (lgnSave.cachedAccount != null) {
                                    List<Role> selectedRoles =
                                        (prvMaster.selectedEmployerRole == null)
                                            ? lgnSave
                                                .logedinUser.rolewithemployer
                                            : prvMaster.selectedEmployerRole!;

                                    Account obj = lgnSave.cachedAccount!;
                                    obj.accountname =
                                        lgnSave.nameController.text;
                                    obj.lastname =
                                        lgnSave.lastnameController.text;
                                    obj.worktitle =
                                        lgnSave.worktitleController.text;
                                    obj.rolewithemployer = selectedRoles;
                                    obj.phonenumber =
                                        lgnSave.phoneController.text;
                                    obj.workemail =
                                        lgnSave.workemailController.text;
                                    obj.accountrole =
                                        (prvMaster.selectedAccountRole == null)
                                            ? objAccRole!.rolecode
                                            : prvMaster
                                                .selectedAccountRole!.rolecode;

                                    //obj = setYourInfo(loginProvider.cachedAccount!);
                                    obj.accountcode =
                                        lgnSave.logedinUser.accountcode;
                                    lgnSave.addInCache(obj);
                                    await lgnSave.updateAccount(obj).then(
                                        (value) => {
                                              showSnackBar(
                                                  context, 'Account Saved!')
                                            });

                                    // Navigator.of(context).popAndPushNamed("/addLaunchPack");
                                  }
                                } catch (e) {
                                  null;
                                } finally {}
                              },
                        child: lgnSave.updating
                            ? displaySpin()
                            : const Text(
                                'Save',
                                style: TextStyle(
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
                      style: buttonStyleAmber,
                      child: const Text('Next'),
                      onPressed: () async {
                        try {
                          if (loginProvider.cachedAccount != null) {
                            List<Role> selectedRoles =
                                (prvMaster.selectedEmployerRole == null)
                                    ? loginProvider
                                        .cachedAccount!.rolewithemployer
                                    : prvMaster.selectedEmployerRole!;

                            Account obj = loginProvider.cachedAccount!;
                            obj.accountname = loginProvider.nameController.text;
                            obj.lastname =
                                loginProvider.lastnameController.text;
                            obj.worktitle =
                                loginProvider.worktitleController.text;
                            obj.rolewithemployer = selectedRoles;
                            obj.phonenumber =
                                loginProvider.phoneController.text;
                            obj.workemail =
                                loginProvider.workemailController.text;
                            obj.accountrole =
                                (prvMaster.selectedAccountRole == null)
                                    ? objAccRole!.rolecode
                                    : prvMaster.selectedAccountRole!.rolecode;

                            //obj = setYourInfo(loginProvider.cachedAccount!);
                            obj.accountcode =
                                loginProvider.logedinUser.accountcode;

                            loginProvider.addInCache(obj);
                            await loginProvider
                                .updateAccount(obj)
                                .then((value) => {
                                      if (companyCate.categoryname !=
                                          'Employer')
                                        {
                                          Navigator.of(context)
                                              .popAndPushNamed("/addLaunchPack")
                                        }
                                      else
                                        {
                                          Navigator.of(context)
                                              .popAndPushNamed("/addOther")
                                        }
                                    });
                          }
                        } catch (e) {
                          null;
                        } finally {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectImage(employercode, context) async {
    final imgProvider = Provider.of<EliteImageProvider>(context, listen: false);
    var mediaData = await ImagePickerWeb.getImageInfo;
    String? base64String = mediaData?.base64;
    //print(base64String);
    // print(mediaData?.fileName);
    String? extension = mediaData?.fileName.toString().split('.').last;
    /* if (extension!.isNotEmpty && extension.toUpperCase() != 'PNG') {
      EliteDialog(
          context, "Warning", "Please select a PNG file.", "Ok", "Close");
      return;
    } */
    EmployerProfile obj = EmployerProfile(
        employerCode: employercode,
        fileextension: ".$extension",
        filebase64: base64String!);
    await imgProvider.uploadPersonalLogo(obj);
  }
}
