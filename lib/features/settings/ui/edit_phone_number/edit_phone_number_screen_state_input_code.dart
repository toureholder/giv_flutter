import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/shared/change_number_button.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EditPhoneNumberScreenStateInputCode extends StatelessWidget {
  final String phoneNumber;
  final Function onChangedNumberButtonTapped;
  final Function onRendCodeButtonTapped;
  final Function onInputCompleted;
  final bool autoRetrievalFailed;

  const EditPhoneNumberScreenStateInputCode({
    Key key,
    @required this.phoneNumber,
    @required this.onChangedNumberButtonTapped,
    @required this.onRendCodeButtonTapped,
    @required this.onInputCompleted,
    this.autoRetrievalFailed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    final message = autoRetrievalFailed
        ? 'settings_edit_phone_number_input_code_message_auto_retrieval_failed'
        : 'settings_edit_phone_number_input_code_message';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        H6Text(stringFunction('settings_edit_phone_number_input_code_title')),
        DefaultVerticalSpacing(),
        Body2Text(
          stringFunction(
            message,
            formatArg: phoneNumber,
          ),
          color: CustomColors.lighterTextColor,
        ),
        DefaultVerticalSpacingAndAHalf(),
        VerificationCodeInput(onCompleted: onInputCompleted),
        DefaultVerticalSpacingAndAHalf(),
        ChangedNumberButton(onTap: onChangedNumberButtonTapped),
        DefaultVerticalSpacing(),
        ResendCodeButton(onTap: onRendCodeButtonTapped)
      ],
    );
  }
}

class VerificationCodeInput extends StatelessWidget {
  final Function onCompleted;

  const VerificationCodeInput({
    Key key,
    @required this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        animationType: AnimationType.none,
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            activeColor: Theme.of(context).primaryColor,
            activeFillColor: Colors.transparent,
            selectedColor: Colors.grey,
            selectedFillColor: Colors.transparent,
            inactiveColor: Colors.grey[300],
            inactiveFillColor: Colors.transparent,
            fieldHeight: 50,
            fieldWidth: 40),
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        controller: TextEditingController(),
        onCompleted: onCompleted,
        onChanged: (value) {
          // no-op
        },
        beforeTextPaste: (text) {
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }
}

class ResendCodeButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const ResendCodeButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 6.0, right: 6.0, bottom: 6.0),
        color: Colors.transparent,
        child: Body2Text(
          stringFunction(
            'settings_edit_phone_number_input_code_screen_resend_code_button',
          ),
          color: CustomColors.textLinkColor,
        ),
      ),
    );
  }
}
