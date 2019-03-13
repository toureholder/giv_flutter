class AppConfig {
  final String customerServiceNumber;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;

  AppConfig(this.privacyPolicyUrl, this.termsOfServiceUrl,
      {this.customerServiceNumber});

  static final String customerServiceKey = 'customer_service_number';
  static final String privacyPolicyUrlKey = 'privacy_policy_url';
  static final String termsOfServiceUrlKey = 'terms_of_service_url';

  AppConfig.fromJson(Map<String, dynamic> json)
      : customerServiceNumber = json[customerServiceKey],
        privacyPolicyUrl = json[privacyPolicyUrlKey],
        termsOfServiceUrl = json[termsOfServiceUrlKey];

  Map<String, dynamic> toJson() => {
        customerServiceKey: customerServiceNumber,
        privacyPolicyUrlKey: privacyPolicyUrl,
        termsOfServiceUrlKey: termsOfServiceUrl
      };
}
