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
import 'package:giv_flutter/util/util.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:country_code_picker/country_code_picker.dart';

class EditPhoneNumber extends StatefulWidget {
  final User user;

  const EditPhoneNumber({Key key, this.user}) : super(key: key);

  @override
  _EditPhoneNumberState createState() => _EditPhoneNumberState();
}

class _EditPhoneNumberState extends BaseState<EditPhoneNumber> {
  TextEditingController _controller;
  SettingsBloc _settingsBloc;
  String _defaultCode = Config.defaultCountryCallingCode;
  String _selectedCode;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc();

    _settingsBloc.userStream.listen((StreamEvent<User> event) {
      if (event.isReady) _onUpdateSuccess(event.data);
    });

    _controller = widget.user?.phoneNumber == null
        ? TextEditingController()
        : TextEditingController.fromValue(
            new TextEditingValue(text: widget.user.phoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('settings_phone_number'),
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
    _selectedCode = widget.user?.countryCallingCode ?? _defaultCode;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Body2Text(
                string('settings_edit_phone_number_hint'),
                color: Colors.grey,
              ),
              Spacing.vertical(Dimens.default_vertical_margin),
              Row(
                children: <Widget>[
                  CountryCodePicker(
                    onChanged: _onCountryChange,
                    initialSelection: '+$_selectedCode',
                    favorite: ['+$_defaultCode'],
                  ),
                  Spacing.horizontal(4.0),
                  Flexible(
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText:
                              string('settings_phone_number_edit_text_hint')),
                      autofocus: true,
                      enabled: !isLoading,
                    ),
                  )
                ],
              ),
              Spacing.vertical(32.0),
              Row(
                children: <Widget>[
                  _testButton(),
                  Spacing.horizontal(8.0),
                  Flexible(child: _primaryButton(isLoading))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GreyButton _testButton() {
    return GreyButton(
      onPressed: _testWhatsApp,
      text: string('settings_edit_phone_number_test_button'),
      fillWidth: false,
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

    if (_selectedCode == widget.user.countryCallingCode &&
        _controller.text == widget.user.phoneNumber) {
      Navigator.pop(context);
      return;
    }

    var userUpdate = widget.user.copy();
    userUpdate.countryCallingCode = _selectedCode;
    userUpdate.phoneNumber = _controller.text;
    _settingsBloc.updateUser(userUpdate);
  }

  void _onUpdateSuccess(User user) {
    Navigator.pop(context, user);
  }

  void _onCountryChange(CountryCode countryCode) {
    _selectedCode = countryCode.toString().substring(1);
  }

  void _testWhatsApp() {
    if (_controller.text == null || _controller.text.isEmpty) return;

    var number = '$_selectedCode${_controller.text}';
    print(number);
    var message = string('settings_edit_phone_number_test_message');
    Util.openWhatsApp(number, message);
  }
}
