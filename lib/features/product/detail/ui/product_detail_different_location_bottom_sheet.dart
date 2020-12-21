import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart'
    as CustomTypography;
import 'package:giv_flutter/values/dimens.dart';

class ProductDetailDifferentLocationBottomSheet extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final VoidCallback onCanceledPressed;

  const ProductDetailDifferentLocationBottomSheet({
    Key key,
    @required this.onContinuePressed,
    @required this.onCanceledPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: BottomSheetColumn(children: [
          CustomTypography.Title(
            stringFunction('product_detail_different_location_alert_title'),
            textAlign: TextAlign.center,
          ),
          DefaultVerticalSpacing(),
          CustomTypography.BodyText(
            stringFunction('product_detail_different_location_alert_content'),
          ),
          DefaultVerticalSpacingAndAHalf(),
          DangerButton(
            text: stringFunction(
                'product_detail_different_location_alert_continue_button'),
            onPressed: onContinuePressed,
          ),
          DefaultVerticalSpacing(),
          MediumFlatPrimaryButton(
            text: stringFunction(
                'product_detail_different_location_alert_cancel_button'),
            onPressed: onCanceledPressed,
          ),
        ]),
      ),
    );
  }
}
