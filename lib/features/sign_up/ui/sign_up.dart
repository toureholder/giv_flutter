import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/log_in/helper/login_assistance_helper.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/log_in/ui/login_assistance.dart';
import 'package:giv_flutter/features/sign_in/ui/mailbox_image.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in_full_page_message.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/util/form/custom_text_form_field.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/form/password_form_field.dart';
import 'package:giv_flutter/util/form/validator.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends BaseState<SignUp> {
  SignUpBloc _signUpBloc;
  var _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Validator _validate;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc();
    _signUpBloc.responseStream.listen((HttpResponse<ApiResponse> httpResponse) {
      if (httpResponse.isReady) _onSignUpResponse(httpResponse);
    });
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _validate = Validator(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('sign_in_sign_up'),
      ),
      body: StreamBuilder(
          stream: _signUpBloc.responseStream,
          builder:
              (context, AsyncSnapshot<HttpResponse<ApiResponse>> snapshot) {
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
        CustomTextFormField(
          labelText: string('sign_in_form_name'),
          validator: _validate.userName,
          enabled: !isLoading,
          focusNode: _nameFocus,
          nextFocus: _emailFocus,
          controller: _nameController,
          maxLength: Config.maxLengthName,
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        EmailFormField(
          enabled: !isLoading,
          focusNode: _emailFocus,
          nextFocus: _passwordFocus,
          controller: _emailController,
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        PasswordFormField(
          labelText: string('sign_in_form_password'),
          validator: _validate.password,
          enabled: !isLoading,
          focusNode: _passwordFocus,
          controller: _passwordController,
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        PrimaryButton(
          text: string('sign_in_sign_up'),
          isLoading: isLoading,
          onPressed: _handleSubmit,
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        TextFlatButton(
          text: string('log_in_help_me'),
          onPressed: _requestHelp,
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        GestureDetector(
          onTap: _goToLogin,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Body2Text(string('sign_in_already_have_an_acount')),
              MediumFlatPrimaryButton(
                text: string('sign_in_log_in'),
                onPressed: _goToLogin,
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
      _signUpBloc.signUp(SignUpRequest(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          localeString: localeString));
    }
  }

  void _onSignUpResponse(HttpResponse<ApiResponse> httpResponse) {
    switch (httpResponse.status) {
      case HttpStatus.created:
        _onSignUpResponseSuccess();
        break;
      case HttpStatus.conflict:
        showEmailTakenDialog();
        break;
      default:
        showGenericErrorDialog();
    }
  }

  void _onSignUpResponseSuccess() {
    Navigation(context).pushReplacement(SignInFullPageMessage(
      heroWidget: MailboxImage(),
      title: string('sign_in_verify_email_title'),
      message: string('sign_in_verify_email_message'),
      buttonText: string('common_ok'),
    ));
  }

  void _goToLogin() {
    navigation.pushReplacement(LogIn());
  }

  void _requestHelp() {
    handleCustomerServiceRequest(string('sign_up_help_me_chat_message'));
  }

  void showEmailTakenDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(string('sign_up_error_409_title')),
            content: Text(string('sign_up_error_409_messge')),
            actions: <Widget>[
              FlatButton(
                  child: Text(string('sign_up_error_409_recover_email_button')),
                  onPressed: () {
                    Navigation(context).pop();
                    navigation.push(LoginAssistance(
                      page: LoginAssistanceHelper(context).forgotPassword(),
                      email: _emailController.text,
                    ));
                  }),
              FlatButton(
                  child: Text(string('common_ok')),
                  onPressed: () {
                    Navigation(context).pop();
                  })
            ],
          );
        });
  }
}
