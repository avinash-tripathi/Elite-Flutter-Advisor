import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/esignwidget/anonymousiframe.dart';

import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/esign/anonymousmodel.dart';
import 'package:advisorapp/models/esign/anonymoususer.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/providers/room_provider.dart';

class AddAnonymous extends StatelessWidget {
  const AddAnonymous({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final formKey = GlobalKey<FormState>();
    double screenWidth = SizeConfig.screenWidth;
    EdgeInsets paddingConfig = const EdgeInsets.all(4);
    final prvRoom = Provider.of<RoomsProvider>(context, listen: false);
    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          width: screenWidth,
          height: SizeConfig.screenHeight,
          child: SingleChildScrollView(
            child: Consumer<RoomsProvider>(builder: (context, prvView, child) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: !prvView.viewNewAnoIframe,
                      child: Padding(
                        padding: paddingConfig,
                        child: TextFormField(
                          controller: prvRoom.anonymousemailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: CustomTextDecoration.emailDecoration(
                              'Email:',
                              const Icon(
                                Icons.email,
                                color: AppColors.secondary,
                              ),
                              true),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Email Id.';
                            }
                            if (!isEmailValid(value)) {
                              return 'Invalid Email Format.';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !prvView.viewNewAnoIframe,
                      child: Padding(
                        padding: paddingConfig,
                        child: SizedBox(
                          width: screenWidth,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller:
                                      prvRoom.anonymousfirstnameController,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      CustomTextDecoration.textDecoration(
                                    'First Name :',
                                    const Icon(
                                      Icons.man,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter First Name.';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller:
                                      prvRoom.anonymouslastnameController,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      CustomTextDecoration.textDecoration(
                                    'Last Name :',
                                    const Icon(
                                      Icons.man,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Last Name.';
                                    }

                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !prvView.viewNewAnoIframe,
                      child: SizedBox(
                        width: screenWidth,
                        child: ListTile(
                          title: const Text(
                              'Please upload your esign document template.'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Tooltip(
                                decoration: tooltipdecorationGradient,
                                message:
                                    "Browse contract file from here to upload.",
                                child: Visibility(
                                  visible: !prvView.viewNewAnoIframe,
                                  child: prvView.uploadingDocument
                                      ? displaySpin()
                                      : SizedBox(
                                          width: 70,
                                          child: IconButton(
                                            color: AppColors
                                                .blue, // Set the icon color to white
                                            icon: const Icon(
                                              Icons
                                                  .upload_file_rounded, // Use the upload_file_rounded icon from Material Icons
                                              color: AppColors.blue,
                                              size:
                                                  30, // Set the icon color to white
                                            ),
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                final lgnProvider =
                                                    Provider.of<LoginProvider>(
                                                        context,
                                                        listen: false);
                                                bool consent = await EliteDialog(
                                                    context,
                                                    "Please confirm",
                                                    "Please note that once the document is sent for eSign,the sender or the receiver won’t be able to change signatories.If signatories need to be changed, you can send a new document for eSign.",
                                                    "Yes",
                                                    "No");
                                                if (!consent) {
                                                  return;
                                                }

                                                AnonymousModel obj =
                                                    AnonymousModel();
                                                Account objAcc =
                                                    lgnProvider.logedinUser;

                                                obj.accountcode =
                                                    objAcc.accountcode;
                                                obj.recipient = AnonymousUser(
                                                    email: prvView
                                                        .anonymousemailController
                                                        .text,
                                                    firstname: prvView
                                                        .anonymousfirstnameController
                                                        .text,
                                                    lastname: prvView
                                                        .anonymouslastnameController
                                                        .text,
                                                    company: "");
                                                obj.sender = AnonymousUser(
                                                    email: objAcc.workemail,
                                                    firstname:
                                                        objAcc.accountname,
                                                    lastname: objAcc.lastname,
                                                    company:
                                                        objAcc.companyname);

                                                await prvView
                                                    .pickAnonymousUserFile(obj)
                                                    .then((model) async => {
                                                          await prvView
                                                              .uploadAnonymousDocumentGenerateEmbedURL(
                                                                  model),
                                                          prvView.viewNewAnoIframe =
                                                              true
                                                        });
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Visibility(
                                visible: !prvView.viewNewAnoIframe,
                                child: SizedBox(
                                  width: 100,
                                  child: IconButton(
                                    style: buttonStyleBlue,
                                    onPressed: () {
                                      prvView.newEsign = false;
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: AppColors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: paddingConfig,
                        child: prvView.viewNewAnoIframe
                            ? SizedBox(
                                width: screenWidth,
                                height: SizeConfig.screenHeight,
                                child: AnonymousIframe(
                                  src: prvView.anonymousUser!.embedurl,
                                ),
                              )
                            : const Text("")),
                  ]);
            }),
          ),
        ));
  }
}
