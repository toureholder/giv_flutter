import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditPhoneNumberStateInputPhoneNumber extends StatelessWidget {
  const EditPhoneNumberStateInputPhoneNumber({
    Key key,
    @required this.selectedCode,
    @required this.defaultCode,
    @required this.controller,
    @required this.onCountryCodeChanged,
    @required this.startPhoneVerification,
    @required this.isSendingCode,
    this.listingType,
  }) : super(key: key);

  final String selectedCode;
  final String defaultCode;
  final TextEditingController controller;
  final Function onCountryCodeChanged;
  final Function startPhoneVerification;
  final bool isSendingCode;
  final ListingType listingType;

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          H6Text(
            stringFunction(
              'settings_edit_phone_number_input_number_title',
            ),
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          Body2Text(
            stringFunction('settings_edit_phone_number_hint'),
            color: CustomColors.lighterTextColor,
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          Row(
            children: <Widget>[
              CountryCodePicker(
                onChanged: onCountryCodeChanged,
                initialSelection: '+$selectedCode',
                favorite: ['+$defaultCode'],
              ),
              Spacing.horizontal(4.0),
              Flexible(
                child: EditPhoneNumberFormField(
                  controller: controller,
                ),
              )
            ],
          ),
          Spacing.vertical(Dimens.double_default_margin),
          EditPhoneNumberVerifyButton(
            onPressed: startPhoneVerification,
            isLoading: isSendingCode,
            listingType: listingType,
          )
        ],
      ),
    );
  }
}

class EditPhoneNumberFormField extends StatelessWidget {
  const EditPhoneNumberFormField({
    Key key,
    @required TextEditingController controller,
    this.enabled = true,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: stringFunction('settings_phone_number_edit_text_hint'),
      ),
      autofocus: true,
      enabled: enabled,
    );
  }
}

class EditPhoneNumberVerifyButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final ListingType listingType;

  const EditPhoneNumberVerifyButton({
    Key key,
    @required this.onPressed,
    @required this.isLoading,
    @required this.listingType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = GetLocalizedStringFunction(context)(
      'settings_edit_phone_verify_button',
    );

    return listingType == ListingType.donationRequest
        ? AccentButton(
            text: text,
            onPressed: onPressed,
            isLoading: isLoading,
          )
        : PrimaryButton(
            text: text,
            onPressed: onPressed,
            isLoading: isLoading,
          );
  }
}
