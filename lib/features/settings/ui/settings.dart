import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:giv_flutter/features/about/ui/about.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_profile.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/termos_of_service_acceptance_caption.dart';
import 'package:giv_flutter/values/custom_icons_icons.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final SettingsBloc bloc;

  const Settings({Key key, @required this.bloc}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends BaseState<Settings> {
  SettingsBloc _settingsBloc;
  User _user;

  @override
  void initState() {
    super.initState();
    _settingsBloc = widget.bloc;
    _user = _settingsBloc.getUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(),
      body: _stack(_user),
    );
  }

  Stack _stack(User user) {
    return Stack(
      children: <Widget>[_mainListView(user), _footer()],
    );
  }

  ListView _mainListView(User user) {
    final isAuthenticated = user != null;

    return ListView(
      children: <Widget>[
        if (!isAuthenticated) SignInTile(onTap: _goToSignIn),
        if (isAuthenticated)
          ProfileTile(avatarUrl: user.avatarUrl, onTap: _goToProfile),
        CustomDivider(),
        SetLocationTile(onTap: _goToLocationFilter),
        CustomDivider(),
        if (isAuthenticated) MyListingsTile(onTap: _goToMyListings),
        if (isAuthenticated) CustomDivider(),
        if (isAuthenticated) MyGroupsTile(onTap: _navigateToMyGroups),
        if (isAuthenticated) CustomDivider(),
        AboutTheAppTile(onTap: _goToAbout),
        CustomDivider(),
        HelpTile(onTap: _whatsAppCustomerService),
        CustomDivider(),
        if (isAuthenticated) LogOutTile(onTap: _confirmLogout),
        if (isAuthenticated) CustomDivider()
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
          util: _settingsBloc.util,
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
    await _settingsBloc.logout();
    navigation.push(Base(), clearStack: true);
  }

  void _whatsAppCustomerService() {
    handleCustomerServiceRequest(string('help_message'));
  }

  void _goToProfile() async {
    await navigation.push(Consumer<SettingsBloc>(
      builder: (context, bloc, child) => EditProfile(
        settingsBloc: bloc,
      ),
    ));

    setState(() {
      _user = _settingsBloc.getUser();
    });
  }

  void _goToSignIn() {
    navigation.push(Consumer<LogInBloc>(
      builder: (context, bloc, child) => SignIn(
        bloc: bloc,
      ),
    ));
  }

  void _goToLocationFilter() {
    navigation.push(Consumer<LocationFilterBloc>(
      builder: (context, bloc, child) => LocationFilter(
        bloc: bloc,
        showSaveButton: true,
        requireCompleteLocation: true,
      ),
    ));
  }

  void _goToMyListings() {
    navigation.push(Consumer<MyListingsBloc>(
      builder: (context, bloc, child) => MyListings(
        bloc: bloc,
      ),
    ));
  }

  void _navigateToMyGroups() => navigation.push(Consumer<MyGroupsBloc>(
        builder: (context, bloc, child) => MyGroupsScreen(bloc: bloc),
      ));

  void _goToAbout() {
    navigation.push(Consumer<AboutBloc>(
      builder: (context, bloc, child) => About(
        bloc: bloc,
      ),
    ));
  }
}

class SettingsListTile extends StatelessWidget {
  final Widget leading;
  final String text;
  final GestureTapCallback onTap;
  final bool hideTrailing;

  const SettingsListTile({
    Key key,
    this.leading,
    this.text,
    this.onTap,
    this.hideTrailing = false,
  }) : super(key: key);

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

class SignInTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const SignInTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Icon(Icons.account_circle_outlined),
      text: GetLocalizedStringFunction(context)('shared_action_sign_in'),
      onTap: onTap,
    );
  }
}

class SetLocationTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const SetLocationTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Icon(Icons.location_pin),
      text: GetLocalizedStringFunction(context)('location_filter_title'),
      onTap: onTap,
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String avatarUrl;
  final GestureTapCallback onTap;

  const ProfileTile({
    Key key,
    @required this.avatarUrl,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: AvatarImage(image: CustomImage.Image(url: avatarUrl)),
      text: GetLocalizedStringFunction(context)('profile_title'),
      onTap: onTap,
    );
  }
}

class MyListingsTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const MyListingsTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Icon(
          CustomIcons.gift,
          size: Dimens.settings_tile_icon_size,
        ),
      ),
      text: GetLocalizedStringFunction(context)('me_listings'),
      onTap: onTap,
    );
  }
}

class MyGroupsTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const MyGroupsTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Icon(Icons.group),
      ),
      text: GetLocalizedStringFunction(context)('me_groups'),
      onTap: onTap,
    );
  }
}

class HelpTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const HelpTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Icon(Icons.help_outline),
      text: GetLocalizedStringFunction(context)('common_help'),
      onTap: onTap,
      hideTrailing: true,
    );
  }
}

class LogOutTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const LogOutTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Icon(
          CustomIcons.logout,
          size: Dimens.settings_tile_icon_size,
        ),
      ),
      text: GetLocalizedStringFunction(context)('settings_logout'),
      onTap: onTap,
      hideTrailing: true,
    );
  }
}

class AboutTheAppTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const AboutTheAppTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      leading: Icon(
        Icons.info_outline,
      ),
      text: GetLocalizedStringFunction(context)('settings_about'),
      onTap: onTap,
    );
  }
}
