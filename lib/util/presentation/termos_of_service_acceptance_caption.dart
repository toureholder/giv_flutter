import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/util/util.dart';

class TermsOfServiceAcceptanceCaption extends StatefulWidget {
  final String prefix;

  const TermsOfServiceAcceptanceCaption({Key key, this.prefix})
      : super(key: key);

  @override
  _TermsOfServiceAcceptanceCaptionState createState() =>
      _TermsOfServiceAcceptanceCaptionState();
}

class _TermsOfServiceAcceptanceCaptionState
    extends BaseState<TermsOfServiceAcceptanceCaption> {
  String _prefix;

  @override
  void initState() {
    super.initState();
    _prefix = widget.prefix ?? 'terms_acceptance_caption_by_continuing_';
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
              style: new TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Util.launchPrivacyURL();
                },
            ),
            new TextSpan(
              text: string('terms_acceptance_caption_and_the_'),
              style: new TextStyle(color: Colors.grey),
            ),
            new TextSpan(
              text: string('terms_acceptance_caption_termos'),
              style: new TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Util.launchTermsURL();
                },
            ),
            new TextSpan(
              text: '.',
              style: new TextStyle(color: Colors.grey),
            )
          ],
        ));
  }
}
