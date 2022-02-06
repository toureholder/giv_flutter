import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:giv_flutter/model/about_tile/about_tile.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/logo_text.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class About extends StatefulWidget {
  final AboutBloc bloc;

  const About({Key key, @required this.bloc}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends BaseState<About> {
  AboutBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.default_vertical_margin, vertical: 32.0),
        child: Column(
          children: <Widget>[
            LogoText(
              fontSize: 24.0,
            ),
            Caption(
              string(
                'about_version_x',
                formatArg: _bloc.versionName,
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
        child: BodyText(string('about_copyright_info')),
      ),
      AboutTileDivider(),
    ];

    final aboutTileModels = AboutTileModel.hardCodedList();

    for (int i = 0; i < aboutTileModels.length; i++) {
      final model = aboutTileModels[i];
      widgets.add(
        AboutTile(
          bloc: _bloc,
          title: string(model.formatSpec, formatArg: model.formatArg),
          url: model.url,
        ),
      );
      widgets.add(AboutTileDivider());
    }

    return CustomScaffold(
      appBar: CustomAppBar(title: string('settings_about')),
      body: ListView(
        children: widgets,
      ),
    );
  }
}

class AboutTile extends StatelessWidget {
  final String title;
  final String url;
  final AboutBloc bloc;

  const AboutTile({
    Key key,
    @required this.bloc,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
        child: BodyText(title),
      ),
      trailing: Icon(Icons.link),
      onTap: () {
        bloc.launchURL(url);
      },
    );
  }
}

class AboutTileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDivider();
  }
}
