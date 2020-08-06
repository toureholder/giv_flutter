import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';

class JoinGroupTryAgainButton extends StatelessWidget {
  final Function onPressed;

  const JoinGroupTryAgainButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return Container(
      child: PrimaryButton(
        text: stringFunction('shared_try_again'),
        fillWidth: false,
        onPressed: onPressed,
      ),
    );
  }
}
