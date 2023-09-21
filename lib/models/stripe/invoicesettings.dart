class InvoiceSettings {
  dynamic customFields;
  dynamic defaultPaymentMethod;
  dynamic footer;
  dynamic renderingOptions;

  InvoiceSettings({
    this.customFields,
    this.defaultPaymentMethod,
    this.footer,
    this.renderingOptions,
  });

  factory InvoiceSettings.fromJson(Map<String, dynamic> json) {
    return InvoiceSettings(
      customFields: json['custom_fields'],
      defaultPaymentMethod: json['default_payment_method'],
      footer: json['footer'],
      renderingOptions: json['rendering_options'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'custom_fields': customFields,
      'default_payment_method': defaultPaymentMethod,
      'footer': footer,
      'rendering_options': renderingOptions,
    };
  }
}
