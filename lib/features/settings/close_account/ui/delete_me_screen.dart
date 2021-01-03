import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/form/custom_text_form_field.dart';
import 'package:giv_flutter/util/form/form_validator.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart'
    as CustomTypography;
import 'package:giv_flutter/values/dimens.dart';

class DeleteMeScreen extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onCancelPressed;
  final VoidCallback onContinuePressed;
  final String confirmationText;

  const DeleteMeScreen({
    Key key,
    this.isLoading = false,
    this.onCancelPressed,
    this.onContinuePressed,
    @required this.confirmationText,
  }) : super(key: key);

  @override
  _DeleteMeScreenState createState() => _DeleteMeScreenState();
}

class _DeleteMeScreenState extends BaseState<DeleteMeScreen> {
  TextEditingController _confirmationController = TextEditingController();
  bool _isConfirmationComplete;
  String _confirmationText;

  @override
  void initState() {
    super.initState();
    _isConfirmationComplete = false;
    _confirmationText = widget.confirmationText;
    _handleConfirmationTextChanges();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTypography.BodyText(
              string(
                'delete_me_confirmation_text',
                formatArg: _confirmationText,
              ),
            ),
            DefaultVerticalSpacing(),
            CustomTextFormField(
              controller: _confirmationController,
              validator: (String input) => string(
                FormValidator().required(input),
              ),
            ),
            DefaultVerticalSpacing(),
            DangerButton(
              text: string('delete_me_confirmation_button'),
              isLoading: widget.isLoading,
              onPressed:
                  _isConfirmationComplete ? widget.onContinuePressed : null,
            ),
            DefaultVerticalSpacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumFlatPrimaryButton(
                  text: string('delete_me_cancel_button'),
                  onPressed: widget.onCancelPressed,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleConfirmationTextChanges() {
    _confirmationController.addListener(() {
      setState(() {
        _isConfirmationComplete =
            _confirmationController.text == _confirmationText;
      });
    });
  }
}
