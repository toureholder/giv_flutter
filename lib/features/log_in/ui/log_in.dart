import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/helper/login_assistance_helper.dart';
import 'package:giv_flutter/features/log_in/ui/log_in_assistance.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/form/form_validator.dart';
import 'package:giv_flutter/util/form/password_form_field.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  final Widget redirect;
  final LogInBloc bloc;

  const LogIn({
    Key key,
    @required this.bloc,
    this.redirect,
  }) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends BaseState<LogIn> {
  LogInBloc _logInBloc;
  var _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _autovalidate = false;
  FormValidator _formValidator = FormValidator();

  @override
  void initState() {
    super.initState();
    _logInBloc = widget.bloc;
    _logInBloc.loginResponseStream
        ?.listen((HttpResponse<LogInResponse> httpResponse) {
      if (httpResponse.isReady) onLoginResponse(httpResponse, widget.redirect);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('sign_in_log_in'),
      ),
      body: StreamBuilder(
          stream: _logInBloc.loginResponseStream,
          builder:
              (context, AsyncSnapshot<HttpResponse<LogInResponse>> snapshot) {
            var isLoading = snapshot?.data?.isLoading ?? false;
            return _buildSingleChildScrollView(isLoading);
          }),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView(bool isLoading) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: AndroidTheme(child: _buildFormUI(isLoading)),
        ),
      ),
    );
  }

  Widget _buildFormUI(bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        EmailFormField(
          enabled: !isLoading,
          focusNode: _emailFocus,
          nextFocus: _passwordFocus,
          controller: _emailController,
          validator: (String input) => string(_formValidator.email(input)),
        ),
        Spacing.vertical(
          Dimens.default_vertical_margin,
        ),
        PasswordFormField(
          labelText: string('sign_in_form_password'),
          validator: (String input) => string(_formValidator.required(input)),
          enabled: !isLoading,
          focusNode: _passwordFocus,
          controller: _passwordController,
        ),
        Spacing.vertical(
          Dimens.sign_in_submit_button_margin_top,
        ),
        SubmitLogInButton(
          isLoading: isLoading,
          onPressed: _handleSubmit,
        ),
        Spacing.vertical(
          Dimens.default_vertical_margin,
        ),
        ForgotPasswordButton(
          onPressed: _goToForgotPassword,
        ),
        ResendEmailButton(
          onPressed: _goToResendActivation,
        ),
        LogInHelpButton(
          onPressed: _requestHelp,
        ),
        Spacing.vertical(
          Dimens.sign_in_submit_button_margin_top,
        ),
        LogInDontHaveAnAccountWidget(onPressed: _goToSignUp),
      ],
    );
  }

  void _handleSubmit() {
    setState(() {
      _autovalidate = true;
    });

    if (_formKey.currentState.validate()) {
      _logInBloc.login(LogInRequest(
          email: _emailController.text, password: _passwordController.text));
    }
  }

  void _goToForgotPassword() {
    navigation.push(Consumer<LogInBloc>(
      builder: (context, bloc, child) => LoginAssistance(
          bloc: bloc,
          page: LoginAssistanceHelper(context).forgotPassword(),
          email: _emailController.text),
    ));
  }

  void _goToResendActivation() {
    navigation.push(Consumer<LogInBloc>(
      builder: (context, bloc, child) => LoginAssistance(
          bloc: bloc,
          page: LoginAssistanceHelper(context).resendActivation(),
          email: _emailController.text),
    ));
  }

  void _goToSignUp() {
    navigation.pushReplacement(Consumer<SignUpBloc>(
      builder: (context, bloc, child) => SignUp(
        bloc: bloc,
      ),
    ));
  }

  void _requestHelp() {
    handleCustomerServiceRequest(string('log_in_help_me_chat_message'));
  }
}

class SubmitLogInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitLogInButton({
    Key key,
    this.isLoading,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: GetLocalizedStringFunction(context)('sign_in_log_in'),
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFlatButton(
      text: GetLocalizedStringFunction(context)('log_in_forgot_password'),
      onPressed: onPressed,
    );
  }
}

class ResendEmailButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResendEmailButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFlatButton(
      text: GetLocalizedStringFunction(context)(
          'log_in_didnt_get_verification_email'),
      onPressed: onPressed,
    );
  }
}

class LogInHelpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogInHelpButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFlatButton(
      text: GetLocalizedStringFunction(context)('log_in_help_me'),
      onPressed: onPressed,
    );
  }
}

class LogInDontHaveAnAccountWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const LogInDontHaveAnAccountWidget({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final string = GetLocalizedStringFunction(context);

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Body2Text(string('sign_in_dont_have_an_account')),
          MediumFlatPrimaryButton(
            text: string('sign_in_sign_up'),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
