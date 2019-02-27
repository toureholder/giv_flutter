import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/util/util.dart';

class TermsOfServiceAcceptanceCaption extends StatefulWidget {
  final TextAlign textAlign;

  const TermsOfServiceAcceptanceCaption({Key key, this.textAlign})
      : super(key: key);

  @override
  _TermsOfServiceAcceptanceCaptionState createState() =>
      _TermsOfServiceAcceptanceCaptionState();
}

class _TermsOfServiceAcceptanceCaptionState
    extends BaseState<TermsOfServiceAcceptanceCaption> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _textSpan();
  }

  _textSpan() {
    return RichText(
        textAlign: widget.textAlign,
        text: TextSpan(
          children: [
            new TextSpan(
              text: string('terms_acceptance_caption_by_signing_in_'),
              style: new TextStyle(color: Colors.grey),
            ),
            new TextSpan(
              text: string('terms_acceptance_caption_termos'),
              style: new TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Util.launchURL('https://policies.google.com/terms?hl=pt',
                      forceWebView: true);
                },
            ),
            new TextSpan(
              text: string('terms_acceptance_caption_and_'),
              style: new TextStyle(color: Colors.grey),
            ),
            new TextSpan(
              text: string('terms_acceptance_caption_privacy'),
              style: new TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Util.launchURL('https://policies.google.com/terms?hl=pt',
                      forceWebView: true);
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