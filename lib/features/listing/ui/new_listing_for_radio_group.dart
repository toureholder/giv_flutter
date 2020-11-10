import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

enum ListingFor { everyone, myGroups }

class NewListingForRadioGroup extends StatelessWidget {
  final ValueChanged<ListingFor> onValueChanged;
  final bool isListingPrivate;
  final bool isError;
  final List<Group> groups;

  const NewListingForRadioGroup({
    Key key,
    @required this.onValueChanged,
    @required this.isListingPrivate,
    @required this.isError,
    @required this.groups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    final groupValue =
        isListingPrivate ? ListingFor.myGroups : ListingFor.everyone;

    final forMyGroupsText = (!isListingPrivate || groups.isEmpty)
        ? 'new_listing_for_who_only_groups'
        : groups.length == 1
            ? 'new_listing_for_who_only_one_group'
            : 'new_listing_for_who_only_these_groups';

    final optionsMap = <ListingFor, String>{
      ListingFor.everyone: 'new_listing_for_who_everyone',
      ListingFor.myGroups: forMyGroupsText,
    };

    final children = <Widget>[];

    optionsMap.forEach((key, value) {
      final subtitleColor =
          isListingPrivate && isError ? Colors.red : Colors.grey;

      final subtitle = value == 'new_listing_for_who_only_groups' &&
              (!isListingPrivate || groups.isEmpty)
          ? Body2Text(
              stringFunction('Toque aqui para selecionar os grupos'),
              color: subtitleColor,
            )
          : null;

      children.add(
        ListTile(
          leading: Radio<ListingFor>(
            value: key,
            groupValue: groupValue,
            onChanged: onValueChanged,
          ),
          title: Text(stringFunction(value)),
          subtitle: subtitle,
          onTap: () {
            onValueChanged.call(key);
          },
        ),
      );
    });

    if (isListingPrivate && groups.isNotEmpty) {
      children.addAll(
        <Widget>[
          NewListingForTheseGroups(
            onTap: () {
              onValueChanged.call(ListingFor.myGroups);
            },
            groups: groups,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class NewListingForTheseGroups extends StatelessWidget {
  const NewListingForTheseGroups({
    Key key,
    @required this.onTap,
    @required this.groups,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 80.0,
          right: Dimens.default_horizontal_margin,
        ),
        child: Body2Text(
          groups.map((it) => it.name).join(', '),
          weight: SyntheticFontWeight.bold,
        ),
      ),
    );
  }
}
