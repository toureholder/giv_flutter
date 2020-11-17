import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';

class MyGroupsJoinGroupCTA extends StatelessWidget {
  final VoidCallback onPressed;

  const MyGroupsJoinGroupCTA({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = GetLocalizedStringFunction(context)(
      'my_groups_join_group_cta',
    );

    return GreyOutlineIconButton(
      onPressed: onPressed,
      text: text,
      isFlexible: true,
      iconData: Icons.group_add,
    );
  }
}
