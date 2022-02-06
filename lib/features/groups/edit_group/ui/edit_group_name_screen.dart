import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/groups/edit_group/bloc/edit_group_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditGroupPropertyScreen extends StatefulWidget {
  final int groupId;
  final EditGroupBloc bloc;
  final TextInputType keyboardType;
  final int inputMaxLines;
  final int inputMaxLength;
  final String inputHintText;
  final String appBarTitle;
  final String property;

  const EditGroupPropertyScreen({
    Key key,
    @required this.bloc,
    @required this.groupId,
    @required this.inputHintText,
    @required this.appBarTitle,
    @required this.property,
    @required this.inputMaxLength,
    this.inputMaxLines,
    this.keyboardType,
  }) : super(key: key);

  @override
  _EditGroupPropertyScreenState createState() =>
      _EditGroupPropertyScreenState();
}

class _EditGroupPropertyScreenState extends BaseState<EditGroupPropertyScreen> {
  Group _group;
  TextEditingController _controller;
  EditGroupBloc _bloc;
  String _property;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
    _bloc = widget.bloc;
    _group = _bloc.getGroupById(widget.groupId);

    _bloc.groupStream.listen((HttpResponse<Group> httpResponse) {
      if (httpResponse.isReady) _onUpdateGroupResponse(httpResponse);
    });

    final propertyValue = _group.toJson()[_property];

    _controller = propertyValue == null
        ? TextEditingController()
        : TextEditingController.fromValue(
            new TextEditingValue(
              text: propertyValue,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.appBarTitle,
      ),
      body: StreamBuilder<HttpResponse<Group>>(
          stream: _bloc.groupStream,
          builder: (context, snapshot) {
            var isLoading = snapshot?.data?.isLoading ?? false;
            return AndroidTheme(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(Dimens.default_horizontal_margin),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _controller,
                          keyboardType:
                              widget.keyboardType ?? TextInputType.text,
                          maxLines: widget.inputMaxLines ?? 1,
                          decoration: InputDecoration(
                            hintText: widget.inputHintText,
                          ),
                          maxLength: widget.inputMaxLength,
                          autofocus: true,
                          enabled: !isLoading,
                        ),
                        Spacing.vertical(Dimens.default_vertical_margin),
                        PrimaryButton(
                          text: string('shared_action_save'),
                          onPressed: () {
                            _updateGroup();
                          },
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _updateGroup() {
    final input = _controller.text;

    if (input.isEmpty) return;

    if (input == _group.toJson()[_property]) {
      Navigator.pop(context);
      return;
    }

    final update = <String, dynamic>{
      _property: input,
    };

    _bloc.editGroup(_group.id, update);
  }

  void _onUpdateGroupResponse(HttpResponse<Group> response) {
    if (response.status == HttpStatus.ok) {
      navigation.pop();
      return;
    }

    showGenericErrorDialog();
  }
}
