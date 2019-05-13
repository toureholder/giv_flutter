import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/base/custom_error.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/force_update/force_update.dart';
import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/app_icon.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends BaseState<Splash> {
  @override
  void initState() {
    super.initState();
    _awaitTasks();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      body: Center(
        child: AppIcon(),
      ),
    );
  }

  _awaitTasks() async {
    // TODO: await get device location (lat, long)

    try {
      await Future.wait([_getSettings(), _getLocation(), _updateCurrentUser()]);
    } catch (error) {
      if (error == CustomError.forceUpdate)
        navigation.pushReplacement(ForceUpdate());
        return;
    }

    Navigation(context).pushReplacement(Base());
  }

  Future _getSettings() async {
    final response = await AppConfigRepository().getConfig();

    if (response.status == HttpStatus.preconditionFailed)
      throw CustomError.forceUpdate;

    if (response.data != null) await Prefs.setSettings(response.data);
  }

  Future _getLocation() async {
    bool hasPreferredLocation = await Prefs.hasPreferredLocation();
    if (!hasPreferredLocation) {
      final response =
          await LocationRepository().getMyLocation(Coordinates(0, 0));
      if (response.data != null) await Prefs.setLocation(Location.mock());
    }
  }

  Future _updateCurrentUser() async {
    bool isAuthenticated = await Prefs.isAuthenticated();
    if (isAuthenticated) {
      final response = await UserRepository().getMe();
      if (response.data != null) await Prefs.setUser(response.data);
    }
  }
}
