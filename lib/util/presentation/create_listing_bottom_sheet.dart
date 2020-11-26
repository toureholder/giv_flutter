import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';

class CreateListingBottomSheet extends StatelessWidget {
  const CreateListingBottomSheet({
    Key key,
    @required this.onDonationButtonPressed,
    @required this.onDonationRequestButtonPressed,
  }) : super(key: key);

  final Null Function() onDonationButtonPressed;
  final Null Function() onDonationRequestButtonPressed;

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: BottomSheetColumn(
          children: [
            PrimaryButton(
              text: stringFunction('base_page_create_donation_action'),
              onPressed: onDonationButtonPressed,
            ),
            DefaultVerticalSpacing(),
            AccentButton(
              text: stringFunction('base_page_create_donation_request_action'),
              onPressed: onDonationRequestButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
