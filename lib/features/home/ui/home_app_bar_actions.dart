import 'package:flutter/material.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';

class AppBarActionsRow extends StatelessWidget {
  final HomeBloc homeBloc;
  final VoidCallback onSignInButtonPressed;
  final GestureTapCallback onHomeUserAvatarTap;

  const AppBarActionsRow({
    Key key,
    @required this.homeBloc,
    @required this.onSignInButtonPressed,
    @required this.onHomeUserAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = homeBloc.getUser();
    final userWidget = authenticatedUser == null
        ? MenuIconButton(
            onPressed: onSignInButtonPressed,
          )
        : HomeUserAvatar(
            imageUrl: authenticatedUser.avatarUrl,
            onTap: onHomeUserAvatarTap,
          );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        userWidget,
      ],
    );
  }
}
