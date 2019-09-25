import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditName extends StatefulWidget {
  final User user;
  final SettingsBloc settingsBloc;

  const EditName({
    Key key,
    @required this.settingsBloc,
    this.user,
  }) : super(key: key);

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends BaseState<EditName> {
  TextEditingController _controller;
  SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = widget.settingsBloc;

    _settingsBloc.userUpdateStream.listen((HttpResponse<User> httpResponse) {
      if (httpResponse.isReady) onUpdateUserResponse(httpResponse);
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
      body: _buildStreamBuilder(),
    );
  }

  StreamBuilder<HttpResponse<User>> _buildStreamBuilder() {
    return StreamBuilder(
        stream: _settingsBloc.userUpdateStream,
        builder: (context, snapshot) {
          var isLoading = snapshot?.data?.isLoading ?? false;
          return AndroidTheme(child: _buildSingleChildScrollView(isLoading));
        });
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

    final update = {
      User.nameKey: _controller.text
    };

    _settingsBloc.updateUser(update);
  }
}
