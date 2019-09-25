import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/base/custom_error.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:giv_flutter/features/force_update/ui/force_update.dart';
import 'package:giv_flutter/features/splash/bloc/splash_bloc.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/app_icon.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:provider/provider.dart';

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
    bloc.runTasks();
    _listenToTasksStatus();
  }

  _listenToTasksStatus() {
    bloc.tasksStateStream?.listen(_onTasksSuccess, onError: _onTasksError);
  }

  _onTasksSuccess(bool isSuccess) {
    if (isSuccess) Navigation(context).pushReplacement(Base());
  }

  _onTasksError(error) {
    if (error == CustomError.forceUpdate) {
      Navigation(context).pushReplacement(Consumer<ForceUpdateBloc>(
        builder: (context, bloc, child) => ForceUpdate(
          bloc: bloc,
        ),
      ));

      return;
    }

    Navigation(context).pushReplacement(Base());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: AppIcon(),
      ),
    );
  }
}
