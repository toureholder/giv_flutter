import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/logo_text.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:giv_flutter/values/dimens.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends BaseState<About> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: string('settings_about')),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.default_vertical_margin, vertical: 32.0),
            child: Column(
              children: <Widget>[
                LogoText(
                  fontSize: 24.0,
                ),
                Caption(
                    string('about_version_x', formatArg: Config.versionName))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
            child: BodyText(string('about_copyright_info')),
          ),
          AboutTileDivider(),
          AboutTile(
              title: string('about_copyright_info_icons_made_by_',
                  formatArg: 'Freepik'),
              url: 'https://www.freepik.com'),
          AboutTileDivider(),
          AboutTile(
              title: string('about_copyright_info_icons_from_',
                  formatArg: 'www.flaticon.com'),
              url: 'https://www.flaticon.com'),
          AboutTileDivider(),
        ],
      ),
    );
  }
}

class AboutTile extends StatelessWidget {
  final String title;
  final String url;

  const AboutTile({Key key, this.title, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
        child: BodyText(title),
      ),
      trailing: Icon(Icons.link),
      onTap: () {
        Util.launchURL(url);
      },
    );
  }
}

class AboutTileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1.0);
  }
}
