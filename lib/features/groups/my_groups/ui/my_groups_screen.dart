import 'package:flutter/material.dart';
import 'package:giv_flutter/base/authenticated_state.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen_content_list_view.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:provider/provider.dart';

class MyGroupsScreen extends StatefulWidget {
  final MyGroupsBloc bloc;

  const MyGroupsScreen({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  State createState() => AuthenticatedState<MyGroupsScreen>(
        bloc: bloc,
        screenContent: MyGroupsScreenContent(bloc: bloc),
      );
}

class MyGroupsScreenContent extends StatefulWidget {
  final MyGroupsBloc bloc;

  const MyGroupsScreenContent({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  _MyGroupsScreenContentState createState() => _MyGroupsScreenContentState();
}

class _MyGroupsScreenContentState extends BaseState<MyGroupsScreenContent> {
  MyGroupsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _bloc.getMyMemberships();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('my_groups_screen_title'),
      ),
      body: ContentStreamBuilder(
        stream: _bloc.stream,
        onHasData: (List<GroupMembership> myMemberships) {
          return Consumer<GroupUpdatedAction>(builder: (context, state, child) {
            _handleUpdatedGroup(myMemberships, state.group);

            return MyGroupsScreenListView(
              memberships: myMemberships,
            );
          });
        },
      ),
    );
  }

  void _handleUpdatedGroup(
    List<GroupMembership> myMemberships,
    Group updatedGroup,
  ) {
    if (updatedGroup == null) {
      return;
    }

    final index = myMemberships.indexWhere(
      (it) => it.group.id == updatedGroup.id,
    );

    myMemberships.replaceRange(
      index,
      index + 1,
      [
        GroupMembership.fromOther(myMemberships[index], group: updatedGroup),
      ],
    );
  }
}
