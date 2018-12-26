import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';

class RoundedCorners extends StatelessWidget {
  final Widget child;

  const RoundedCorners({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.default_rounded_corner_border_radius),
      child: child,
    );
  }
}
