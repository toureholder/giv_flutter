import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';

class GroupInformationDescription extends StatelessWidget {
  final String description;

  const GroupInformationDescription({
    Key key,
    @required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = description;
    Color color;

    if (description == null || description.isEmpty) {
      text = GetLocalizedStringFunction(context)(
          'edit_group_information_description_empty_state');

      color = CustomColors.emptyStateTextColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.default_horizontal_margin,
      ),
      child: BodyText(
        text,
        color: color,
      ),
    );
  }
}
