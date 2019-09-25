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
}
