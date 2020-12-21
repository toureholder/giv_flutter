import 'package:flutter/material.dart';
import 'package:giv_flutter/base/authenticated_state.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/groups/create_group/bloc/create_group_bloc.dart';
import 'package:giv_flutter/features/groups/create_group/ui/create_group_form.dart';
import 'package:giv_flutter/util/presentation/progressive_onboarding_screen.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  final CreateGroupBloc bloc;

  const CreateGroupScreen({Key key, @required this.bloc}) : super(key: key);

  @override
  State createState() => AuthenticatedState<CreateGroupScreen>(
        bloc: bloc,
        screenContent: CreateGroupScreenContent(bloc: bloc),
      );
}

class CreateGroupScreenContent extends StatefulWidget {
  final CreateGroupBloc bloc;

  const CreateGroupScreenContent({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  _CreateGroupScreenContentState createState() =>
      _CreateGroupScreenContentState();
}

class _CreateGroupScreenContentState
    extends BaseState<CreateGroupScreenContent> {
  final _nameController = TextEditingController();

  CreateGroupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _listenToCreateGroupStream();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('create_group_screen_title'),
      ),
      body: ProgressiveOnboardingScreen(
        verifier: _bloc.hasSeenCreateGroupIntroduction,
        setter: _bloc.setHasSeenCreateGroupIntroduction,
        imageAsset: 'images/undraw_team.svg',
        text: string('progressive_onboarding_create_group_text'),
        buttonText: string('progressive_onboarding_create_group_button_text'),
        child: StreamBuilder<HttpResponse<Group>>(
            stream: _bloc.groupStream,
            builder: (context, snapshot) {
              final isLoading = snapshot.hasData && snapshot.data.isLoading;
              return CreateGroupForm(
                isLoading: isLoading,
                textEditingController: _nameController,
                onSubmitValidForm: () {
                  _bloc.createGroup(
                      CreateGroupRequest(name: _nameController.text));
                },
              );
            }),
      ),
    );
  }

  void _listenToCreateGroupStream() {
    _bloc.groupStream
        ?.listen(_onCreateGroupReponse, onError: _handleUnknownError);
  }

  void _onCreateGroupReponse(HttpResponse<Group> response) {
    if (response.isLoading) return;

    switch (response.status) {
      case HttpStatus.created:
        _onCreateGroupSuccess(response.data);
        break;
      default:
        _handleUnknownError(null);
    }
  }

  void _onCreateGroupSuccess(Group group) {
    _goToMyGroupsReloaded();
  }

  void _handleUnknownError(error) {
    showGenericErrorDialog();
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
}
