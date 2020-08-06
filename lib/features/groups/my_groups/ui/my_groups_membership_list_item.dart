import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/features/groups/group_detail/bloc/group_detail_bloc.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_screen.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class MembershipListItem extends StatelessWidget {
  const MembershipListItem({
    Key key,
    @required this.membership,
  }) : super(key: key);

  final GroupMembership membership;

  @override
  Widget build(BuildContext context) {
    final group = membership.group;

    final titleText = Text(
      group.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      child: titleText,
    );
    Widget subTitle;

    if (group.description != null) {
      title = titleText;

      subTitle = Text(
        group.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return ListTile(
      leading: RoundedCorners(
        child: MembershipListItemImage(
          group: group,
        ),
      ),
      title: title,
      subtitle: subTitle,
      onTap: () {
        _navigateToGroupDetail(
          context: context,
          membership: membership,
        );
      },
    );
  }

  void _navigateToGroupDetail({
    @required BuildContext context,
    @required GroupMembership membership,
  }) =>
      Navigation(context).push(Consumer<GroupDetailBloc>(
        builder: (context, bloc, child) => GroupDetailScreen(
          bloc: bloc,
          membershipId: membership.id,
        ),
      ));
}

class MembershipListItemImage extends StatelessWidget {
  final Group group;

  const MembershipListItemImage({
    Key key,
    @required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = group.imageUrl ?? group.randomImageUrl;
    return CachedNetworkImage(
      placeholder: (context, url) => MembershipListItemImagePlaceHolder(),
      fit: BoxFit.cover,
      width: Dimens.grid(45),
      imageUrl: url,
    );
  }
}

class MembershipListItemImagePlaceHolder extends StatelessWidget {
  const MembershipListItemImagePlaceHolder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.grid(45),
      decoration: BoxDecoration(
        color: CustomColors.random(),
      ),
    );
  }
}
