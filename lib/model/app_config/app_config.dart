class AppConfig {
  final String customerServiceNumber;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final List<String> randomBackgrounds;

  AppConfig({
    this.privacyPolicyUrl,
    this.termsOfServiceUrl,
    this.randomBackgrounds,
    this.customerServiceNumber,
  });

  static final String customerServiceKey = 'customer_service_number';
  static final String privacyPolicyUrlKey = 'privacy_policy_url';
  static final String termsOfServiceUrlKey = 'terms_of_service_url';
  static final String randomBackgroundsKey = 'random_backgrounds';

  AppConfig.fromJson(Map<String, dynamic> json)
      : customerServiceNumber = json[customerServiceKey],
        privacyPolicyUrl = json[privacyPolicyUrlKey],
        termsOfServiceUrl = json[termsOfServiceUrlKey],
        randomBackgrounds = json[randomBackgroundsKey] == null
            ? null
            : AppConfig.stringsListFromDynamicList(
                json[randomBackgroundsKey],
              );

  Map<String, dynamic> toJson() => {
        customerServiceKey: customerServiceNumber,
        privacyPolicyUrlKey: privacyPolicyUrl,
        termsOfServiceUrlKey: termsOfServiceUrl,
        randomBackgroundsKey: randomBackgrounds,
      };

  factory AppConfig.fake() => AppConfig(
        privacyPolicyUrl: 'http://policy',
        termsOfServiceUrl: 'http://termos',
        customerServiceNumber: '987654321',
      );

  static List<String> stringsListFromDynamicList(List<dynamic> list) {
    return list.map<String>((json) => json).toList();
  }
}
