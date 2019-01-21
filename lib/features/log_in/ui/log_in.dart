import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/user/log_in_request.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/form/password_form_field.dart';
import 'package:giv_flutter/util/form/validator.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class LogIn extends StatefulWidget {
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
    _logInBloc = LogInBloc();
    _logInBloc.responseStream.listen((StreamEvent<LogInResponse> event) {
      if (event.isReady) _onLoginSuccess();
    });
  }

  @override
  void dispose() {
    _logInBloc.dispose();
    super.dispose();
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
          stream: _logInBloc.responseStream,
          builder:
              (context, AsyncSnapshot<StreamEvent<LogInResponse>> snapshot) {
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
          child: _buildFormUI(isLoading),
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
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Body2Text(string('sign_in_dont_have_an_account')),
              MediumFlatPrimaryButton(
                text: string('sign_in_sign_up'),
                onPressed: () {
                  navigation.pushReplacement(SignUp());
                },
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
          email: _emailController.text,
          password: _passwordController.text
      ));
    }
  }

  void _onLoginSuccess() {
    Navigation(context).push(Base(), clearStack: true);
  }
}
