import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/logo_text.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/termos_of_service_acceptance_caption.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Widget redirect;
  final LogInBloc bloc;

  const SignIn({Key key, @required this.bloc, this.redirect}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends BaseState<SignIn> {
  LogInBloc _logInBloc;

  @override
  void initState() {
    super.initState();
    _logInBloc = widget.bloc;
    _logInBloc.loginResponseStream
        .listen((HttpResponse<LogInResponse> httpResponse) {
      if (httpResponse.isReady) onLoginResponse(httpResponse, widget.redirect);
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
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          body: StreamBuilder(
              stream: _logInBloc.loginResponseStream,
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
            child: Center(child: LogoText()),
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
          _buildLoginButton(isFacebookLoading),
          Spacing.vertical(32.0),
          TermsOfServiceAcceptanceCaption(
            prefix: 'terms_acceptance_caption_by_signing_in_',
          )
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
    navigation.push(Consumer<SignUpBloc>(
      builder: (context, bloc, child) => SignUp(bloc: bloc,),
    ));
  }

  void _goToLogIn() {
    navigation.pushReplacement(Consumer<LogInBloc>(
      builder: (context, bloc, child) => LogIn(
        bloc: bloc,
        redirect: widget.redirect,
      ),
    ));
  }

  void _facebookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print('result.accessToken.token: ${result.accessToken.token}');
        _logInBloc.loginWithProvider(LogInWithProviderRequest(
            accessToken: result.accessToken.token,
            provider: LogInWithProviderRequest.facebook,
            localeString: localeString));
        break;
      case FacebookLoginStatus.cancelledByUser:
        showInformationDialog(
            content: string('facebook_login_cancelled_message'));
        break;
      case FacebookLoginStatus.error:
        String content = string('facebook_login_error_message');
        String message = result.errorMessage;
        showGenericErrorDialog(content: content, message: message);
        break;
    }
  }
}
