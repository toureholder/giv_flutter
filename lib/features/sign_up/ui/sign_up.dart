import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/util/form/password_forn_field.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends BaseState<SignUp> {
  var _formKey = GlobalKey<FormState>();
  bool _shouldAutoValidate = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('sign_in_sign_up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimens.default_horizontal_margin),
          child: Form(
            key: _formKey,
            autovalidate: _shouldAutoValidate,
            child: _buildFormUI(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: string('sign_in_form_name')),
          keyboardType: TextInputType.text,
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        TextFormField(
          decoration: InputDecoration(labelText: string('sign_in_form_email')),
          keyboardType: TextInputType.emailAddress,
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        PasswordFormField(
          labelText: string('sign_in_form_password'),
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        PrimaryButton(
          text: string('sign_in_sign_up'),
          onPressed: () {},
        ),
        Spacing.vertical(Dimens.sign_in_submit_button_margin_top),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Body2Text(string('sign_in_already_have_an_acount')),
              MediumFlatPrimaryButton(
                text: string('sign_in_log_in'),
                onPressed: () {
                  navigation.pushReplacement(LogIn());
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
