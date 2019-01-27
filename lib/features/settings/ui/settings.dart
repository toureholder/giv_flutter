import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/profile.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/cirucluar_network_image.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/util.dart';
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
    _settingsBloc.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: string('common_me')),
      body: ContentStreamBuilder(
        stream: _settingsBloc.userStream,
        onHasData: (StreamEvent<User> event) {
          if (event.isReady) return _buildListView(event.data);
        },
      ),
    );
  }

  ListView _buildListView(User user) {
    return ListView(
      children: <Widget>[
        SettingsListTile(
          leading: CircularNetworkImage(imageUrl: user.avatarUrl),
          text: string('settings_section_profile'),
          onTap: () {
            navigation.push(Profile());
          },
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
            Icons.help,
          ),
          text: string('common_help'),
          onTap: _whatsAppCustomerService,
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
        ),
      ],
    );
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
    await Prefs.clear();
    navigation.push(Base(), clearStack: true);
  }

  void _whatsAppCustomerService() {
    Util.openWhatsApp(Config.customerServiceNumber, string('help_message'));
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
