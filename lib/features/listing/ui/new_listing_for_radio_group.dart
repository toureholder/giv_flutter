import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';

enum ListingFor { everyone, myGroups }

class NewListingForRadioGroup extends StatelessWidget {
  final ValueChanged<ListingFor> onValueChanged;
  final bool isListingPrivate;

  const NewListingForRadioGroup({
    Key key,
    @required this.onValueChanged,
    @required this.isListingPrivate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupValue =
        isListingPrivate ? ListingFor.myGroups : ListingFor.everyone;

    final optionsMap = <ListingFor, String>{
      ListingFor.everyone: 'new_listing_for_who_everyone',
      ListingFor.myGroups: 'new_listing_for_who_only_groups',
    };

    final children = <Widget>[];

    optionsMap.forEach((key, value) {
      children.add(ListTile(
        leading: Radio<ListingFor>(
          value: key,
          groupValue: groupValue,
          onChanged: onValueChanged,
        ),
        title: Text(GetLocalizedStringFunction(context)(value)),
        onTap: () {
          onValueChanged.call(key);
        },
      ));
    });

    return Column(
      children: children,
    );
  }
}
