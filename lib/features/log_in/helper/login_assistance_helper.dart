import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/log_in/ui/log_in_assistance.dart';

class LoginAssistanceHelper {
  BuildContext context;
  GetLocalizedStringFunction string;

  LoginAssistanceHelper(BuildContext context) {
    this.context = context;
    this.string = GetLocalizedStringFunction(context);
  }

  LoginAssistancePage forgotPassword() {
    return LoginAssistancePage(
        type: LoginAssistanceType.forgotPassword,
        title: string('log_in_forgot_password'),
        instructions: string('log_in_forgot_password_instructions'),
        successTitle: string('forgot_password_success_title'),
        successMessage: string('forgot_password_success_message'));
  }

  LoginAssistancePage resendActivation() {
    return LoginAssistancePage(
        type: LoginAssistanceType.resendActivation,
        title: string('log_in_didnt_get_verification_email'),
        instructions:
            string('log_in_didnt_get_verification_email_instructions'),
        successTitle: string('sign_in_verify_email_title'),
        successMessage: string('sign_in_verify_email_message'));
  }
}
