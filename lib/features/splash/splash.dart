import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

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
        child: Text(string('app_name')),
      ),
    );
  }

  _awaitTasks() async {
    // TODO: await get device location (lat, long)

    await _getLocation();
    await _updateCurrentUser();

    Navigation(context).pushReplacement(Base());
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
