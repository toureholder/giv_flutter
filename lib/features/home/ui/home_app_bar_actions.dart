import 'package:flutter/material.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/ui/home.dart';

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
        ? SignInButton(onPressed: onSignInButtonPressed)
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
