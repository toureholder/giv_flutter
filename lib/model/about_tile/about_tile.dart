import 'package:meta/meta.dart';

class AboutTileModel {
  final String formatSpec;
  final String formatArg;
  final String url;

  AboutTileModel({
    @required this.formatSpec,
    @required this.formatArg,
    @required this.url,
  });

  static List<AboutTileModel> hardCodedList() => [
        AboutTileModel(
          formatSpec: 'about_copyright_info_icons_made_by_',
          formatArg: 'Freepik',
          url: 'https://www.freepik.com',
        ),
        AboutTileModel(
          formatSpec: 'about_copyright_info_icons_from_',
          formatArg: 'www.flaticon.com',
          url: 'https://www.flaticon.com',
        ),
      ];

  static List<String> hardCodedDependencyList() => [
        'adaptive_layout',
        'cached_network_image',
        'country_code_picker',
        'faker',
        'firebase_auth',
        'firebase_core',
        'firebase_storage',
        'flutter_facebook_auth',
        'flutter_svg',
        'google_sign_in',
        'hive',
        'hive_flutter',
        'http',
        'http_multi_server',
        'image_cropper',
        'image_picker',
        'package_info',
        'photo_view',
        'pin_code_fields',
        'provider',
        'rxdart',
        'shared_preferences',
        'share',
        'sign_in_with_apple',
        'url_launcher',
        'uuid',
      ];
}
