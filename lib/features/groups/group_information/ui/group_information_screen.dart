import 'package:flutter/material.dart';
import 'package:giv_flutter/base/authenticated_state.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/groups/edit_group/bloc/edit_group_bloc.dart';
import 'package:giv_flutter/features/groups/edit_group/ui/edit_group_screen.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_hero.dart';
import 'package:giv_flutter/features/groups/group_information/bloc/group_information_bloc.dart';
import 'package:giv_flutter/features/groups/group_information/ui/group_information_access_code.dart';
import 'package:giv_flutter/features/groups/group_information/ui/group_information_description.dart';
import 'package:giv_flutter/features/groups/group_information/ui/group_information_member_tile.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/presentation/section_title.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class GroupInformationScreen extends StatefulWidget {
  final GroupInformationBloc bloc;
  final int membershipId;

  const GroupInformationScreen({
    Key key,
    @required this.bloc,
    @required this.membershipId,
  }) : super(key: key);

  @override
  State createState() => AuthenticatedState<GroupInformationScreen>(
        bloc: bloc,
        screenContent: GroupInformationScreenContent(
          bloc: bloc,
          membershipId: membershipId,
        ),
      );
}

class GroupInformationScreenContent extends StatefulWidget {
  final GroupInformationBloc bloc;
  final int membershipId;

  const GroupInformationScreenContent({
    Key key,
    @required this.bloc,
    @required this.membershipId,
  }) : super(key: key);

  @override
  _GroupInformationScreenContentState createState() =>
      _GroupInformationScreenContentState();
}

class _GroupInformationScreenContentState
    extends BaseState<GroupInformationScreenContent> {
  Group _group;
  GroupInformationBloc _bloc;
  double _titleOpacity;

  // Infinite scroll code
  List<GroupMembership> _memberships = [];
  bool _isInfiniteScrollOn;
  int _currentPage;
  ScrollController _scrollController;
  double _loadingWidgetOpacity;
  GroupMembership _myMembership;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _getMyMembership();
    _titleOpacity = 0.0;

    // Infinite scroll code
    _scrollController = ScrollController();
    _enableInfiniteScroll();
    _observeScrolling();
    _fetchMemberships();
  }

  _getMyMembership() {
    _myMembership = _bloc.getMembershipById(widget.membershipId);
    _group = _myMembership.group;
  }

  @override
  void dispose() {
    // Infinite scroll code
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: _group.name,
        titleOpacity: _titleOpacity,
      ),
      body: ContentStreamBuilder(
        stream: _bloc.loadMembershipsStream,
        onHasData: (List<GroupMembership> memberships) {
          _addFetchedMembershipsToList(memberships);

          final actionWidget = _myMembership.isAdmin
              ? EditIconButton(
                  onPressed: _navigateToEditGroupScreen,
                  color: Colors.white,
                )
              : null;

          final widgets = <Widget>[
            GroupDetailHero(
              group: _group,
              onTap: null,
              actionWidget: actionWidget,
            ),
            DefaultVerticalSpacing(),
            SectionTitle(string('group_information_screen_acess_code')),
            GroupInformationAccessCode(
              bloc: _bloc,
              group: _group,
            ),
            DefaultVerticalSpacing(),
            SectionTitle(string('group_information_screen_description')),
            GroupInformationDescription(
              description: _group.description,
            ),
            DefaultVerticalSpacing(),
            SectionTitle(string('group_information_screen_members')),
          ];

          _memberships.forEach((membership) {
            widgets.add(GroupInformationMemberTile(membership: membership));
          });

          widgets.addAll([
            Spacing.vertical(Dimens.default_vertical_margin),
            LoadingMore(opacity: _loadingWidgetOpacity),
          ]);

          return ListView(
            children: widgets,
            // Infinite scroll code
            controller: _scrollController,
          );
        },
      ),
    );
  }

  void _navigateToEditGroupScreen() async {
    await navigation.push(
      Consumer<EditGroupBloc>(
        builder: (context, bloc, child) => EditGroupScreen(
          bloc: bloc,
          groupId: _group.id,
        ),
      ),
    );

    setState(() {
      _getMyMembership();
    });
  }

  // Infinite scroll code
  _fetchMemberships() {
    _currentPage++;
    _bloc.getGroupMemberships(
      groupId: _group.id,
      page: _currentPage,
    );
  }

  _addFetchedMembershipsToList(List<GroupMembership> memberships) {
    if (_memberships.where((it) => it.id == memberships.first.id).isEmpty)
      _memberships.addAll(memberships);

    if (memberships.length < Config.paginationDefaultPerPage)
      _disableInfiniteScroll();
  }

  _disableInfiniteScroll() {
    _isInfiniteScrollOn = false;
    _loadingWidgetOpacity = 0.0;
  }

  _enableInfiniteScroll() {
    _currentPage = 0;
    _isInfiniteScrollOn = true;
    _memberships.clear();
    _loadingWidgetOpacity = 1.0;
  }

  _observeScrolling() {
    _scrollController.addListener(() {
      final position = _scrollController.position;

      _toggleTitleOpacity(position.pixels);

      if (position.pixels == position.maxScrollExtent && _isInfiniteScrollOn) {
        _fetchMemberships();
      }
    });
  }

  _toggleTitleOpacity(double scrollPosition) {
    setState(() {
      _titleOpacity = scrollPosition > GroupDetailHero.HEIGHT ? 1.0 : 0.0;
    });
  }
}
