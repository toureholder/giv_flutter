import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/groups/create_group/bloc/create_group_bloc.dart';
import 'package:giv_flutter/features/groups/create_group/ui/create_group_sceen.dart';
import 'package:giv_flutter/features/groups/join_group/bloc/join_group_bloc.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_screen.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_create_group_cta.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

import 'my_groups_join_group_cta.dart';

class MyGroupsScreenHeader extends StatefulWidget {
  @override
  _MyGroupsScreenHeaderState createState() => _MyGroupsScreenHeaderState();
}

class _MyGroupsScreenHeaderState extends BaseState<MyGroupsScreenHeader> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: EdgeInsets.all(
        Dimens.default_horizontal_margin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyGroupsCreateGroupCTA(
            onPressed: _navigateToCreateGroup,
          ),
          DefaultVerticalSpacing(),
          MyGroupsJoinGroupCTA(
            onPressed: _navigateToJoinGroup,
          ),
        ],
      ),
    );
  }

  void _navigateToCreateGroup() => navigation.push(Consumer<CreateGroupBloc>(
        builder: (context, bloc, child) => CreateGroupScreen(bloc: bloc),
      ));

  void _navigateToJoinGroup() => navigation.push(Consumer<JoinGroupBloc>(
        builder: (context, bloc, child) => JoinGroupScreen(bloc: bloc),
      ));
}
