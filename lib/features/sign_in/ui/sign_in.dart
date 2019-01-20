import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends BaseState<SignIn> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
                child: Container()),
          ],
        ),
        CustomScaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Center(
                      child: Text(string('app_name'))),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.grid(15), vertical: Dimens.grid(30)),
                child: Column(
                  children: <Widget>[
                    FacebookButton(
                      text: string('sign_in_continue_with_facebook'),
                      onPressed: () {},
                    ),
                    Spacing.vertical(Dimens.default_vertical_margin),
                    PrimaryButton(
                      text: string('sign_in_sign_up'),
                      onPressed: _goToSignUp,
                    ),
                    Spacing.vertical(Dimens.default_vertical_margin),
                    Body2Text(string('sign_in_already_have_an_acount')),
                    Spacing.vertical(Dimens.default_vertical_margin),
                    GreyButton(
                      text: string('sign_in_log_in'),
                      onPressed: _goToLogIn,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void _goToSignUp() {
    navigation.push(SignUp());
  }

  void _goToLogIn() {
    navigation.push(LogIn());
  }
}
