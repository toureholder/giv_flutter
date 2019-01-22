import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditName extends StatefulWidget {
  final User user;

  const EditName({Key key, this.user}) : super(key: key);

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends BaseState<EditName> {
  TextEditingController _controller;
  SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc();

    _settingsBloc.userStream.listen((StreamEvent<User> event) {
      if (event.isReady) _onUpdateSuccess(event.data);
    });

    _controller = widget.user?.name == null
        ? TextEditingController()
        : TextEditingController.fromValue(
        new TextEditingValue(text: widget.user.name));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('settings_name'),
      ),
      body: StreamBuilder(
          stream: _settingsBloc.userStream,
          builder: (context, snapshot) {
            var isLoading = snapshot?.data?.isLoading ?? false;
            return _buildSingleChildScrollView(isLoading);
          }),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView(bool isLoading) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Body2Text(
                string('settings_edit_name_hint'),
                color: Colors.grey,
              ),
              Spacing.vertical(Dimens.default_vertical_margin),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: string('settings_name')),
                maxLength: Config.maxLengthName,
                autofocus: true,
                enabled: !isLoading,
              ),
              Spacing.vertical(Dimens.default_vertical_margin),
              _primaryButton(isLoading)
            ],
          ),
        ),
      ),
    );
  }

  PrimaryButton _primaryButton(bool isLoading) {
    return PrimaryButton(
      text: string('shared_action_save'),
      onPressed: _updateUser,
      isLoading: isLoading,
    );
  }

  void _updateUser() {
    if (_controller.text.isEmpty) return;

    if (_controller.text == widget.user.name) {
      Navigator.pop(context);
      return;
    }

    var userUpdate = widget.user.copy();
    userUpdate.name =  _controller.text;
    _settingsBloc.updateUser(userUpdate);
  }

  void _onUpdateSuccess(User user) {
    Navigator.pop(context, user);
  }
}