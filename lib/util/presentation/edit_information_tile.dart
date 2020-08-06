import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditInformationTile extends StatelessWidget {
  final String value;
  final String caption;
  final String emptyStateCaption;
  final GestureTapCallback onTap;

  const EditInformationTile({
    Key key,
    @required this.value,
    @required this.caption,
    @required this.emptyStateCaption,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final computedValue =
        (value != null && value.trim().isEmpty) ? null : value;

    var finalValue = computedValue ?? caption;
    var finalCaption = computedValue == null ? emptyStateCaption : caption;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 12.0, horizontal: Dimens.default_horizontal_margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BodyText(finalValue),
              Spacing.vertical(2.0),
              Body2Text(finalCaption, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }
}
