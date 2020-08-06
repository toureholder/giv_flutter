import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_bloc_with_auth.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:provider/provider.dart';

class AuthenticatedState<T extends StatefulWidget> extends State<T> {
  final BaseBlocWithAuth bloc;
  final Widget screenContent;
  User _user;

  AuthenticatedState({
    @required this.bloc,
    @required this.screenContent,
  });

  @override
  void initState() {
    super.initState();
    _user = bloc.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? screenContent
        : Consumer<LogInBloc>(
            builder: (context, bloc, child) => SignIn(
              bloc: bloc,
              redirect: screenContent,
            ),
          );
  }
}
