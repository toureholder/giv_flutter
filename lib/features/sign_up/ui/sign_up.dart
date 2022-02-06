import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/helper/login_assistance_helper.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/log_in/ui/log_in_assistance.dart';
import 'package:giv_flutter/features/sign_in/ui/mailbox_image.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in_full_page_message.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/util/form/custom_text_form_field.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/form/form_validator.dart';
import 'package:giv_flutter/util/form/password_form_field.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final SignUpBloc bloc;

  const SignUp({Key key, @required this.bloc}) : super(key: key);

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
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  FormValidator _formValidator = FormValidator();

  @override
  void initState() {
    super.initState();
    _signUpBloc = widget.bloc;
    _signUpBloc.responseStream
        ?.listen((HttpResponse<ApiResponse> httpResponse) {
      if (httpResponse.isReady) _onSignUpResponse(httpResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          autovalidateMode: _autovalidateMode,
          child: AndroidTheme(child: _buildFormUI(isLoading)),
        ),
      ),
    );
  }

  Widget _buildFormUI(bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NameFormField(
          validator: (String input) => string(_formValidator.userName(input)),
          enabled: !isLoading,
          focusNode: _nameFocus,
          nextFocus: _emailFocus,
          controller: _nameController,
          maxLength: Config.maxLengthName,
        ),
        Spacing.vertical(
          Dimens.default_vertical_margin,
        ),
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
          validator: (String input) => string(_formValidator.password(input)),
          enabled: !isLoading,
          focusNode: _passwordFocus,
          controller: _passwordController,
        ),
        Spacing.vertical(
          Dimens.sign_in_submit_button_margin_top,
        ),
        SubmitSignUpButton(
          isLoading: isLoading,
          onPressed: _handleSubmit,
        ),
        Spacing.vertical(
          Dimens.default_vertical_margin,
        ),
        SignUpHelpButton(
          onPressed: _requestHelp,
        ),
        Spacing.vertical(
          Dimens.sign_in_submit_button_margin_top,
        ),
        SignUpAlreadyHaveAnAccountWidget(
          onPressed: _goToLogin,
        ),
      ],
    );
  }

  void _handleSubmit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
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
    navigation.pushReplacement(Consumer<LogInBloc>(
      builder: (context, bloc, child) => LogIn(
        bloc: bloc,
      ),
    ));
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
              TextButton(
                  child: Text(string('sign_up_error_409_recover_email_button')),
                  onPressed: () {
                    Navigation(context).pop();
                    navigation.push(Consumer<LogInBloc>(
                      builder: (context, bloc, child) => LoginAssistance(
                        bloc: bloc,
                        page: LoginAssistanceHelper(context).forgotPassword(),
                        email: _emailController.text,
                      ),
                    ));
                  }),
              TextButton(
                  child: Text(string('common_ok')),
                  onPressed: () {
                    Navigation(context).pop();
                  })
            ],
          );
        });
  }
}

class NameFormField extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final bool enabled;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLength;

  const NameFormField({
    Key key,
    this.validator,
    this.enabled,
    this.focusNode,
    this.nextFocus,
    this.textInputAction,
    this.controller,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: GetLocalizedStringFunction(context)('sign_in_form_name'),
      validator: validator,
      enabled: enabled,
      focusNode: focusNode,
      nextFocus: nextFocus,
      controller: controller,
      maxLength: maxLength,
    );
  }
}

class SubmitSignUpButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitSignUpButton({
    Key key,
    this.isLoading,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: GetLocalizedStringFunction(context)('sign_in_sign_up'),
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}

class SignUpHelpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignUpHelpButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFlatButton(
      text: GetLocalizedStringFunction(context)('sign_up_help_me'),
      onPressed: onPressed,
    );
  }
}

class SignUpAlreadyHaveAnAccountWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const SignUpAlreadyHaveAnAccountWidget({
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
          Body2Text(string('sign_in_already_have_an_acount')),
          MediumFlatPrimaryButton(
            text: string('sign_in_log_in'),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
