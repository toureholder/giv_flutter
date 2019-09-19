import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class SignInFullPageMessage extends StatefulWidget {
  final Widget heroWidget;
  final String title;
  final String message;
  final String buttonText;

  const SignInFullPageMessage(
      {Key key, this.heroWidget, this.title, this.message, this.buttonText})
      : super(key: key);

  @override
  _SignInFullPageMessageState createState() => _SignInFullPageMessageState();
}

class _SignInFullPageMessageState extends BaseState<SignInFullPageMessage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.heroWidget,
                ],
              ),
              Spacing.vertical(Dimens.grid(20)),
              H6Text(widget.title),
              Spacing.vertical(Dimens.grid(20)),
              BodyText(
                widget.message,
                textAlign: TextAlign.center,
              ),
              Spacing.vertical(Dimens.grid(20)),
              PrimaryButton(
                text: string('common_ok'),
                onPressed: () {
                  navigation.pushReplacement(Consumer<LogInBloc>(
                    builder: (context, bloc, child) => LogIn(
                      bloc: bloc,
                    ),
                  ));
                },
                fillWidth: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
