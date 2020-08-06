import 'package:flutter/material.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_membership_list_item.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen_header.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_subtitle.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';

class MyGroupsScreenListView extends StatelessWidget {
  final List<GroupMembership> memberships;

  const MyGroupsScreenListView({
    Key key,
    @required this.memberships,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      MyGroupsScreenHeader(),
    ];

    if (memberships.length > 0) {
      widgets.addAll([
        CustomDivider(),
        DefaultVerticalSpacing(),
        MyGroupsSubTitle(),
      ]);

      for (var memberhsip in memberships) {
        widgets.addAll([
          MembershipListItem(
            membership: memberhsip,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.default_horizontal_margin,
              vertical: Dimens.grid(2),
            ),
            child: CustomDivider(),
          ),
        ]);
      }
    }

    return ListView(
      children: widgets,
    );
  }
}
