import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:giv_flutter/values/colors.dart';

class TermsOfServiceAcceptanceCaption extends StatefulWidget {
  final String prefix;
  final Util util;

  const TermsOfServiceAcceptanceCaption({
    Key key,
    @required this.util,
    this.prefix,
  }) : super(key: key);

  @override
  _TermsOfServiceAcceptanceCaptionState createState() =>
      _TermsOfServiceAcceptanceCaptionState();
}

class _TermsOfServiceAcceptanceCaptionState
    extends BaseState<TermsOfServiceAcceptanceCaption> {
  String _prefix;
  Util _util;

  @override
  void initState() {
    super.initState();
    _prefix = widget.prefix ?? 'terms_acceptance_caption_by_continuing_';
    _util = widget.util;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _textSpan();
  }

  _textSpan() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          new TextSpan(
            text: string(_prefix),
            style: new TextStyle(color: Colors.grey),
          ),
          new TextSpan(
            text: string('terms_acceptance_caption_privacy'),
            style: new TextStyle(
              color: CustomColors.textLinkColor,
            ),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                _util.launchPrivacyURL();
              },
          ),
          new TextSpan(
            text: string('terms_acceptance_caption_and_the_'),
            style: new TextStyle(color: Colors.grey),
          ),
          new TextSpan(
            text: string('terms_acceptance_caption_termos'),
            style: new TextStyle(
              color: CustomColors.textLinkColor,
            ),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                _util.launchTermsURL();
              },
          ),
          new TextSpan(
            text: '.',
            style: new TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
