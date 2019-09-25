import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/base/custom_error.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/force_update/force_update.dart';
import 'package:giv_flutter/features/splash/bloc/splash_bloc.dart';
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/app_icon.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class Splash extends StatefulWidget {
  final SplashBloc bloc;

  const Splash({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends BaseState<Splash> {
  SplashBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
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
    final response = await bloc.getConfig();

    if (response.status == HttpStatus.preconditionFailed)
      throw CustomError.forceUpdate;

    if (response.data != null) await bloc.persistAppConfig(response.data);
  }

  Future _getLocation() async {
    bool hasPreferredLocation = bloc.hasPreferredLocation();
    if (!hasPreferredLocation) {
      final response = await bloc.getMyLocation(Coordinates(0, 0));
      if (response.data != null) await bloc.persistLocation(Location.mock());
    }
  }

  Future _updateCurrentUser() async {
    bool isAuthenticated = bloc.isAuthenticated();
    if (isAuthenticated) {
      final response = await bloc.getMe();
      if (response.data != null) await bloc.persistUser(response.data);
    }
  }
}
