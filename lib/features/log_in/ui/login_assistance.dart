import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/mailbox_image.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in_full_page_message.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
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

  const LoginAssistance({Key key, @required this.page, this.email})
      : super(key: key);

  @override
  _LoginAssistanceState createState() => _LoginAssistanceState();
}

class _LoginAssistanceState extends BaseState<LoginAssistance> {
  LogInBloc _logInBloc;
  var _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  TextEditingController _emailController;
  bool _autovalidate = false;
  Map<LoginAssistanceType, Map<LoginAssistanceFunction, Function>> _functionMap;

  @override
  void initState() {
    super.initState();
    _logInBloc = LogInBloc();
    _initFunctionMap();
    _listenToResponseStream();

    _emailController = widget.email == null
        ? TextEditingController()
        : TextEditingController.fromValue(
            new TextEditingValue(text: widget.email));
  }

  _listenToResponseStream() {
    _logInBloc.loginAssistanceStream
        .listen((HttpResponse<ApiResponse> response) {
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
          autovalidate: _autovalidate,
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
        Spacing.vertical(Dimens.default_vertical_margin),
        Body2Text(widget.page.instructions, color: Colors.grey),
        Spacing.vertical(Dimens.default_vertical_margin),
        EmailFormField(
          enabled: !isLoading,
          focusNode: _emailFocus,
          controller: _emailController,
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        PrimaryButton(
          text: string('common_send'),
          isLoading: isLoading,
          onPressed: _handleSubmit,
        )
      ],
    );
  }

  _handleSubmit() {
    setState(() {
      _autovalidate = true;
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
            content: string('resend_activation_error_already_activated_message'));
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
}
