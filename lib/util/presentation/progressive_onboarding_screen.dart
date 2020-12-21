import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class ProgressiveOnboardingScreen extends StatefulWidget {
  final Widget child;
  final Function verifier;
  final Function setter;
  final String text;
  final String buttonText;
  final String imageAsset;

  const ProgressiveOnboardingScreen({
    Key key,
    @required this.child,
    @required this.verifier,
    @required this.setter,
    @required this.text,
    @required this.buttonText,
    @required this.imageAsset,
  }) : super(key: key);

  @override
  _ProgressiveOnboardingScreenState createState() =>
      _ProgressiveOnboardingScreenState();
}

class _ProgressiveOnboardingScreenState
    extends State<ProgressiveOnboardingScreen> {
  bool _show;

  @override
  void initState() {
    super.initState();

    _show = widget.verifier.call() == false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_show)
          Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.grid(20),
                horizontal: Dimens.grid(25),
              ),
              children: [
                GroupsIntroductionImage(
                  asset: widget.imageAsset,
                ),
                DefaultVerticalSpacingAndAHalf(),
                BodyText(
                  widget.text,
                  textAlign: TextAlign.center,
                ),
                DefaultVerticalSpacingAndAHalf(),
                PrimaryButton(
                  text: widget.buttonText ??
                      GetLocalizedStringFunction(context)(
                        'progressive_onboarding_ok_button',
                      ),
                  onPressed: () {
                    setState(() {
                      widget.setter.call();
                      _show = false;
                    });
                  },
                )
              ],
            ),
          ),
      ],
    );
  }
}

class GroupsIntroductionImage extends StatelessWidget {
  final String asset;

  const GroupsIntroductionImage({
    Key key,
    @required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.default_vertical_margin),
      child: Center(
        child: SvgPicture.asset(
          asset,
          height: 156.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
