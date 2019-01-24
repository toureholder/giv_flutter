import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/model/user/log_in_with_provider.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends BaseState<SignIn> {
  LogInBloc _logInBloc;

  @override
  void initState() {
    super.initState();
    _logInBloc = LogInBloc();
    _logInBloc.responseStream.listen((StreamEvent<LogInResponse> event) {
      if (event.isReady) _onLoginSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(child: Container()),
          ],
        ),
        CustomScaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          body: StreamBuilder(
              stream: _logInBloc.responseStream,
              builder: (context, snapshot) {
                var isLoading = snapshot?.data?.isLoading ?? false;
                return _buildMainColumn(isLoading);
              }),
        )
      ],
    );
  }

  Column _buildMainColumn(bool isFacebookLoading) {
    return Column(
      children: <Widget>[
        Flexible(
          child: Container(
            child: Center(child: Text(string('app_name'))),
          ),
        ),
        _buildButtonsContainer(isFacebookLoading)
      ],
    );
  }

  Container _buildButtonsContainer(bool isFacebookLoading) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.grid(15), vertical: Dimens.grid(30)),
      child: Column(
        children: <Widget>[
          FacebookButton(
            text: string('sign_in_continue_with_facebook'),
            onPressed: _facebookLogin,
            isLoading: isFacebookLoading,
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          _buildSignUpButton(isFacebookLoading),
          Spacing.vertical(Dimens.default_vertical_margin),
          Body2Text(string('sign_in_already_have_an_acount')),
          Spacing.vertical(Dimens.default_vertical_margin),
          _buildLoginButton(isFacebookLoading)
        ],
      ),
    );
  }

  GreyButton _buildLoginButton(bool isFacebookLoading) {
    final onPressed = isFacebookLoading ? null : _goToLogIn;
    return GreyButton(
          text: string('sign_in_log_in'),
          onPressed: onPressed,
        );
  }

  PrimaryButton _buildSignUpButton(bool isFacebookLoading) {
    final onPressed = isFacebookLoading ? null : _goToSignUp;
    return PrimaryButton(
          text: string('sign_in_sign_up'),
          onPressed: onPressed,
        );
  }

  void _goToSignUp() {
    navigation.push(SignUp());
  }

  void _goToLogIn() {
    navigation.push(LogIn());
  }

  void _facebookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print('result.accessToken.token: ${result.accessToken.token}');
        _logInBloc.loginWithProvider(LogInWithProviderRequest(
          accessToken: result.accessToken.token,
          provider: LogInWithProviderRequest.facebook
        ));
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('FacebookLoginStatus.cancelledByUser');
        break;
      case FacebookLoginStatus.error:
        print('result.errorMessage: ${result.errorMessage}');
        break;
    }
  }

  void _onLoginSuccess() {
    Navigation(context).push(Base(), clearStack: true);
  }
}
