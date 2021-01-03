import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart'
    as CustomTypography;
import 'package:giv_flutter/values/dimens.dart';

class CreateCancellationIntentScreen extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCancelPressed;
  final VoidCallback onContinuePressed;

  const CreateCancellationIntentScreen({
    Key key,
    this.isLoading = false,
    this.onCancelPressed,
    this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTypography.BodyText(
              stringFunction('create_cancellation_intent_paragraph_1'),
            ),
            DefaultVerticalSpacing(),
            CustomTypography.BodyText(
              stringFunction('create_cancellation_intent_paragraph_2'),
              weight: CustomTypography.SyntheticFontWeight.bold,
            ),
            DefaultVerticalSpacing(),
            CustomTypography.BodyText(
              stringFunction('create_cancellation_intent_paragraph_3'),
            ),
            DefaultVerticalSpacingAndAHalf(),
            DangerButton(
              text: stringFunction(
                  'create_cancellation_intent_confirmation_button'),
              isLoading: isLoading,
              onPressed: onContinuePressed,
            ),
            DefaultVerticalSpacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumFlatPrimaryButton(
                  text: stringFunction(
                      'create_cancellation_intent_cancel_button'),
                  onPressed: onCancelPressed,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
