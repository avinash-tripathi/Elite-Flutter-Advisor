import 'package:advisorapp/models/admin/paymentmethod/attachedcustomerdata.dart';
import 'package:advisorapp/models/admin/paymentmethod/attachedpaymentmethoddata.dart';

class AttachedPaymentMethod {
  AttachedCustomerData customerdata;
  AttachedPaymentMethodData? paymentmethoddata;
  AttachedPaymentMethod(
      {required this.customerdata, required this.paymentmethoddata});
  factory AttachedPaymentMethod.fromJson(Map<String, dynamic> json) {
    return AttachedPaymentMethod(
        /*  customerdata: AttachedCustomerData.fromJson(json['stripeCustomerData']),
        paymentmethoddata:
            AttachedPaymentMethodData.fromJson(json['paymentmethod']) */
        customerdata: AttachedCustomerData.fromJson(json['stripeCustomerData']),
        paymentmethoddata: (json['paymentmethod'] == null)
            ? null
            : AttachedPaymentMethodData.fromJson(json['paymentmethod'][0]));
  }
}
