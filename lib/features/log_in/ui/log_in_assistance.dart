import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/mailbox_image.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in_full_page_message.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/util/form/form_validator.dart';
import 'package:giv_flutter/util/form/text_editing_controller_builder.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class LoginAssistance extends StatefulWidget {
  final LoginAssistancePage page;
  final String email;
  final LogInBloc bloc;

  const LoginAssistance({
    Key key,
    @required this.bloc,
    @required this.page,
    this.email,
  }) : super(key: key);

  @override
  _LoginAssistanceState createState() => _LoginAssistanceState();
}

class _LoginAssistanceState extends BaseState<LoginAssistance> {
  LogInBloc _logInBloc;
  var _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  TextEditingController _emailController;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  Map<LoginAssistanceType, Map<LoginAssistanceFunction, Function>> _functionMap;

  @override
  void initState() {
    super.initState();
    _logInBloc = widget.bloc;
    _initFunctionMap();
    _listenToResponseStream();

    _emailController =
        TextEditingControllerBuilder().setInitialText(widget.email).build();
  }

  _listenToResponseStream() {
    _logInBloc.loginAssistanceStream
        ?.listen((HttpResponse<ApiResponse> response) {
      if (response.isReady) _handleResponse(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder(
          stream: _logInBloc.loginAssistanceStream,
          builder: (context, snapshot) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(
          widget.page.title,
          weight: SyntheticFontWeight.semiBold,
        ),
        Spacing.vertical(
          Dimens.default_vertical_margin,
        ),
        Body2Text(
          widget.page.instructions,
          color: Colors.grey,
        ),
        Spacing.vertical(
          Dimens.default_vertical_margin,
        ),
        EmailFormField(
          enabled: !isLoading,
          focusNode: _emailFocus,
          controller: _emailController,
          validator: (String input) => string(
            FormValidator().email(input),
          ),
        ),
        Spacing.vertical(
          Dimens.sign_in_submit_button_margin_top,
        ),
        SubmitButton(
          isLoading: isLoading,
          onPressed: _handleSubmit,
        )
      ],
    );
  }

  _handleSubmit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    var function =
        _functionMap[widget.page.type][LoginAssistanceFunction.submit];

    if (_formKey.currentState.validate()) {
      function(LoginAssistanceRequest(email: _emailController.text));
    }
  }

  _initFunctionMap() {
    _functionMap = {
      LoginAssistanceType.forgotPassword: {
        LoginAssistanceFunction.submit: _logInBloc.forgotPassword,
        LoginAssistanceFunction.errorHandler: _handleForgotPasswordError
      },
      LoginAssistanceType.resendActivation: {
        LoginAssistanceFunction.submit: _logInBloc.resendActivation,
        LoginAssistanceFunction.errorHandler: _handleResendActivationError
      }
    };
  }

  _handleResponse(HttpResponse<ApiResponse> response) {
    if (response.status == HttpStatus.ok) {
      _onSubmitSuccess();
      return;
    }

    var errorHandler =
        _functionMap[widget.page.type][LoginAssistanceFunction.errorHandler];
    errorHandler(response);
  }

  _handleForgotPasswordError(HttpResponse<ApiResponse> response) {
    switch (response.status) {
      case HttpStatus.notFound:
        _showNotFoundDialog();
        break;
      default:
        showGenericErrorDialog();
    }
  }

  _handleResendActivationError(HttpResponse<ApiResponse> response) {
    switch (response.status) {
      case HttpStatus.notAcceptable:
        showInformationDialog(
            title: string('resend_activation_error_already_activated_title'),
            content:
                string('resend_activation_error_already_activated_message'));
        break;
      case HttpStatus.notFound:
        _showNotFoundDialog();
        break;
      default:
        showGenericErrorDialog();
    }
  }

  _showNotFoundDialog() {
    showInformationDialog(
        title: string('login_assistance_email_not_found_title'),
        content: string('login_assistance_email_not_found_message'));
  }

  _onSubmitSuccess() {
    Navigation(context).pushReplacement(SignInFullPageMessage(
      heroWidget: MailboxImage(),
      title: widget.page.successTitle,
      message: widget.page.successMessage,
      buttonText: string('common_ok'),
    ));
  }
}

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitButton({
    Key key,
    this.isLoading,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: GetLocalizedStringFunction(context)('common_send'),
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}

enum LoginAssistanceType { forgotPassword, resendActivation }

enum LoginAssistanceFunction { submit, errorHandler }

class LoginAssistancePage {
  final LoginAssistanceType type;
  final String title;
  final String instructions;
  final String successTitle;
  final String successMessage;

  LoginAssistancePage(
      {@required this.successTitle,
      @required this.successMessage,
      @required this.type,
      @required this.title,
      @required this.instructions});

  factory LoginAssistancePage.fake(LoginAssistanceType type) =>
      LoginAssistancePage(
        successTitle: 'fake success title',
        successMessage: 'fake success message',
        type: type,
        title: 'fake title',
        instructions: 'fake instructions',
      );
}
