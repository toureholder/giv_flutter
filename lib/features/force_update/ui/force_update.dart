import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart'
    as CustomTypography;
import 'package:giv_flutter/values/dimens.dart';

class ForceUpdate extends StatefulWidget {
  final ForceUpdateBloc bloc;

  const ForceUpdate({Key key, @required this.bloc}) : super(key: key);

  @override
  _ForceUpdateState createState() => _ForceUpdateState();
}

class _ForceUpdateState extends BaseState<ForceUpdate> {
  ForceUpdateBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(Dimens.double_default_margin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _image(),
              Spacing.vertical(Dimens.double_default_margin),
              _title(),
              Spacing.vertical(Dimens.default_vertical_margin),
              _subtitle(),
              Spacing.vertical(Dimens.double_default_margin),
              _primaryButton()
            ],
          ),
        ),
      ),
    );
  }

  Center _image() => Center(
        child: SvgPicture.asset(
          'images/undraw_synchronize_1e88e5.svg',
          width: 192,
          fit: BoxFit.cover,
        ),
      );

  CustomTypography.Title _title() =>
      CustomTypography.Title(string('force_update_title'),
          weight: CustomTypography.SyntheticFontWeight.bold);

  CustomTypography.Subtitle _subtitle() => CustomTypography.Subtitle(
        string('force_update_message'),
        textAlign: TextAlign.center,
      );

  PrimaryButton _primaryButton() => PrimaryButton(
        fillWidth: false,
        text: string('force_update_button'),
        onPressed: () {
          final String url = Platform.isIOS
              ? Config.iTunesLink
              : Platform.isAndroid
                  ? Config.googlePlayLink
                  : Config.website;

          _bloc.launchURL(url);
        },
      );
}
