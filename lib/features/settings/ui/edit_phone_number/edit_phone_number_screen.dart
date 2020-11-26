import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/phone_verification/bloc/phone_verification_bloc.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_automatic_code_retrieval.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_input_code.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_input_phone_number.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_resending_code.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_verification_in_progress.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_verification_success.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/form/text_editing_controller_builder.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/get_listing_type_color.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditPhoneNumber extends StatefulWidget {
  final User user;
  final SettingsBloc settingsBloc;
  final PhoneVerificationBloc phoneVerificationBloc;
  final ListingType listingType;

  const EditPhoneNumber({
    Key key,
    @required this.settingsBloc,
    @required this.phoneVerificationBloc,
    @required this.user,
    this.listingType,
  }) : super(key: key);

  @override
  _EditPhoneNumberState createState() => _EditPhoneNumberState();
}

class _EditPhoneNumberState extends BaseState<EditPhoneNumber> {
  TextEditingController _controller;
  SettingsBloc _settingsBloc;
  PhoneVerificationBloc _phoneVerificationBloc;
  String _defaultCode = Config.defaultCountryCallingCode;
  String _selectedCode;
  ListingType _listingType;

  @override
  void initState() {
    super.initState();
    _listingType = widget.listingType;
    _settingsBloc = widget.settingsBloc;
    _phoneVerificationBloc = widget.phoneVerificationBloc;

    _settingsBloc.userUpdateStream.listen((HttpResponse<User> httpResponse) {
      if (httpResponse.isReady) {
        onUpdateUserResponse(httpResponse);
      }
    });

    _phoneVerificationBloc.verificationStatusStream
        .listen(_handleVerificationStatusEvent);

    _controller = TextEditingControllerBuilder()
        .setInitialText(widget.user?.phoneNumber)
        .build();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('settings_phone_number'),
      ),
      body: _buildStreamBuilder(),
    );
  }

  StreamBuilder<PhoneVerificationStatus> _buildStreamBuilder() {
    return StreamBuilder(
        stream: _phoneVerificationBloc.verificationStatusStream,
        builder: (context, snapshot) {
          return AndroidTheme(
            primaryColor: getListingTypeColor(
              Theme.of(context),
              _listingType,
            ),
            child: _buildSingleChildScrollView(
              snapshot.data,
            ),
          );
        });
  }

  SingleChildScrollView _buildSingleChildScrollView(
      PhoneVerificationStatus verificationStatus) {
    _selectedCode = widget.user?.countryCallingCode ?? _defaultCode;

    Widget scrollViewChild;

    final inputCodeScreen = EditPhoneNumberScreenStateInputCode(
      phoneNumber: '+$_selectedCode ${_controller.text}',
      onChangedNumberButtonTapped: _onChangedNumberButtonTapped,
      onRendCodeButtonTapped: _resendCode,
      onInputCompleted: _validateCode,
    );

    switch (verificationStatus) {
      case PhoneVerificationStatus.sendingCode:
        scrollViewChild = EditPhoneNumberStateInputPhoneNumber(
          selectedCode: _selectedCode,
          defaultCode: _defaultCode,
          controller: _controller,
          onCountryCodeChanged: null,
          startPhoneVerification: null,
          isSendingCode: true,
          listingType: _listingType,
        );
        break;

      case PhoneVerificationStatus.codeSent:
        scrollViewChild = _settingsBloc.platform == TargetPlatform.android
            ? EditPhoneNumberScreenStateAutomaticCodeRetrieval(
                phoneNumber: '+$_selectedCode ${_controller.text}',
                onChangedNumberButtonTapped: _onChangedNumberButtonTapped,
                onManuallyEnterCodeButtonTapped:
                    _onManuallyEnterCodeButtonTapped,
              )
            : inputCodeScreen;
        break;

      case PhoneVerificationStatus.resendingCode:
        scrollViewChild = EditPhoneNumberScreenStateResendingCode();
        break;

      case PhoneVerificationStatus.codeAutoRetrievalTimeout:
        scrollViewChild = _settingsBloc.platform == TargetPlatform.android
            ? EditPhoneNumberScreenStateInputCode(
                phoneNumber: '+$_selectedCode ${_controller.text}',
                onChangedNumberButtonTapped: _onChangedNumberButtonTapped,
                onRendCodeButtonTapped: _resendCode,
                onInputCompleted: _validateCode,
                autoRetrievalFailed: true,
              )
            : inputCodeScreen;
        break;

      case PhoneVerificationStatus.verificationInProgress:
        scrollViewChild = EditPhoneNumberScreenStateVerificationInProgress();
        break;

      case PhoneVerificationStatus.verificationFailedInvalidCode:
        scrollViewChild = inputCodeScreen;
        break;

      case PhoneVerificationStatus.verificationFailedUnknownError:
        scrollViewChild = inputCodeScreen;
        break;

      case PhoneVerificationStatus.verificationCompleted:
        scrollViewChild = EditPhoneNumberScreenStateVerificationSuccess(
          onConfrimationButtonPressed: () {
            navigation.pop();
          },
        );
        break;

      default:
        scrollViewChild = EditPhoneNumberStateInputPhoneNumber(
          selectedCode: _selectedCode,
          defaultCode: _defaultCode,
          controller: _controller,
          onCountryCodeChanged: _onCountryChange,
          startPhoneVerification: _startPhoneVerification,
          isSendingCode: false,
          listingType: _listingType,
        );
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: scrollViewChild,
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    _selectedCode = countryCode.toString().substring(1);
  }

  void _startPhoneVerification() {
    if (_controller.text.isEmpty) return;

    _phoneVerificationBloc.verifyPhoneNumber(
      countryCode: _selectedCode,
      phoneNumber: _controller.text,
    );
  }

  void _onChangedNumberButtonTapped() {
    _phoneVerificationBloc.onChangedNumberButtonTapped();
  }

  void _onManuallyEnterCodeButtonTapped() {
    _phoneVerificationBloc.onManuallyEnterCodeButtonTapped();
  }

  void _resendCode() {
    _phoneVerificationBloc.resendCode();
  }

  void _validateCode(String input) {
    _phoneVerificationBloc.validateCode(input);
  }

  void _handleVerificationStatusEvent(PhoneVerificationStatus status) {
    switch (status) {
      case PhoneVerificationStatus.verificationFailedInvalidCode:
        showInformationDialog(
          title: string(
              'settings_edit_phone_number_verification_failed_invalid_code_dialog_title'),
          content: string(
            'settings_edit_phone_number_verification_failed_invalid_code_dialog_content',
          ),
        );
        break;

      case PhoneVerificationStatus.codeNotSentQuotaExceeded:
        showGenericErrorDialog(
          message:
              '${string('settings_edit_phone_number_code_not_sent_quota_dialog_message')} ${string('settings_edit_phone_number_code_not_sent_quota_dialog_content')}',
          content: string(
            'settings_edit_phone_number_code_not_sent_quota_dialog_content',
          ),
        );
        break;

      case PhoneVerificationStatus.codeNotSentUnknownError:
        showGenericErrorDialog();
        break;

      case PhoneVerificationStatus.verificationFailedUnknownError:
        showGenericErrorDialog();
        break;
      default:
        break;
    }
  }
}
