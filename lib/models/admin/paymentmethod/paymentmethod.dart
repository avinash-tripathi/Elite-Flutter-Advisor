class PaymentMethod {
  List<PaymentMethodOptions> paymentMethods;
  PaymentMethod({required this.paymentMethods});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((method) => PaymentMethodOptions.fromJson(method))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'paymentMethods':
          paymentMethods.map((method) => method.toJson()).toList(),
    };
  }
}

class PaymentMethodOptions {
  BankCard? card;
  BankAccount? bankaccount;
  PaymentMethodOptions({this.card, this.bankaccount});
  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    return PaymentMethodOptions(
      card: json['card'] != null ? BankCard.fromJson(json['card']) : null,
      bankaccount: json['bankaccount'] != null
          ? BankAccount.fromJson(json['bankaccount'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card': card?.toJson(),
      'bankaccount': bankaccount?.toJson(),
    };
  }
}

class BankCard {
  String? cardHolderName = '';
  String? cardNumber = '';
  String? cvv = '';
  String? expiresOn = '';
  String? zipCode = '';
  String? cardType = '';
  BankCard({
    this.cardHolderName,
    this.cardNumber,
    this.cvv,
    this.expiresOn,
    this.zipCode,
    this.cardType,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      cardHolderName: json['cardHolderName'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      cvv: json['cvv'] ?? '',
      expiresOn: json['expiresOn'] ?? '',
      zipCode: json['zipCode'] ?? '',
      cardType: json['cardType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'expiresOn': expiresOn,
      'zipCode': zipCode,
      'cardType': cardType,
    };
  }
}

class BankAccount {
  String? bankName = '';
  String? accountType = '';
  String? accountNumber = '';
  String? routingNumber = '';
  BankAccount({
    this.bankName,
    this.accountType,
    this.accountNumber,
    this.routingNumber,
  });

  BankAccount.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'] ?? '';
    accountType = json['accountType'] ?? '';
    accountNumber = json['accountNumber'] ?? '';
    routingNumber = json['routingNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountType': accountType,
      'accountNumber': accountNumber,
      'routingNumber': routingNumber,
    };
  }
}
