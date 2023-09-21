import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/models/admin/paymentmethod/paymentmethod.dart';
import 'package:advisorapp/providers/paymentmethod_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BankAccountEntry extends StatelessWidget {
  const BankAccountEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double screenWidth = SizeConfig.screenWidth / 2.5;
    EdgeInsets paddingConfig = const EdgeInsets.all(6);
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
                        builder: (context, prvBank, child) {
                      return TextFormField(
                        controller: prvBank.banknameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                        keyboardType: TextInputType.text,
                        decoration: CustomPaymentTextDecoration.textDecoration(
                            'Bank Name',
                            '',
                            prvBank.showbanknameError
                                ? 'Please Enter Bank Name.'
                                : ''),
                        onChanged: (value) {
                          prvBank.showbanknameError = value.isEmpty;
                        },
                      );
                    }),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Consumer<PaymentMethodProvider>(
                        builder: (context, prvBank, child) {
                      return TextFormField(
                        controller: prvBank.bankaccounttypeController,
                        keyboardType: TextInputType.text,
                        decoration: CustomPaymentTextDecoration.textDecoration(
                            'Account Type',
                            '',
                            prvBank.showbankaccounttypeError
                                ? 'Please Enter Account Type.'
                                : ''),
                        onChanged: (value) {
                          prvBank.showbankaccounttypeError = value.isEmpty;
                        },
                      );
                    }),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Consumer<PaymentMethodProvider>(
                        builder: (context, prvBank, child) {
                      return TextFormField(
                        controller: prvBank.bankaccountnumberController,
                        keyboardType: TextInputType.text,
                        decoration: CustomPaymentTextDecoration.textDecoration(
                            'Account Number',
                            '',
                            prvBank.showbankaccountnumberError
                                ? 'Please Enter Account Number.'
                                : ''),
                        onChanged: (value) {
                          prvBank.showbankaccountnumberError = value.isEmpty;
                        },
                      );
                    }),
                  )),
              Padding(
                  padding: paddingConfig,
                  child: SizedBox(
                    width: screenWidth,
                    child: Consumer<PaymentMethodProvider>(
                        builder: (context, prvBank, child) {
                      return TextFormField(
                        controller: prvBank.routingnumberController,
                        keyboardType: TextInputType.text,
                        decoration: CustomPaymentTextDecoration.textDecoration(
                            'Routing Number',
                            '',
                            prvBank.showroutingnumberError
                                ? 'Please Enter Routing Number.'
                                : ''),
                        onChanged: (value) {
                          prvBank.showroutingnumberError = value.isEmpty;
                        },
                      );
                    }),
                  )),
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

                              var objCard = BankAccount();
                              objCard.bankName =
                                  prvMethod.banknameController.text;
                              objCard.accountType =
                                  prvMethod.bankaccounttypeController.text;

                              objCard.accountNumber =
                                  prvMethod.bankaccountnumberController.text;
                              objCard.routingNumber =
                                  prvMethod.routingnumberController.text;

                              List<PaymentMethodOptions> objOptions = [];
                              objOptions[0].bankaccount =
                                  prvMethod.selectedMethod == 'Bank'
                                      ? objCard
                                      : null;
                              /*  var objPayment =
                                  PaymentMethod(paymentMethods: objOptions); */
                            },
                            child: const Text('Update'),
                          );
                        }),
                      )))
            ]));
  }
}
