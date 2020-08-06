import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/form/custom_text_form_field.dart';
import 'package:giv_flutter/util/form/form_validator.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';

class CreateGroupForm extends StatefulWidget {
  final Function onSubmitValidForm;
  final TextEditingController textEditingController;
  final bool isLoading;

  const CreateGroupForm({
    Key key,
    @required this.onSubmitValidForm,
    @required this.textEditingController,
    @required this.isLoading,
  }) : super(key: key);

  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: AndroidTheme(
            child: CreateGroupFormUI(
              onSubmit: _handleSubmit,
              textEditingController: widget.textEditingController,
              isLoading: widget.isLoading,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    setState(() {
      _autovalidate = true;
    });

    if (_formKey.currentState.validate()) {
      widget.onSubmitValidForm.call();
    }
  }
}

class CreateGroupFormUI extends StatelessWidget {
  final Function onSubmit;
  final TextEditingController textEditingController;
  final bool isLoading;

  const CreateGroupFormUI({
    Key key,
    @required this.onSubmit,
    @required this.textEditingController,
    @required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DefaultVerticalSpacing(),
        CustomTextFormField(
          controller: textEditingController,
          validator: (String input) => stringFunction(
            FormValidator().required(input),
          ),
          labelText: stringFunction('create_group_form_name_label'),
          maxLength: 50,
        ),
        DefaultVerticalSpacing(),
        DefaultVerticalSpacing(),
        PrimaryButton(
          text: stringFunction('create_group_form_submit_button_text'),
          onPressed: onSubmit,
          isLoading: isLoading,
        )
      ],
    );
  }
}
