import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_bio.dart';
import 'package:giv_flutter/features/settings/ui/edit_name.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/cirucluar_network_image.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends BaseState<Profile> {
  SettingsBloc _settingsBloc;
  User _user;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc();
    _settingsBloc.loadUser();
  }

  @override
  void dispose() {
    _settingsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('settings_section_profile'),
      ),
      body: ContentStreamBuilder(
        stream: _settingsBloc.userStream,
        onHasData: (StreamEvent<User> event) {
          _user = event.data;
          return _buildListView();
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView(
      children: <Widget>[
        _avatar(_user),
        _sectionTitle(string('settings_section_profile')),
        _itemTile(
            value: _user.phoneNumber == null
                ? null
                : '+${_user.countryCallingCode} ${_user.phoneNumber}',
            caption: string('settings_phone_number'),
            emptyStateCaption: string('settings_phone_number_empty_state'),
            onTap: _editPhoneNumber),
        Divider(
          height: 1.0,
        ),
        _itemTile(
            value: _user.name,
            caption: string('settings_name'),
            emptyStateCaption: string('settings_name_empty_state'),
            onTap: _editName),
        Divider(
          height: 1.0,
        ),
        _itemTile(
            value: _user.bio,
            caption: string('settings_bio'),
            emptyStateCaption: string('settings_bio_empty_state'),
            onTap: _editBio),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  Widget _itemTile(
      {String value,
      String caption,
      String emptyStateCaption,
      GestureTapCallback onTap}) {
    var finalValue = value ?? caption;
    var finalCaption = value == null ? emptyStateCaption : caption;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 12.0, horizontal: Dimens.default_horizontal_margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BodyText(finalValue),
              Body2Text(finalCaption, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(User user) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Row(
          children: <Widget>[
            CircularNetworkImage(
              imageUrl: user.avatarUrl,
              width: 64.0,
              height: 64.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.default_horizontal_margin,
            right: Dimens.default_horizontal_margin,
            top: Dimens.default_vertical_margin,
            bottom: 8.0),
        child: Subtitle(text,
            weight: SyntheticFontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  void _editBio() async {
    final result = await navigation.push(EditBio(
      user: _user,
    ));
    if (result != null) _settingsBloc.loadUser();
  }

  void _editName() async {
    final result = await navigation.push(EditName(
      user: _user,
    ));
    if (result != null) _settingsBloc.loadUser();
  }

  void _editPhoneNumber() async {
    final result = await navigation.push(EditPhoneNumber(
      user: _user,
    ));
    if (result != null) _settingsBloc.loadUser();
  }
}
