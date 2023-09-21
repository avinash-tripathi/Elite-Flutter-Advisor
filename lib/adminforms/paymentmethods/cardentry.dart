import 'package:advisorapp/adminforms/custom/emailinputformatter.dart';
import 'package:advisorapp/adminforms/custom/monthyearformatter.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/admin/paymentmethod/paymentmethod.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/paymentmethod_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';

class CardEntry extends StatelessWidget {
  const CardEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final payProvider =
        Provider.of<PaymentMethodProvider>(context, listen: false);
    payProvider.emailController.text = loginProvider.logedinUser.workemail;
    double screenWidth = SizeConfig.screenWidth / 2.5;
    EdgeInsets paddingConfig = const EdgeInsets.all(2);
    final MaskTextInputFormatter _maskFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####', // Credit card number format
      filter: {'#': RegExp(r'[0-9]')},
    );

    return Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/paymenticons/visa.png'),
                          Image.asset('assets/paymenticons/mastercard.png'),
                          Image.asset('assets/paymenticons/discover.png'),
                          Image.asset(
                              'assets/paymenticons/american_express.png'),
                          Image.asset('assets/paymenticons/jcb.png')
                        ],
                      ))),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Consumer<PaymentMethodProvider>(
                        builder: (context, prvEmail, child) {
                      return TextFormField(
                        controller: payProvider.emailController,
                        inputFormatters: [EmailInputFormatter()],
                        keyboardType: TextInputType.emailAddress,
                        decoration: CustomPaymentTextDecoration.textDecoration(
                            'Your Email',
                            '',
                            prvEmail.showEmailError
                                ? 'Please Enter Email.'
                                : ''),
                        onChanged: (value) {
                          prvEmail.showEmailError = value.isEmpty;
                        },
                      );
                    }),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Consumer<PaymentMethodProvider>(
                        builder: (context, prvCa, child) {
                      return TextFormField(
                          controller: payProvider.cardholdernameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          keyboardType: TextInputType.text,
                          decoration:
                              CustomPaymentTextDecoration.textDecoration(
                                  'Card Holder Name',
                                  '',
                                  prvCa.showCardHolderNameError
                                      ? 'Please Enter Card Holder Name.'
                                      : ''),
                          onChanged: (value) {
                            prvCa.showCardHolderNameError = value.isEmpty;
                          });
                    }),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Consumer<PaymentMethodProvider>(
                        builder: (context, prvCn, child) {
                      return TextFormField(
                          controller: payProvider.cardnumberController,
                          inputFormatters: [_maskFormatter],
                          keyboardType: TextInputType.text,
                          decoration:
                              CustomPaymentTextDecoration.textDecoration(
                                  'Card Number',
                                  '',
                                  prvCn.showcardnumberError
                                      ? 'Please Enter Card Number.'
                                      : ''),
                          onChanged: (value) {
                            prvCn.showcardnumberError = value.isEmpty;
                          });
                    }),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth / 3.5 - 10,
                          child: Consumer<PaymentMethodProvider>(
                              builder: (context, prvCvv, child) {
                            return TextFormField(
                                controller: payProvider.cvvController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(
                                      3), // Limit to 3 characters
                                ],
                                keyboardType: TextInputType.number,
                                decoration:
                                    CustomPaymentTextDecoration.textDecoration(
                                        'CVV',
                                        '',
                                        prvCvv.showcvvError
                                            ? 'Please Enter CVV Code.'
                                            : ''),
                                onChanged: (value) {
                                  prvCvv.showcvvError = value.isEmpty;
                                });
                          }),
                        ),
                        SizedBox(
                          width: screenWidth / 3.5 - 10,
                          child: Consumer<PaymentMethodProvider>(
                              builder: (context, prvExp, child) {
                            return TextFormField(
                                controller: payProvider.expirydateController,
                                inputFormatters: [
                                  MonthYearInputFormatter(), // Using custom formatter
                                ],
                                keyboardType: TextInputType.number,
                                decoration:
                                    CustomPaymentTextDecoration.textDecoration(
                                        'Expire On',
                                        'MM/YYYY',
                                        prvExp.showexpirydateError
                                            ? 'Please Enter Expiry Date.'
                                            : ''),
                                onChanged: (value) {
                                  prvExp.showexpirydateError = value.isEmpty;
                                });
                          }),
                        ),
                        SizedBox(
                          width: screenWidth / 3.5 - 10,
                          child: Consumer<PaymentMethodProvider>(
                              builder: (context, prvZip, child) {
                            return TextFormField(
                              controller: payProvider.zipcodeController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(
                                    5), // Limit to 3 characters
                              ],
                              keyboardType: TextInputType.number,
                              decoration:
                                  CustomPaymentTextDecoration.textDecoration(
                                      'Zip Code',
                                      '',
                                      prvZip.showzipcodeError
                                          ? 'Please Enter Zip Code.'
                                          : ''),
                              onChanged: (value) {
                                prvZip.showzipcodeError = value.isEmpty;
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<PaymentMethodProvider>(
                              builder: (context, prvMethod, child) {
                            return Checkbox(
                              value: prvMethod.consentStatus,
                              onChanged: (value) {
                                prvMethod.consentStatus = value!;
                              },
                            );
                          }),
                          const Expanded(
                            child: Text(
                              'By entering my account information I authorize ALICORN to charge my account on a recurring basis. I understand that the subscription fees will be charged by ALICORN for all active users on the last day of each month. I understand that I can terminate any or all users prior to the last day of the month and not incur any fees. There will be no refunds once the subscription fee is charged.',
                              maxLines: 7,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ))),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                      width: screenWidth,
                      child: Center(
                        child: Consumer<PaymentMethodProvider>(
                            builder: (context, prvMethod, child) {
                          return ElevatedButton(
                            style: prvMethod.consentStatus
                                ? buttonStyleBlue
                                : buttonStyleGrey,
                            onPressed: () {
                              (!prvMethod.showEmailError &&
                                      prvMethod.emailController.text.isEmpty)
                                  ? prvMethod.showEmailError = true
                                  : prvMethod.showEmailError = false;
                              (!prvMethod.showCardHolderNameError &&
                                      prvMethod.cardholdernameController.text
                                          .isEmpty)
                                  ? prvMethod.showCardHolderNameError = true
                                  : prvMethod.showCardHolderNameError = false;

                              (!prvMethod.showcardnumberError &&
                                      prvMethod
                                          .cardnumberController.text.isEmpty)
                                  ? prvMethod.showcardnumberError = true
                                  : prvMethod.showcardnumberError = false;

                              (!prvMethod.showexpirydateError &&
                                      prvMethod
                                          .expirydateController.text.isEmpty)
                                  ? prvMethod.showexpirydateError = true
                                  : prvMethod.showexpirydateError = false;

                              (!prvMethod.showcvvError &&
                                      prvMethod.cvvController.text.isEmpty)
                                  ? prvMethod.showcvvError = true
                                  : prvMethod.showcvvError = false;

                              (!prvMethod.showzipcodeError &&
                                      prvMethod.zipcodeController.text.isEmpty)
                                  ? prvMethod.showzipcodeError = true
                                  : prvMethod.showzipcodeError = false;

                              if (prvMethod.showEmailError ||
                                  prvMethod.showCardHolderNameError ||
                                  prvMethod.showcardnumberError ||
                                  prvMethod.showexpirydateError ||
                                  prvMethod.showcvvError ||
                                  prvMethod.showzipcodeError) {
                                showSnackBar(context, validationFailMessage);
                                return;
                              }

                              var objCard = BankCard();
                              objCard.cardHolderName =
                                  prvMethod.cardholdernameController.text;
                              objCard.cardNumber =
                                  prvMethod.cardnumberController.text;
                              objCard.cvv = prvMethod.cvvController.text;
                              objCard.expiresOn =
                                  prvMethod.expirydateController.text;
                              objCard.zipCode =
                                  prvMethod.zipcodeController.text;

                              List<PaymentMethodOptions> objOptions = [];
                              PaymentMethodOptions optMethod =
                                  PaymentMethodOptions();
                              optMethod.card =
                                  prvMethod.selectedMethod == 'Card'
                                      ? objCard
                                      : null;
                              objOptions.add(optMethod);

                              var objPayment =
                                  PaymentMethod(paymentMethods: objOptions);

                              payProvider.createPaymentMethod(
                                  loginProvider.logedinUser.accountcode,
                                  objPayment);
                            },
                            child: const Text('Update'),
                          );
                        }),
                      ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      //createStripeSetupIntent(context);
                    },
                    child: const Text('Create Session')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<AdminProvider>(
                    builder: (context, prvMethod, child) {
                  return ElevatedButton(
                      onPressed: () {
                        Uri uri = Uri.parse(prvMethod.setupintentUrl);
                        launchUrl(uri);
                      },
                      child: const Text('Add Payment Method'));
                }),
              )
            ]));
  }

// Call the JavaScript function
  void createStripeToken() {
    js.context.callMethod('createStripeToken', [
      'card-element',
      'pk_test_ZjWNCWsdylZ26aBnatN60pVR004LiSM2V0',
      handleTokenCallback
    ]);
  }

  /*  void createStripeSetupIntent(context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.createSetupIntentCheckOutSession();
  } */

// Define the JavaScript callback function
  void handleTokenCallback(token) {
    // Handle the token received from JavaScript
    print('Received token: $token');
    // You can now send this token to your server for further processing
  }
}
