import 'package:advisorapp/models/stripe/invoicesettings.dart';
import 'package:advisorapp/models/stripe/metadata.dart';

class Customer {
  String id;
  String object;
  dynamic address;
  int balance;
  int created;
  String currency;
  String defaultSource;
  bool delinquent;
  String description;
  dynamic discount;
  dynamic email;
  String invoicePrefix;
  InvoiceSettings invoiceSettings;
  bool livemode;
  Metadata metadata;
  dynamic name;
  int nextInvoiceSequence;
  dynamic phone;
  List<String> preferredLocales;
  dynamic shipping;
  String taxExempt;
  dynamic testClock;

  Customer({
    required this.id,
    required this.object,
    this.address,
    required this.balance,
    required this.created,
    required this.currency,
    required this.defaultSource,
    required this.delinquent,
    required this.description,
    this.discount,
    this.email,
    required this.invoicePrefix,
    required this.invoiceSettings,
    required this.livemode,
    required this.metadata,
    this.name,
    required this.nextInvoiceSequence,
    this.phone,
    required this.preferredLocales,
    this.shipping,
    required this.taxExempt,
    this.testClock,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      object: json['object'] ?? '',
      address: json['address'] ?? '',
      balance: json['balance'] ?? '',
      created: json['created'] ?? '',
      currency: json['currency'] ?? '',
      defaultSource: json['default_source'] ?? '',
      delinquent: json['delinquent'] ?? '',
      description: json['description'] ?? '',
      discount: json['discount'] ?? '',
      email: json['email'] ?? '',
      invoicePrefix: json['invoice_prefix'] ?? '',
      invoiceSettings: InvoiceSettings.fromJson(json['invoice_settings'] ?? ''),
      livemode: json['livemode'] ?? '',
      metadata: Metadata.fromJson(json['metadata'] ?? ''),
      name: json['name'] ?? '',
      nextInvoiceSequence: json['next_invoice_sequence'] ?? '',
      phone: json['phone'] ?? '',
      preferredLocales: json['preferred_locales'] != null
          ? List<String>.from(json['preferred_locales'])
          : [],
      shipping: json['shipping'] ?? '',
      taxExempt: json['tax_exempt'] ?? '',
      testClock: json['test_clock'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'address': address,
      'balance': balance,
      'created': created,
      'currency': currency,
      'default_source': defaultSource,
      'delinquent': delinquent,
      'description': description,
      'discount': discount,
      'email': email,
      'invoice_prefix': invoicePrefix,
      'invoice_settings': invoiceSettings.toJson(),
      'livemode': livemode,
      'metadata': metadata,
      'name': name,
      'next_invoice_sequence': nextInvoiceSequence,
      'phone': phone,
      'preferred_locales': preferredLocales,
      'shipping': shipping,
      'tax_exempt': taxExempt,
      'test_clock': testClock,
    };
  }
}
