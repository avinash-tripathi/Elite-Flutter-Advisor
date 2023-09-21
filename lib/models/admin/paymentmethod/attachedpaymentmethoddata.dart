/* class AttachedPaymentMethodData {
  String id;
  String object;
  dynamic acssDebit;
  dynamic affirm;
  dynamic afterpayClearpay;
  dynamic alipay;
  dynamic auBecsDebit;
  dynamic bacsDebit;
  dynamic bancontact;
  BillingDetails billingDetails;
  dynamic blik;
  dynamic boleto;
  CardDetails card;
  dynamic cardPresent;
  dynamic cashapp;
  int created;
  String customer;
  dynamic customerBalance;
  dynamic eps;
  dynamic fpx;
  dynamic giropay;
  dynamic grabpay;
  dynamic ideal;
  dynamic interacPresent;
  dynamic klarna;
  dynamic konbini;
  dynamic link;
  bool livemode;
  Map<String, dynamic> metadata;
  dynamic oxxo;
  dynamic p24;
  dynamic paynow;
  dynamic paypal;
  dynamic pix;
  dynamic promptpay;
  dynamic radarOptions;
  dynamic sepaDebit;
  dynamic sofort;
  String type;
  dynamic usBankAccount;
  dynamic wechatPay;
  dynamic zip;

  AttachedPaymentMethodData({
    required this.id,
    required this.object,
    this.acssDebit,
    this.affirm,
    this.afterpayClearpay,
    this.alipay,
    this.auBecsDebit,
    this.bacsDebit,
    this.bancontact,
    required this.billingDetails,
    this.blik,
    this.boleto,
    required this.card,
    this.cardPresent,
    this.cashapp,
    required this.created,
    required this.customer,
    this.customerBalance,
    this.eps,
    this.fpx,
    this.giropay,
    this.grabpay,
    this.ideal,
    this.interacPresent,
    this.klarna,
    this.konbini,
    this.link,
    required this.livemode,
    required this.metadata,
    this.oxxo,
    this.p24,
    this.paynow,
    this.paypal,
    this.pix,
    this.promptpay,
    this.radarOptions,
    this.sepaDebit,
    this.sofort,
    required this.type,
    this.usBankAccount,
    this.wechatPay,
    this.zip,
  });

  factory AttachedPaymentMethodData.fromJson(Map<String, dynamic> json) {
    return AttachedPaymentMethodData(
      id: json['id'],
      object: json['object'],
      acssDebit: json['acss_debit'],
      affirm: json['affirm'],
      afterpayClearpay: json['afterpay_clearpay'],
      alipay: json['alipay'],
      auBecsDebit: json['au_becs_debit'],
      bacsDebit: json['bacs_debit'],
      bancontact: json['bancontact'],
      billingDetails: BillingDetails.fromJson(json['billing_details']),
      blik: json['blik'],
      boleto: json['boleto'],
      card: CardDetails.fromJson(json['card']),
      cardPresent: json['card_present'],
      cashapp: json['cashapp'],
      created: json['created'],
      customer: json['customer'],
      customerBalance: json['customer_balance'],
      eps: json['eps'],
      fpx: json['fpx'],
      giropay: json['giropay'],
      grabpay: json['grabpay'],
      ideal: json['ideal'],
      interacPresent: json['interac_present'],
      klarna: json['klarna'],
      konbini: json['konbini'],
      link: json['link'],
      livemode: json['livemode'],
      metadata: Map<String, dynamic>.from(json['metadata']),
      oxxo: json['oxxo'],
      p24: json['p24'],
      paynow: json['paynow'],
      paypal: json['paypal'],
      pix: json['pix'],
      promptpay: json['promptpay'],
      radarOptions: json['radar_options'],
      sepaDebit: json['sepa_debit'],
      sofort: json['sofort'],
      type: json['type'],
      usBankAccount: json['us_bank_account'],
      wechatPay: json['wechat_pay'],
      zip: json['zip'],
    );
  }
}

class BillingDetails {
  Address? address;
  String email;
  String name;
  dynamic phone;

  BillingDetails({
    this.address,
    required this.email,
    required this.name,
    this.phone,
  });

  factory BillingDetails.fromJson(Map<String, dynamic> json) {
    return BillingDetails(
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class Address {
  dynamic city;
  String? country;
  dynamic line1;
  dynamic line2;
  String? postalCode;
  dynamic state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      country: json['country'],
      line1: json['line1'],
      line2: json['line2'],
      postalCode: json['postal_code'],
      state: json['state'],
    );
  }
}

class CardDetails {
  String brand;
  Checks checks;
  String country;
  dynamic description;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  dynamic iin;
  dynamic issuer;
  String last4;
  Networks networks;
  ThreeDSecureUsage threeDSecureUsage;
  dynamic wallet;

  CardDetails({
    required this.brand,
    required this.checks,
    required this.country,
    this.description,
    required this.expMonth,
    required this.expYear,
    required this.fingerprint,
    required this.funding,
    this.iin,
    this.issuer,
    required this.last4,
    required this.networks,
    required this.threeDSecureUsage,
    this.wallet,
  });

  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      brand: json['brand'],
      checks: Checks.fromJson(json['checks']),
      country: json['country'],
      description: json['description'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      fingerprint: json['fingerprint'],
      funding: json['funding'],
      iin: json['iin'],
      issuer: json['issuer'],
      last4: json['last4'],
      networks: Networks.fromJson(json['networks']),
      threeDSecureUsage:
          ThreeDSecureUsage.fromJson(json['three_d_secure_usage']),
      wallet: json['wallet'],
    );
  }
}

class Checks {
  dynamic addressLine1Check;
  String addressPostalCodeCheck;
  String cvcCheck;

  Checks({
    this.addressLine1Check,
    required this.addressPostalCodeCheck,
    required this.cvcCheck,
  });

  factory Checks.fromJson(Map<String, dynamic> json) {
    return Checks(
      addressLine1Check: json['address_line1_check'],
      addressPostalCodeCheck: json['address_postal_code_check'],
      cvcCheck: json['cvc_check'],
    );
  }
}

class Networks {
  List<String> available;
  dynamic preferred;

  Networks({
    required this.available,
    this.preferred,
  });

  factory Networks.fromJson(Map<String, dynamic> json) {
    return Networks(
      available: List<String>.from(json['available']),
      preferred: json['preferred'],
    );
  }
}

class ThreeDSecureUsage {
  bool supported;

  ThreeDSecureUsage({
    required this.supported,
  });

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    return ThreeDSecureUsage(
      supported: json['supported'],
    );
  }
}
 */

class AttachedPaymentMethodData {
  String id;
  String object;
  BillingDetails billingDetails;
  CardDetails card;
  String created;
  String customer;
  Map<String, dynamic> metadata;
  dynamic usBankAccount;
  dynamic wechatPay;
  dynamic zip;

  AttachedPaymentMethodData({
    required this.id,
    required this.object,
    required this.billingDetails,
    required this.card,
    required this.created,
    required this.customer,
    required this.metadata,
    this.usBankAccount,
    this.wechatPay,
    this.zip,
  });

  factory AttachedPaymentMethodData.fromJson(Map<String, dynamic> json) {
    return AttachedPaymentMethodData(
      id: json['id'],
      object: json['object'] ?? '',
      billingDetails: BillingDetails.fromJson(json['billingDetails']),
      card: CardDetails.fromJson(json['card']),
      created: json['created'] ?? '',
      customer: json['customer'] ?? '',
      metadata: Map<String, dynamic>.from(json['metadata']),
      usBankAccount: json['usBankAccount'] ?? '',
      wechatPay: json['wechatPay'] ?? '',
      zip: json['zip'] ?? '',
    );
  }
}

class BillingDetails {
  Address? address;
  String email;
  String name;
  dynamic phone;

  BillingDetails({
    this.address,
    required this.email,
    required this.name,
    this.phone,
  });

  factory BillingDetails.fromJson(Map<String, dynamic> json) {
    return BillingDetails(
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class Address {
  dynamic city;
  String? country;
  dynamic line1;
  dynamic line2;
  String? postalCode;
  dynamic state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      line1: json['line1'] ?? '',
      line2: json['line2'] ?? '',
      postalCode: json['postal_code'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class CardDetails {
  String brand;
  Checks checks;
  String country;
  dynamic description;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  dynamic iin;
  dynamic issuer;
  String last4;
  Networks networks;
  ThreeDSecureUsage threeDSecureUsage;
  dynamic wallet;

  CardDetails({
    required this.brand,
    required this.checks,
    required this.country,
    this.description,
    required this.expMonth,
    required this.expYear,
    required this.fingerprint,
    required this.funding,
    this.iin,
    this.issuer,
    required this.last4,
    required this.networks,
    required this.threeDSecureUsage,
    this.wallet,
  });

  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      brand: json['brand'] ?? '',
      checks: Checks.fromJson(json['checks']),
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      expMonth: json['expMonth'] ?? '',
      expYear: json['expYear'] ?? '',
      fingerprint: json['fingerprint'] ?? '',
      funding: json['funding'] ?? '',
      iin: json['iin'] ?? '',
      issuer: json['issuer'] ?? '',
      last4: json['last4'] ?? '',
      networks: Networks.fromJson(json['networks']),
      threeDSecureUsage: ThreeDSecureUsage.fromJson(json['threeDSecureUsage']),
      wallet: json['wallet'] ?? '',
    );
  }
}

class Checks {
  dynamic addressLine1Check;
  String addressPostalCodeCheck;
  String cvcCheck;

  Checks({
    this.addressLine1Check,
    required this.addressPostalCodeCheck,
    required this.cvcCheck,
  });

  factory Checks.fromJson(Map<String, dynamic> json) {
    return Checks(
      addressLine1Check: json['addressLine1check'],
      addressPostalCodeCheck: json['addressPostalCodeCheck'],
      cvcCheck: json['cvcCheck'],
    );
  }
}

class Networks {
  List<String> available;
  dynamic preferred;

  Networks({
    required this.available,
    this.preferred,
  });

  factory Networks.fromJson(Map<String, dynamic> json) {
    return Networks(
      available: List<String>.from(json['available'] ?? ''),
      preferred: json['preferred'] ?? '',
    );
  }
}

class ThreeDSecureUsage {
  bool supported;

  ThreeDSecureUsage({
    required this.supported,
  });

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    return ThreeDSecureUsage(
      supported: json['supported'] ?? '',
    );
  }
}
