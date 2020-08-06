import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class JoinGroupGetMoreInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return GestureDetector(
      onTap: () {
        _revealBottomSheet(context, stringFunction);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.info_outline, color: Colors.grey[400]),
          Spacing.horizontal(Dimens.grid(5)),
          Body2Text(
            stringFunction('join_group_screen_group_what_code_is_this_title'),
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  void _revealBottomSheet(
      BuildContext context, GetLocalizedStringFunction stringFunction) {
    InformationBottomSheet.show(context,
        title:
            stringFunction('join_group_screen_group_what_code_is_this_title'),
        text: stringFunction('join_group_screen_group_what_code_is_this_text'));
  }
}
