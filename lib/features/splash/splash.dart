import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/model/location/location.dart';
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

    // TODO: await get business location (Location object)

    await Prefs.setLocation(Location.mock());
    Navigation(context).pushReplacement(Base());
  }
}
