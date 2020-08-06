import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giv_flutter/features/groups/group_information/bloc/group_information_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class GroupInformationAccessCode extends StatelessWidget {
  final Group group;
  final GroupInformationBloc bloc;

  const GroupInformationAccessCode({
    Key key,
    @required this.group,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final code = group.accessToken;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.default_horizontal_margin,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          H4Text(code),
          Row(
            children: <Widget>[
              CopyIconButton(onPressed: () {
                _copyCodeToClipBoard(context, code);
              }),
              ShareIconButton(onPressed: () {
                bloc.shareGroup(context, group);
              }),
            ],
          )
        ],
      ),
    );
  }

  _copyCodeToClipBoard(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    Scaffold.of(context).showSnackBar(SnackBar(
      content: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: code,
            style: new TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          TextSpan(
            text: ' copiado!',
            style: new TextStyle(color: Colors.white, fontSize: 16.0),
          )
        ]),
      ),
    ));
  }
}
