import 'package:url_launcher/url_launcher.dart';

class Util {
  static getClickToChatUrl(String number, String message) =>
      Uri.encodeFull('https://wa.me/$number?text=$message');

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static openWhatsApp(String number, String message) async {
    var chatUrl = getClickToChatUrl(number, message);
    print(chatUrl);
    await launchURL(chatUrl);
  }
}