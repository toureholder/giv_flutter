import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;

class GroupInformationMemberTile extends StatelessWidget {
  const GroupInformationMemberTile({
    Key key,
    @required this.membership,
  }) : super(key: key);

  final GroupMembership membership;

  @override
  Widget build(BuildContext context) {
    final user = membership.user;
    final trailing =
        membership.isAdmin ? GroupInformationMemberTileAdminLabel() : null;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: Dimens.grid(2)),
        child: AvatarImage(image: CustomImage.Image(url: user.avatarUrl)),
      ),
      title: Text(user.name),
      trailing: trailing,
    );
  }
}

class GroupInformationMemberTileAdminLabel extends StatelessWidget {
  const GroupInformationMemberTileAdminLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(Dimens.button_border_radius)),
      child: Caption(
        stringFunction('group_information_member_tile_admin_label'),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
