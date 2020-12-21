import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart'
    as CustomTypography;

class LocationFilterHelp extends StatelessWidget {
  final String text;

  const LocationFilterHelp({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    final finalText =
        text ?? stringFunction('location_filter_help_text_default');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LocationFilterHelpImage(),
          DefaultVerticalSpacing(),
          DefaultVerticalSpacing(),
          CustomTypography.Title(
            stringFunction('location_filter_help_text_title'),
          ),
          DefaultVerticalSpacing(),
          CustomTypography.BodyText(
            finalText,
            textAlign: TextAlign.center,
          ),
          DefaultVerticalSpacing(),
        ],
      ),
    );
  }
}

class LocationFilterHelpImage extends StatelessWidget {
  const LocationFilterHelpImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'images/undraw_my_location.svg',
        height: 156.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
