import 'package:flutter/widgets.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  final DiskStorageProvider diskStorage;

  Util({@required this.diskStorage});

  getClickToChatUrl(String number, String message) =>
      Uri.encodeFull('https://wa.me/$number?text=$message');

  launchURL(String url, {bool forceWebView = false}) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: forceWebView);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchTermsURL() async {
    AppConfig appConfig = diskStorage.getAppConfiguration();
    final url = appConfig.termsOfServiceUrl;
    if (url != null) launchURL(url, forceWebView: true);
  }

  launchPrivacyURL() async {
    AppConfig appConfig = diskStorage.getAppConfiguration();
    final url = appConfig.privacyPolicyUrl;
    if (url != null) launchURL(url, forceWebView: true);
  }

  openPhoneApp(String number) async {
    await launchURL('tel:+$number');
  }

  openWhatsApp(String number, String message) async {
    var chatUrl = getClickToChatUrl(number, message);
    await launchURL(chatUrl);
  }

  launchCustomerService(String message) async {
    AppConfig appConfig = diskStorage.getAppConfiguration();
    if (appConfig?.customerServiceNumber != null)
      openWhatsApp(appConfig.customerServiceNumber, message);
  }

  String getCurrentLocaleString(BuildContext context) {
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
