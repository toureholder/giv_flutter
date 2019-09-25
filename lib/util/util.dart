import 'package:flutter/widgets.dart';
import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  // TODO: Inject an instance as a dependency and depend on disk storage


  static getClickToChatUrl(String number, String message) =>
      Uri.encodeFull('https://wa.me/$number?text=$message');

  static launchURL(String url, {bool forceWebView = false}) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: forceWebView);
    } else {
      throw 'Could not launch $url';
    }
  }

  static launchTermsURL() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(sharedPreferences);

    AppConfig appConfig = storage.getAppConfiguration();
    final url = appConfig.termsOfServiceUrl;
    if (url != null) launchURL(url, forceWebView: true);
  }

  static launchPrivacyURL() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(sharedPreferences);

    AppConfig appConfig = storage.getAppConfiguration();
    final url = appConfig.privacyPolicyUrl;
    if (url != null) launchURL(url, forceWebView: true);
  }

  static openPhoneApp(String number) async {
    await launchURL('tel:+$number');
  }

  static openWhatsApp(String number, String message) async {
    var chatUrl = getClickToChatUrl(number, message);
    await launchURL(chatUrl);
  }

  static launchCustomerService(String message) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(sharedPreferences);

    AppConfig appConfig = storage.getAppConfiguration();
    if (appConfig?.customerServiceNumber != null)
      openWhatsApp(appConfig.customerServiceNumber, message);
  }

  static String getCurrentLocaleString(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale == null) return null;

    final buffer = new StringBuffer();

    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;

    if (languageCode != null && languageCode.isNotEmpty) {
      buffer.write(languageCode);
    }

    if (countryCode != null && countryCode.isNotEmpty) {
      buffer.write('_');
      buffer.write(countryCode);
    }

    return buffer.toString();
  }
}
