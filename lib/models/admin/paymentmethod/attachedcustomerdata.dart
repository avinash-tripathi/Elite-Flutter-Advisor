/* class AttachedCustomerData {
  final String id;
  final String object;
  final dynamic address;
  final int balance;
  final dynamic cashBalance;
  final int created;
  final dynamic currency;
  final dynamic defaultSource;
  final bool delinquent;
  final String description;
  final dynamic discount;
  final String email;
  final dynamic invoiceCreditBalance;
  final String invoicePrefix;
  final InvoiceSettings invoiceSettings;
  final bool livemode;
  final Metadata metadata;
  final String name;
  final int nextInvoiceSequence;
  final dynamic phone;
  final List<String> preferredLocales;
  final dynamic shipping;
  final dynamic sources;
  final dynamic subscriptions;
  final dynamic tax;
  final String taxExempt;
  final dynamic taxIds;
  final dynamic testClock;
  AttachedCustomerData({
    required this.id,
    required this.object,
    required this.address,
    required this.balance,
    required this.cashBalance,
    required this.created,
    required this.currency,
    required this.defaultSource,
    required this.delinquent,
    required this.description,
    required this.discount,
    required this.email,
    required this.invoiceCreditBalance,
    required this.invoicePrefix,
    required this.invoiceSettings,
    required this.livemode,
    required this.metadata,
    required this.name,
    required this.nextInvoiceSequence,
    required this.phone,
    required this.preferredLocales,
    required this.shipping,
    required this.sources,
    required this.subscriptions,
    required this.tax,
    required this.taxExempt,
    required this.taxIds,
    required this.testClock,
  });

  factory AttachedCustomerData.fromJson(Map<String, dynamic> json) {
    return AttachedCustomerData(
      id: json['id'],
      object: json['object'],
      address: json['address'],
      balance: json['balance'],
      cashBalance: json['cash_balance'],
      created: json['created'],
      currency: json['currency'],
      defaultSource: json['default_source'],
      delinquent: json['delinquent'],
      description: json['description'],
      discount: json['discount'],
      email: json['email'],
      invoiceCreditBalance: json['invoice_credit_balance'],
      invoicePrefix: json['invoice_prefix'],
      invoiceSettings: InvoiceSettings.fromJson(json['invoice_settings']),
      livemode: json['livemode'],
      metadata: Metadata.fromJson(json['metadata']),
      name: json['name'],
      nextInvoiceSequence: json['next_invoice_sequence'],
      phone: json['phone'],
      preferredLocales: List<String>.from(json['preferred_locales']),
      shipping: json['shipping'],
      sources: json['sources'],
      subscriptions: json['subscriptions'],
      tax: json['tax'],
      taxExempt: json['tax_exempt'],
      taxIds: json['tax_ids'],
      testClock: json['test_clock'],
    );
  }
}

class InvoiceSettings {
  // Add fields here based on the structure of the 'invoice_settings' object
  InvoiceSettings(); // You can add constructor and fields as needed

  factory InvoiceSettings.fromJson(Map<String, dynamic> json) {
    return InvoiceSettings();
  }
}

class Metadata {
  // Add fields here based on the structure of the 'metadata' object
  Metadata(); // You can add constructor and fields as needed

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata();
  }
}
 */

class AttachedCustomerData {
  final String id;
  final String object;
  final dynamic address;
  final dynamic currency;
  final String description;
  final String email;

  final String name;
  final dynamic phone;

  AttachedCustomerData({
    required this.id,
    required this.object,
    required this.address,
    required this.currency,
    required this.description,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory AttachedCustomerData.fromJson(Map<String, dynamic> json) {
    return AttachedCustomerData(
      id: json['id'],
      object: json['object'] ?? '',
      address: json['address'] ?? '',
      currency: json['currency'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class InvoiceSettings {
  // Add fields here based on the structure of the 'invoice_settings' object
  InvoiceSettings(); // You can add constructor and fields as needed

  factory InvoiceSettings.fromJson(Map<String, dynamic> json) {
    return InvoiceSettings();
  }
}

class Metadata {
  // Add fields here based on the structure of the 'metadata' object
  Metadata(); // You can add constructor and fields as needed

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata();
  }
}
