import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/helper/login_assistance_helper.dart';
import 'package:giv_flutter/features/log_in/ui/login_assistance.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/form/password_form_field.dart';
import 'package:giv_flutter/util/form/validator.dart';
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

  const LogIn({Key key, this.bloc, this.redirect}) : super(key: key);

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
  Validator _validate;
  bool _autovalidate = false;

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

    _validate = Validator(context);

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
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        PasswordFormField(
          labelText: string('sign_in_form_password'),
          validator: _validate.required,
          enabled: !isLoading,
          focusNode: _passwordFocus,
          controller: _passwordController,
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        PrimaryButton(
          text: string('sign_in_log_in'),
          isLoading: isLoading,
          onPressed: _handleSubmit,
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        TextFlatButton(
          text: string('log_in_forgot_password'),
          onPressed: _goToForgotPassword,
        ),
        TextFlatButton(
          text: string('log_in_didnt_get_verification_email'),
          onPressed: _goToResendActivation,
        ),
        TextFlatButton(
          text: string('log_in_help_me'),
          onPressed: _requestHelp,
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        GestureDetector(
          onTap: _goToSignUp,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Body2Text(string('sign_in_dont_have_an_account')),
              MediumFlatPrimaryButton(
                text: string('sign_in_sign_up'),
                onPressed: _goToSignUp,
              )
            ],
          ),
        )
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
      builder: (context, bloc, child) => SignUp(bloc: bloc,),
    ));
  }

  void _requestHelp() {
    handleCustomerServiceRequest(string('log_in_help_me_chat_message'));
  }
}
