import 'dart:js_interop';

import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/employerprofile.dart';
import 'package:advisorapp/models/naics.dart';
import 'package:advisorapp/models/payment.dart';
import 'package:advisorapp/models/role.dart';
import 'package:advisorapp/providers/image_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';

import 'package:advisorapp/style/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import '../../models/account.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final formkey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final prvRoom = Provider.of<RoomsProvider>(context, listen: false);
    final lgnProvider = Provider.of<LoginProvider>(context, listen: false);
    prvRoom.readRooms(lgnProvider.logedinUser.workemail);

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
                child: Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                  return Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              loginProvider.adding = true;
                            },
                            child: const Text(
                              '+Add your company information',
                              style: appstyle,
                            ),
                          ),
                          //displayEntryForm()
                          (loginProvider.logedinUser.companyname.isEmpty &&
                                  loginProvider.adding)
                              ? displayEntryForm(context, formkey)
                              : const Text(''),
                          (loginProvider.logedinUser.companyname.isNotEmpty)
                              ? displayEntryForm(context, formkey)
                              : const Text(''),
                        ],
                      ),
                    ),
                  );
                }),
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
        ));
  }

  displayEntryForm(BuildContext context, GlobalKey<FormState> formkey) {
    double screenWidth = SizeConfig.screenWidth / 2;
    String? _companycategory = '', _companytype = '', _paymentinfo = '';

    bool isAccountOwner = false;
    bool askForPayment = false;
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final prvMaster = Provider.of<MasterProvider>(context, listen: false);

    /* final rProv = Provider.of<RoomsProvider>(context, listen: false);
    rProv.getInitialLaunchPack(
        loginProvider.logedinUser.accountcode, '', 'Individual');
    rProv.readRooms(loginProvider.logedinUser.workemail); */

    Role? accRole = prvMaster.accountroles
        .firstWhere((e) => e.rolecode == loginProvider.logedinUser.accountrole);
    if (accRole.rolecode.isNotEmpty) {
      isAccountOwner = accRole.rolename == 'Account Owner' ? false : true;
    }
    //final GlobalKey<TextFieldAutoCompleteState<String>> key = GlobalKey();

    EdgeInsets paddingConfig = const EdgeInsets.all(4);

    CompanyCategory objCategory = prvMaster.companycategories
        .firstWhere((e) => e.categorycode == 'select');
    CompanyType objCompanyType =
        prvMaster.companytypes.firstWhere((e) => e.typecode == 'select');

    Payment objpayment =
        prvMaster.payments.firstWhere((e) => e.paymentcode == 'select');
    Naics defaultNaicsCode =
        loginProvider.naicscodes.firstWhere((e) => e.naicscode == "00000");

    Naics? selectedNaicsCode;

    if (loginProvider.cachedAccount == null) {
      try {
        selectedNaicsCode = loginProvider.naicscodes.firstWhere(
            (e) => e.naicscode == loginProvider.logedinUser.naicscode);
      } catch (e) {
        selectedNaicsCode = defaultNaicsCode;
      }
      loginProvider.naicscodeController.text =
          selectedNaicsCode.isNull ? '' : selectedNaicsCode.title;

      loginProvider.companydomainController.text =
          loginProvider.logedinUser.companydomainname;

      loginProvider.eincodeController.text = loginProvider.logedinUser.eincode;
      loginProvider.companynameController.text =
          loginProvider.logedinUser.companyname;
      loginProvider.companyaddressController.text =
          loginProvider.logedinUser.companyaddress;
      loginProvider.companyphoneController.text =
          loginProvider.logedinUser.companyphonenumber;
      if (loginProvider.logedinUser.companycategory.isNotEmpty) {
        objCategory = prvMaster.companycategories.firstWhere(
            (e) => e.categorycode == loginProvider.logedinUser.companycategory);
      }
      if (loginProvider.logedinUser.typeofcompany.isNotEmpty) {
        objCompanyType = prvMaster.companytypes.firstWhere(
            (e) => e.typecode == loginProvider.logedinUser.typeofcompany);
      }
      if (loginProvider.logedinUser.accountpaymentinfo.isNotEmpty) {
        objpayment = prvMaster.payments.firstWhere((e) =>
            e.paymentcode == loginProvider.logedinUser.accountpaymentinfo);
        if (objpayment.paymentcode == 'PC-20230423165319123' ||
            objpayment.paymentcode == 'PC-20230423165416250') {
          askForPayment = true;
        } else {
          askForPayment = false;
        }
      }
      if (objCategory.categoryname == 'Employer') {
        objpayment = prvMaster.payments
            .firstWhere((e) => e.paymentcode == 'PC-20230424161840147');
      }
    } else if (loginProvider.cachedAccount != null) {
      try {
        selectedNaicsCode = loginProvider.naicscodes.firstWhere(
            (e) => e.naicscode == loginProvider.logedinUser.naicscode);
      } catch (e) {
        selectedNaicsCode = defaultNaicsCode;
      }
      loginProvider.naicscodeController.text =
          selectedNaicsCode.isNull ? '' : selectedNaicsCode.title;

      loginProvider.companydomainController.text =
          loginProvider.cachedAccount!.companydomainname;
      loginProvider.companynameController.text =
          loginProvider.cachedAccount!.companyname;
      loginProvider.eincodeController.text =
          loginProvider.cachedAccount!.eincode;

      loginProvider.companyaddressController.text =
          loginProvider.cachedAccount!.companyaddress;
      loginProvider.companyphoneController.text =
          loginProvider.cachedAccount!.companyphonenumber;
      if (loginProvider.cachedAccount!.companycategory.isNotEmpty) {
        objCategory = prvMaster.companycategories.firstWhere(
            (e) => e.categorycode == loginProvider.logedinUser.companycategory);
      }
      if (loginProvider.cachedAccount!.typeofcompany.isNotEmpty) {
        objCompanyType = prvMaster.companytypes.firstWhere(
            (e) => e.typecode == loginProvider.logedinUser.typeofcompany);
      }
      if (loginProvider.logedinUser.accountpaymentinfo.isNotEmpty) {
        objpayment = prvMaster.payments.firstWhere((e) =>
            e.paymentcode == loginProvider.logedinUser.accountpaymentinfo);

        if (objpayment.paymentcode == 'PC-20230423165319123' ||
            objpayment.paymentcode == 'PC-20230423165416250') {
          askForPayment = true;
        } else {
          askForPayment = false;
        }
      }
      if (objCategory.categoryname == 'Employer') {
        objpayment = prvMaster.payments
            .firstWhere((e) => e.paymentcode == 'PC-20230424161840147');
      }
    }
    final FocusNode _firstFocusNode = FocusNode();
    final FocusNode _secondFocusNode = FocusNode();

    final FocusNode _thirdFocusNode = FocusNode();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: Tooltip(
                textStyle: const TextStyle(color: AppColors.black),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(colors: <Color>[
                    AppColors.sidemenu,
                    AppColors.primaryBg,
                    AppColors.sidemenu,
                  ]),
                ),
                message:
                    "If your work email address is johndoe@acme.com, then enter “acme.com”",
                padding: const EdgeInsets.all(8.0),
                preferBelow: false,
                child: TextFormField(
                  readOnly: isAccountOwner,
                  controller: loginProvider.companydomainController,
                  keyboardType: TextInputType.text,
                  decoration: CustomTextDecoration.textDecoration(
                    'Company Domain Name',
                    const Icon(
                      Icons.business_center,
                      color: AppColors.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Company Domain Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: paddingConfig,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: TextFormField(
                    readOnly: isAccountOwner,
                    //initialValue: loginProvider.logedinUser?.companyname,
                    focusNode: _firstFocusNode,
                    controller: loginProvider.companynameController,
                    keyboardType: TextInputType.text,
                    decoration: CustomTextDecoration.textDecoration(
                      'Company Name',
                      const Icon(
                        Icons.business_sharp,
                        color: AppColors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Company Name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      loginProvider.logedinUser.companyname = value;
                    },
                    onEditingComplete: () {
                      _firstFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_secondFocusNode);
                    },
                  ),
                ),
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
                    textStyle: const TextStyle(color: AppColors.black),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(colors: <Color>[
                        AppColors.sidemenu,
                        AppColors.primaryBg,
                        AppColors.sidemenu,
                      ]),
                    ),
                    message:
                        "Please enter the number without any - or space.\nAn Employer Identification Number (EIN), also known as a Federal Tax Identification Number,\nis used to identify a business entity.",
                    child: TextFormField(
                      focusNode: _secondFocusNode,
                      controller: loginProvider.eincodeController,
                      keyboardType: TextInputType.text,
                      decoration: CustomTextDecoration.textDecoration(
                        'Company EIN',
                        const Icon(
                          Icons.code,
                          color: AppColors.secondary,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Company EIN';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        loginProvider.logedinUser.eincode = value;
                      },
                      onEditingComplete: () {
                        _secondFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_thirdFocusNode);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: paddingConfig,
            child: SizedBox(
                width: screenWidth,
                child: DropdownSearch<Naics>(
                  autoValidateMode: AutovalidateMode.always,
                  items: loginProvider.naicscodes.toList(),
                  /*  dropdownBuilder: (context, selectedItem) {
                   
                    loginProvider.naicscodeController.text =
                        selectedItem == null
                            ? defaultNaicsCode.title
                            : selectedItem.title;
                    return Text(selectedItem == null
                        ? defaultNaicsCode.title
                        : selectedItem.title);
                  }, */

                  selectedItem: selectedNaicsCode,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration:
                        CustomTextDecoration.textDecoration(
                      'NAICS Code',
                      const Icon(
                        Icons.code,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  compareFn: (i, s) =>
                      (i.naicscode.toLowerCase() == s.naicscode.toLowerCase()),
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox: true,
                    itemBuilder: (context, objNaics, isSelected) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: !isSelected
                            ? null
                            : BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                        child: ListTile(
                          selected: isSelected,
                          title: Text(objNaics.title),
                          onTap: () {},

                          //subtitle: Text(objNaics.naicscode),
                        ),
                      );
                    },
                    constraints: BoxConstraints.tightFor(
                      width: screenWidth,
                      height: screenWidth / 2,
                    ),
                  ),
                  onChanged: (value) {
                    /* loginProvider.naicscodeController.text =
                        '${value!.title}-${value.naicscode}'; */

                    loginProvider.selectedNAICSCode = value;
                  },
                )),
          ),

          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: TextFormField(
                readOnly: isAccountOwner,
                controller: loginProvider.companyaddressController,
                keyboardType: TextInputType.text,
                decoration: CustomTextDecoration.textDecoration(
                  'Company Address',
                  const Icon(
                    Icons.post_add,
                    color: AppColors.secondary,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Company Address';
                  }
                  return null;
                },
                onChanged: (value) {
                  loginProvider.logedinUser.companyaddress = value;
                },
              ),
            ),
          ),

          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: TextFormField(
                readOnly: isAccountOwner,
                controller: loginProvider.companyphoneController,
                keyboardType: TextInputType.text,
                decoration: CustomTextDecoration.textDecoration(
                  'Company Phone Number',
                  const Icon(
                    Icons.phone,
                    color: AppColors.secondary,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Company Phone Number';
                  }

                  return null;
                },
                onChanged: (value) {
                  loginProvider.logedinUser.companyphonenumber = value;
                },
              ),
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: Consumer<MasterProvider>(builder: (context, value, child) {
                return InputDecorator(
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
                    value: (value.selectedAccountCompanyType == null)
                        ? objCompanyType
                        : value.selectedAccountCompanyType,
                    onChanged: (CompanyType? newValue) {
                      value.selectedAccountCompanyType = newValue!;
                      objCompanyType = newValue;
                    },
                    items: prvMaster.companytypes
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
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        })
                        .toSet()
                        .toList(),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: paddingConfig,
            child: Consumer<MasterProvider>(
              builder: (context, value, child) {
                final filteredItems = prvMaster.companycategories
                    .where((obj) =>
                        obj.basecategorycode == objCategory.basecategorycode)
                    .toList();

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
                      ),
                    ),
                    child: DropdownButton<CompanyCategory>(
                      value: (value.selectedCompanyCategory == null)
                          ? objCategory
                          : value.selectedCompanyCategory,
                      onChanged: (CompanyCategory? newValue) {
                        // Handle onChanged event here
                        value.selectedCompanyCategory = newValue;
                        objCategory = newValue!;
                      },
                      items: filteredItems.map((CompanyCategory obj) {
                        return DropdownMenuItem<CompanyCategory>(
                          value: obj,
                          enabled: (obj.basecategorycode ==
                              objCategory.basecategorycode),
                          child: Text(
                            obj.categoryname,
                            style: TextStyle(
                              color: (obj.basecategorycode !=
                                      objCategory.basecategorycode)
                                  ? AppColors.iconGray
                                  : AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: paddingConfig,
            child: SizedBox(
              width: screenWidth,
              child: Consumer<MasterProvider>(builder: (context, value, child) {
                return InputDecorator(
                  decoration: CustomDropDownDecoration.textDecoration(
                    'Select Payment Type',
                    const Icon(
                      Icons.payment,
                      color: AppColors.secondary,
                    ),
                    const Icon(
                      Icons.payment,
                      color: Colors.transparent,
                    ),
                  ),
                  child: DropdownButton<Payment>(
                    value: (value.selectedPayment == null)
                        ? objpayment
                        : value.selectedPayment,
                    onChanged: (Payment? newValue) {
                      CompanyCategory? obj =
                          (value.selectedCompanyCategory == null)
                              ? objCategory
                              : value.selectedCompanyCategory;

                      if (obj!.categoryname != 'Employer') {
                        value.selectedPayment = newValue;
                        objpayment = newValue!;
                      }
                      if (newValue?.paymentcode == 'PC-20230423165319123' ||
                          newValue?.paymentcode == 'PC-20230423165416250') {
                        value.askForPayment = true;
                        askForPayment = true;
                      } else {
                        value.askForPayment = false;
                        askForPayment = false;
                      }
                    },
                    items: prvMaster.payments
                        .map((Payment obj) {
                          return DropdownMenuItem<Payment>(
                            value: obj,
                            enabled: (obj.paymentcode != 'select'),
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              maxLines: 2,
                              obj.paymentname,
                              style: TextStyle(
                                  color: (obj.paymentcode == 'select')
                                      ? AppColors.iconGray
                                      : AppColors.black,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          );
                        })
                        .toSet()
                        .toList(),
                  ),
                );
              }),
            ),
          ),

          Padding(
              padding: paddingConfig,
              child: GestureDetector(
                onTap: (() {
                  selectImage(
                      loginProvider.logedinUser.companydomainname, context);
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
                        if (pvrLogo.uploadedEmployerProfile == null) {
                          imgPath =
                              "$basePathOfLogo${loginProvider.logedinUser.companydomainname}.png";
                          uniqueImageUrl = Uri.parse(imgPath).toString();
                        } else if (pvrLogo
                                .uploadedEmployerProfile!.employerCode ==
                            loginProvider.logedinUser.companydomainname) {
                          imgPath =
                              pvrLogo.uploadedEmployerProfile?.companylogo;
                          uniqueImageUrl = Uri.parse(imgPath!)
                              .replace(queryParameters: {
                            'timestamp':
                                DateTime.now().millisecondsSinceEpoch.toString()
                          }).toString();
                        } else {
                          imgPath =
                              "$basePathOfLogo${loginProvider.logedinUser.companydomainname}.png";
                          uniqueImageUrl = Uri.parse(imgPath).toString();
                        }
                        return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: pvrLogo.uploadingEmployerLogo
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
                                          'Company Logo',
                                          style: appstyle,
                                          textAlign: TextAlign.center,
                                        ));
                                        /*  Image.network(defaultimagePath,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.fill); */
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const CircularProgressIndicator();
                                      },
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
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              width: screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: buttonStyleGreen,
                      onPressed: loginProvider.updating
                          ? null
                          : () async {
                              try {
                                if (!formkey.currentState!.validate()) {
                                  showSnackBar(context, validationFailMessage);
                                  return;
                                }

                                if (objCompanyType.typecode == 'select') {
                                  EliteDialog(
                                      context,
                                      "Warning",
                                      "Please select company type!",
                                      "Ok",
                                      "Close");
                                  return;
                                }
                                if (objCategory.categorycode == 'select') {
                                  EliteDialog(
                                      context,
                                      "Warning",
                                      "Please select company category!",
                                      "Ok",
                                      "Close");
                                  return;
                                }

                                if (loginProvider.selectedNAICSCode != null) {
                                  if (!validateNaicsCode(
                                      loginProvider
                                          .selectedNAICSCode!.naicscode,
                                      context)) {
                                    showSnackBar(context, 'Invalid NAICS Code');
                                    return;
                                  }
                                }
                                Account obj = Account(rolewithemployer: []);

                                obj = loginProvider.logedinUser;
                                _companytype = objCompanyType.typecode;
                                _companycategory = objCategory.categorycode;
                                _paymentinfo = objpayment.paymentcode;

                                obj.naicscode =
                                    (loginProvider.selectedNAICSCode == null)
                                        ? selectedNaicsCode!.naicscode
                                        : loginProvider
                                            .selectedNAICSCode!.naicscode;
                                obj.eincode =
                                    loginProvider.eincodeController.text;
                                obj.companyname =
                                    loginProvider.companynameController.text;
                                obj.companydomainname =
                                    loginProvider.companydomainController.text;
                                obj.typeofcompany = _companytype!;

                                obj.companycategory = _companycategory!;
                                obj.companyaddress =
                                    loginProvider.companyaddressController.text;

                                obj.companyphonenumber =
                                    loginProvider.companyphoneController.text;
                                obj.accountpaymentinfo = _paymentinfo!;
                                obj.accountcode =
                                    loginProvider.logedinUser.accountcode;

                                loginProvider.addInCache(obj);
                                await loginProvider.updateAccount(obj).then(
                                    (value) => {
                                          showSnackBar(
                                              context, 'Account Saved!')
                                        });

                                // Navigator.of(context).popAndPushNamed("/addLaunchPack");
                              } catch (e) {
                                showSnackBar(context, 'Error appeared!');
                              } finally {}
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
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: buttonStyleAmber,
                      child: const Text('Next'),
                      onPressed: () async {
                        try {
                          /*  if (!formKey.currentState!.validate()) {
                            showSnackBar(context, validationFailMessage);
                            return;
                          } */

                          if (objCompanyType.typecode == 'select') {
                            EliteDialog(context, "Warning",
                                "Please select company type!", "Ok", "Close");
                            return;
                          }
                          if (objCategory.categorycode == 'select') {
                            EliteDialog(
                                context,
                                "Warning",
                                "Please select company category!",
                                "Ok",
                                "Close");
                            return;
                          }

                          Account obj = loginProvider.logedinUser;

                          _companytype = objCompanyType.typecode;
                          _companycategory = objCategory.categorycode;

                          _paymentinfo = objpayment.paymentcode;

                          obj.companyname =
                              loginProvider.companynameController.text;
                          obj.naicscode =
                              (loginProvider.selectedNAICSCode == null)
                                  ? selectedNaicsCode!.naicscode
                                  : loginProvider.selectedNAICSCode!.naicscode;
                          obj.eincode = loginProvider.eincodeController.text;

                          obj.companydomainname =
                              loginProvider.companydomainController.text;
                          obj.typeofcompany = _companytype!;

                          obj.companycategory = _companycategory!;
                          obj.companyaddress =
                              loginProvider.companyaddressController.text;

                          obj.companyphonenumber =
                              loginProvider.companyphoneController.text;
                          obj.accountpaymentinfo = _paymentinfo!;
                          obj.accountcode =
                              loginProvider.logedinUser.accountcode;

                          if (loginProvider.cachedAccount == null) {
                            loginProvider.addInCache(obj);
                          }

                          loginProvider.adding = false;

                          Navigator.of(context).popAndPushNamed("/yourProfile");
                        } catch (e) {
                          showSnackBar(context,
                              '${e}Something went wrong. Please contact with Admin!');
                        } finally {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          //paymentInfo(),
        ],
      ),
    );
  }

  List<String> getSuggestions(List<Naics> naicsCodes) {
    List<String> suggestions = [];
    for (var naics in naicsCodes) {
      suggestions.add('${naics.naicscode}-${naics.title}');
      suggestions.add('${naics.title}-${naics.naicscode}');
    }
    return suggestions;
  }

  selectImage(employercode, context) async {
    final imgProvider = Provider.of<EliteImageProvider>(context, listen: false);

    var mediaData = await ImagePickerWeb.getImageInfo;
    String? base64String = mediaData?.base64;
    //print(base64String);
    // print(mediaData?.fileName);
    String? extension = mediaData?.fileName.toString().split('.').last;
    /* if (extension!.isNotEmpty && extension != 'png') {
      EliteDialog(
          context, "Warning", "Please select a PNG file.", "Ok", "Close");

      return;
    } */
    EmployerProfile obj = EmployerProfile(
        employerCode: employercode,
        fileextension: ".$extension",
        filebase64: base64String!);
    imgProvider.uploadEmployerLogo(obj);
  }

  bool validateNaicsCode(String naicscode, context) {
    LoginProvider lProv = Provider.of<LoginProvider>(context, listen: false);

    Naics naics = lProv.naicscodes.firstWhere((e) => e.naicscode == naicscode,
        orElse: (() {
      return Naics(naicscode: '0', title: '');
    }));

    return (naics.naicscode.length == 6) ? true : false;
  }
}
