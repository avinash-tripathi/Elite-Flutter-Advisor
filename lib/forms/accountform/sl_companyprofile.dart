import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/employerprofile.dart';
import 'package:advisorapp/models/naics.dart';
import 'package:advisorapp/models/payment.dart';
import 'package:advisorapp/providers/image_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';

import 'package:advisorapp/style/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_textfield_autocomplete/flutter_textfield_autocomplete.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../models/account.dart';

// ignore: camel_case_types
class sLCompanyProfile extends StatelessWidget {
  sLCompanyProfile({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  //final scaffoldKey = GlobalKey<ScaffoldState>();

  Account currentAccount = Account(rolewithemployer: []);
  List<CompanyCategory> companycategories = [];
  List<CompanyType> companytypes = [];
  CompanyType? selectedCompanyType;
  CompanyCategory? selectedCompanyCategory;
  String? _companycategory = '', _companytype = '', _paymentinfo = '';

  final companydomainController = TextEditingController();
  final companynameController = TextEditingController();
  final companyaddressController = TextEditingController();
  final companyphoneController = TextEditingController();
  late TextEditingController naicscodeController = TextEditingController();
  bool isAccountOwner = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = SizeConfig.screenWidth / 2;
    final GlobalKey<TextFieldAutoCompleteState<String>> key = GlobalKey();

    EdgeInsets paddingConfig = const EdgeInsets.all(4);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final prvMaster = Provider.of<MasterProvider>(context, listen: false);
    final imgProvider = Provider.of<EliteImageProvider>(context, listen: false);
    CompanyCategory objCategory = prvMaster.companycategories
        .firstWhere((e) => e.categorycode == 'select');
    CompanyType objCompanyType =
        prvMaster.companytypes.firstWhere((e) => e.typecode == 'select');

    Payment objpayment =
        prvMaster.payments.firstWhere((e) => e.paymentcode == 'select');

    if (loginProvider.cachedAccount == null) {
      companydomainController.text =
          loginProvider.logedinUser.companydomainname;
      naicscodeController.text = loginProvider.logedinUser.naicscode;
      companynameController.text = loginProvider.logedinUser.companyname;
      companyaddressController.text = loginProvider.logedinUser.companyaddress;
      companyphoneController.text =
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
      }
    } else if (loginProvider.cachedAccount != null) {
      companydomainController.text =
          loginProvider.cachedAccount!.companydomainname;
      companynameController.text = loginProvider.cachedAccount!.companyname;
      naicscodeController.text = loginProvider.cachedAccount!.naicscode;
      companyaddressController.text =
          loginProvider.cachedAccount!.companyaddress;
      companyphoneController.text =
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
      }
    }

    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: SingleChildScrollView(
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
                    controller: companydomainController,
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
                      controller: companynameController,
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
                      child: Autocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          } else {
                            return loginProvider.naicscodes.where((word) => word
                                .title
                                .contains(textEditingValue.text.toLowerCase()));
                          }
                        },
                        optionsViewBuilder:
                            (context, Function(String) onSelected, options) {
                          return Material(
                            elevation: 4,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);

                                return ListTile(
                                  // title: Text(option.toString()),
                                  title: SubstringHighlight(
                                    text: option.toString(),
                                    term: naicscodeController.text,
                                    textStyleHighlight: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: const Text("This is subtitle"),
                                  onTap: () {
                                    onSelected(option.toString());
                                  },
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: options.length,
                            ),
                          );
                        },
                        onSelected: (selectedString) {
                          print(selectedString);
                        },
                        fieldViewBuilder: (context, controller, focusNode,
                            onEditingComplete) {
                          naicscodeController = controller;

                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              hintText: "Search Something",
                              prefixIcon: const Icon(Icons.search),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
            /* Padding(
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
                      "The North American Industry Classification System (NAICS) is a six-digit coding standard used to classify businesses.\nThis helps us provide any available industry benchmark data to your organization. \nFor example, the NAICS code for Insurance Agencies and Brokerages is 524210. \nYou can learn more about the NAICS codes at https://www.census.gov/naics/.",
                  verticalOffset: 50,
                  child: SimpleTextFieldAutoComplete(
                    key: key,
                    suggestions: loginProvider.naicscodes
                        .map((e) => '${e.naicscode}-${e.title}')
                        .toList(),
                    controller: naicscodeController,
                    decoration: CustomTextDecoration.textDecoration(
                      'NAICS CODE',
                      const Icon(
                        Icons.code,
                        color: AppColors.secondary,
                      ),
                    ).copyWith(
                        errorText: validateNaicsCode(
                                naicscodeController.text, loginProvider)
                            ? null
                            : 'Invalid NAICS Code'),
                    clearOnSubmit: false,
                    textChanged: (data) {},
                    textSubmitted: ((data) {
                      naicscodeController.text = data.toString().split('-')[0];
                    }),
                  ),
                ),
              ),
            ), */
            Padding(
              padding: paddingConfig,
              child: SizedBox(
                width: screenWidth,
                child: TextFormField(
                  readOnly: isAccountOwner,
                  controller: companyaddressController,
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
                ),
              ),
            ),
            Padding(
              padding: paddingConfig,
              child: SizedBox(
                width: screenWidth,
                child: TextFormField(
                  readOnly: isAccountOwner,
                  controller: companyphoneController,
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
                ),
              ),
            ),
            Padding(
              padding: paddingConfig,
              child: SizedBox(
                width: screenWidth,
                child:
                    Consumer<MasterProvider>(builder: (context, value, child) {
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
              child: Consumer<MasterProvider>(builder: (context, value, child) {
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
                        /*  value.selectedCompanyCategory = newValue!;
                        objCategory = newValue; */
                      },
                      items: prvMaster.companycategories
                          .map((CompanyCategory obj) {
                            return DropdownMenuItem<CompanyCategory>(
                              value: obj,
                              enabled: (obj.categorycode != 'select'),
                              child: Text(
                                obj.categoryname,
                                style: TextStyle(
                                    color: (obj.categorycode == 'select')
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
            ),
            Padding(
              padding: paddingConfig,
              child: SizedBox(
                width: screenWidth,
                child:
                    Consumer<MasterProvider>(builder: (context, value, child) {
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
                      },
                      items: prvMaster.payments
                          .map((Payment obj) {
                            return DropdownMenuItem<Payment>(
                              value: obj,
                              enabled: (obj.paymentcode != 'select'),
                              child: Text(
                                obj.paymentname,
                                style: TextStyle(
                                    color: (obj.paymentcode == 'select')
                                        ? AppColors.iconGray
                                        : AppColors.black),
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
                child: Container(
                  padding: const EdgeInsets.only(left: 1),
                  child: GestureDetector(
                    onTap: (() {
                      selectImage(loginProvider.logedinUser.companydomainname,
                          imgProvider);
                    }),
                    child: Column(children: [
                      Center(
                          child: Stack(children: [
                        Consumer<EliteImageProvider>(
                            builder: (context, pvrLogo, child) {
                          String? imgPath = defaultimagePath;
                          if (pvrLogo.uploadedEmployerProfile == null) {
                            imgPath =
                                "$basePathOfLogo${loginProvider.logedinUser.companydomainname}.png";
                          } else if (pvrLogo
                                  .uploadedEmployerProfile!.employerCode ==
                              loginProvider.logedinUser.companydomainname) {
                            imgPath =
                                pvrLogo.uploadedEmployerProfile?.companylogo;
                          } else {
                            imgPath =
                                "$basePathOfLogo${loginProvider.logedinUser.companydomainname}.png";
                          }
                          String imageUrl =
                              pvrLogo.uploadedEmployerProfile?.companylogo ??
                                  imgPath!;
                          String uniqueImageUrl =
                              Uri.parse(imageUrl).toString();
                          /*  String uniqueImageUrl = Uri.parse(imageUrl)
                              .replace(queryParameters: {
                            'timestamp':
                                DateTime.now().millisecondsSinceEpoch.toString()
                          }).toString(); */

                          return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
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
                                if (!_formKey.currentState!.validate()) {
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

                                if (!validateNaicsCode(
                                    naicscodeController.text, loginProvider)) {
                                  showSnackBar(context, 'Invalid NAICS Code');
                                  return;
                                }
                                Account obj = Account(rolewithemployer: []);

                                obj = loginProvider.logedinUser;
                                _companytype = objCompanyType.typecode;
                                _companycategory = objCategory.categorycode;
                                _paymentinfo = objpayment.paymentcode;

                                /*  _companytype =
                                    (prvMaster.selectedAccountCompanyType !=
                                            null)
                                        ? prvMaster.selectedAccountCompanyType!
                                            .typecode
                                        : prvMaster.companytypes[0].typecode;

                                _companycategory =
                                    (prvMaster.selectedCompanyCategory != null)
                                        ? prvMaster.selectedCompanyCategory!
                                            .categorycode
                                        : prvMaster
                                            .companycategories[0].categorycode;

                                _paymentinfo =
                                    (prvMaster.selectedPayment != null)
                                        ? prvMaster.selectedPayment!.paymentcode
                                        : objpayment.paymentcode; */
                                obj.naicscode = naicscodeController.text;
                                obj.companyname = companynameController.text;
                                obj.companydomainname =
                                    companydomainController.text;
                                obj.typeofcompany = _companytype!;

                                obj.companycategory = _companycategory!;
                                obj.companyaddress =
                                    companyaddressController.text;

                                obj.companyphonenumber =
                                    companyphoneController.text;
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
                          if (!_formKey.currentState!.validate()) {
                            showSnackBar(context, validationFailMessage);
                            return;
                          }

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

                          obj.companyname = companynameController.text;
                          obj.companydomainname = companydomainController.text;
                          obj.typeofcompany = _companytype!;

                          obj.companycategory = _companycategory!;
                          obj.companyaddress = companyaddressController.text;

                          obj.companyphonenumber = companyphoneController.text;
                          obj.accountpaymentinfo = _paymentinfo!;
                          obj.accountcode =
                              loginProvider.logedinUser.accountcode;

                          if (loginProvider.cachedAccount == null) {
                            loginProvider.addInCache(obj);
                          }

                          loginProvider.adding = false;
                          Navigator.of(context).popAndPushNamed("/yourProfile");
                        } catch (e) {
                          null;
                        } finally {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateNaicsCode(String naicscode, LoginProvider lProv) {
    Naics naics = lProv.naicscodes.firstWhere((e) => e.naicscode == naicscode,
        orElse: (() {
      return Naics(naicscode: '0', title: '');
    }));
    return (naics.naicscode.length == 6) ? true : false;
  }

  selectImage(employercode, EliteImageProvider imgProvider) async {
    //final imgProvider = Provider.of<EliteImageProvider>(context, listen: false);

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
}
