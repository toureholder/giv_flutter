import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/groups/join_group/bloc/join_group_bloc.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_access_code_input.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_loading_stream_builder.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_try_again_button.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class JoinGroupScreen extends StatefulWidget {
  final JoinGroupBloc bloc;

  const JoinGroupScreen({Key key, @required this.bloc}) : super(key: key);

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends BaseState<JoinGroupScreen> {
  JoinGroupBloc _bloc;
  User _user;
  bool _showTryAgainButton = false;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _user = _bloc.getUser();
    _listenToJoinGroupStream();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _user != null
        ? JoinGroupScreenContent(
            bloc: _bloc,
            showTryAgainButton: _showTryAgainButton,
          )
        : Consumer<LogInBloc>(
            builder: (context, bloc, child) => SignIn(
              bloc: bloc,
              redirect: JoinGroupScreenContent(
                bloc: _bloc,
              ),
            ),
          );
  }

  void _listenToJoinGroupStream() {
    _bloc.groupMembershipStream
        ?.listen(_onJoinGroupReponse, onError: _handleUnknownError);
  }

  void _onJoinGroupReponse(HttpResponse<GroupMembership> response) {
    if (response.isLoading) return;

    switch (response.status) {
      case HttpStatus.created:
        _goToMyGroupsReloaded();
        break;
      case HttpStatus.notFound:
        showInformationDialog(
            title: string('join_group_screen_group_not_found_title'),
            content: string('join_group_screen_group_not_found_text'));
        break;
      case HttpStatus.conflict:
        showInformationDialog(
            title: string('join_group_screen_group_already_a_member_title'),
            content: string('join_group_screen_group_already_a_member_text'));
        break;
      default:
        _handleUnknownError(null);
    }
  }

  void _goToMyGroupsReloaded() {
    navigation.push(
      Base(),
      hasAnimation: false,
      clearStack: true,
    );
    navigation.push(
      Consumer<MyGroupsBloc>(
        builder: (context, bloc, child) => MyGroupsScreen(
          bloc: bloc,
        ),
      ),
      hasAnimation: false,
    );
  }

  void _handleUnknownError(error) {
    showGenericErrorDialog();
    setState(() {
      _showTryAgainButton = true;
    });
  }
}

class JoinGroupScreenContent extends StatefulWidget {
  final JoinGroupBloc bloc;
  final bool showTryAgainButton;

  JoinGroupScreenContent({
    Key key,
    @required this.bloc,
    this.showTryAgainButton = false,
  }) : super(key: key);

  @override
  _JoinGroupScreenContentState createState() => _JoinGroupScreenContentState();
}

class _JoinGroupScreenContentState extends BaseState<JoinGroupScreenContent> {
  JoinGroupBloc _bloc;
  String _accessToken;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('join_group_screen_title'),
      ),
      body: ListView(
        children: <Widget>[
          Spacing.vertical(Dimens.grid(60)),
          Container(
            alignment: Alignment.center,
            child: BodyText(string('join_group_screen_input_prompt')),
          ),
          DefaultVerticalSpacing(),
          JoinGroupAccessCodeInput(
            onCompleted: _sendJoinGroupRequest,
          ),
          Spacing.vertical(Dimens.grid(30)),
          if (widget.showTryAgainButton)
            JoinGroupTryAgainButton(
              onPressed: () {
                _sendJoinGroupRequest(_accessToken);
              },
            ),
          if (widget.showTryAgainButton) Spacing.vertical(Dimens.grid(30)),
          JoinGroupLoadingStreamBuilder(
            stream: _bloc.groupMembershipStream,
          ),
        ],
      ),
    );
  }

  void _sendJoinGroupRequest(String token) {
    _accessToken = token;
    final request = JoinGroupRequest(accessToken: token);
    _bloc.joinGroup(request);
  }
}
