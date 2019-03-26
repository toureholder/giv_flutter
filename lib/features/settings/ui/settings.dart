import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/about/about.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/profile.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/termos_of_service_acceptance_caption.dart';
import 'package:giv_flutter/values/custom_icons_icons.dart';
import 'package:giv_flutter/values/dimens.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends BaseState<Settings> {
  SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc();
    _settingsBloc.loadUserFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: string('common_me')),
      body: ContentStreamBuilder(
        stream: _settingsBloc.userStream,
        onHasData: (StreamEvent<User> event) {
          if (event.isReady) return _stack(event.data);
        },
      ),
    );
  }

  Stack _stack(User user) {
    return Stack(
      children: <Widget>[_mainListView(user), _footer()],
    );
  }

  ListView _mainListView(User user) {
    return ListView(
      children: <Widget>[
        SettingsListTile(
          leading: AvatarImage(image: CustomImage.Image(url: user.avatarUrl)),
          text: string('profile_title'),
          onTap: _goToProfile,
        ),
        Divider(
          height: 1.0,
        ),
        SettingsListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Icon(
              CustomIcons.gift,
              size: Dimens.settings_tile_icon_size,
            ),
          ),
          text: string('me_listings'),
          onTap: () {
            navigation.push(MyListings());
          },
        ),
        Divider(
          height: 1.0,
        ),
        SettingsListTile(
          leading: Icon(
            Icons.help_outline,
          ),
          text: string('common_help'),
          onTap: _whatsAppCustomerService,
          hideTrailing: true,
        ),
        Divider(
          height: 1.0,
        ),
        SettingsListTile(
          leading: Icon(
            Icons.info_outline,
          ),
          text: string('settings_about'),
          onTap: () {
            navigation.push(About());
          },
          hideTrailing: true,
        ),
        Divider(
          height: 1.0,
        ),
        SettingsListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Icon(
              CustomIcons.logout,
              size: Dimens.settings_tile_icon_size,
            ),
          ),
          text: string('settings_logout'),
          onTap: _confirmLogout,
          hideTrailing: true,
        ),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  Positioned _footer() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: SafeArea(child: _termsOfService()),
    );
  }

  Padding _termsOfService() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.default_horizontal_margin, vertical: 32.0),
        child: TermsOfServiceAcceptanceCaption(
          prefix: 'terms_acceptance_caption_read_',
        ));
  }

  void _confirmLogout() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(string('logout_confirmation_title')),
            actions: <Widget>[
              FlatButton(
                child: Text(string('shared_action_cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(string('logout_confirmation_accept_button')),
                  onPressed: _logout)
            ],
          );
        });
  }

  void _logout() async {
    await Prefs.logout();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.signOut();
    FacebookLogin().logOut();
    navigation.push(Base(), clearStack: true);
  }

  void _whatsAppCustomerService() {
    handleCustomerServiceRequest(string('help_message'));
  }

  void _goToProfile() async {
    await navigation.push(Profile());
    _settingsBloc.loadUserFromPrefs();
  }
}

class SettingsListTile extends StatelessWidget {
  final Widget leading;
  final String text;
  final GestureTapCallback onTap;
  final bool hideTrailing;

  const SettingsListTile(
      {Key key, this.leading, this.text, this.onTap, this.hideTrailing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(text),
      trailing: hideTrailing ? null : Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
