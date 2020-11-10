import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditGroups extends StatefulWidget {
  final MyGroupsBloc myGroupsBloc;
  final List<Group> initialSelectedGroups;

  const EditGroups({
    Key key,
    @required this.myGroupsBloc,
    @required this.initialSelectedGroups,
  }) : super(key: key);

  @override
  _EditGroupsState createState() => _EditGroupsState();
}

class _EditGroupsState extends BaseState<EditGroups> {
  MyGroupsBloc _myGroupsBloc;
  List<Group> _selectedGroups;

  @override
  void initState() {
    super.initState();
    _myGroupsBloc = widget.myGroupsBloc;
    _myGroupsBloc.getMyMemberships();
    _selectedGroups = [...widget.initialSelectedGroups];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string(
          'new_listing_edit_groups_screen_title',
        ),
      ),
      body: ContentStreamBuilder(
        stream: _myGroupsBloc.stream,
        onHasData: (List<GroupMembership> myMemberships) {
          return myMemberships.isEmpty
              ? NewListingGroupsListEmptyState()
              : NewListingGroupsList(
                  memberships: myMemberships,
                  onCheckboxChecked: toggleGroup,
                  selectedGroups: _selectedGroups,
                );
        },
      ),
    );
  }

  void toggleGroup(bool checked, Group group) {
    setState(() {
      if (checked) {
        if (!isGroupSelected(_selectedGroups, group)) {
          _selectedGroups.add(group);
        }
      } else {
        _selectedGroups.removeWhere((it) => it.id == group.id);
      }
    });
  }
}

class NewListingGroupsList extends StatelessWidget {
  final List<GroupMembership> memberships;
  final Function onCheckboxChecked;
  final List<Group> selectedGroups;

  const NewListingGroupsList({
    Key key,
    @required this.memberships,
    @required this.onCheckboxChecked,
    @required this.selectedGroups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Body2Text(
          stringFunction(
            'Em quais dos seus grupos você gostaria de anunciar esta doação?',
          ),
          color: Colors.grey,
        ),
      ),
    ];

    memberships.forEach((element) {
      final group = element.group;
      children.add(EditGroupsCheckBox(
        group: group,
        checked: isGroupSelected(selectedGroups, group),
        onChecked: onCheckboxChecked,
      ));
    });

    children.addAll(<Widget>[
      Padding(
        padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
        child: PrimaryButton(
          text: stringFunction('shared_action_save'),
          onPressed: selectedGroups.isEmpty
              ? null
              : () {
                  returnList(context);
                },
        ),
      )
    ]);

    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  void returnList(BuildContext context) {
    Navigation(context).pop(selectedGroups);
  }
}

class NewListingGroupsListEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('NewListingGroupsListEmptyState'));
  }
}

class EditGroupsCheckBox extends StatelessWidget {
  final bool checked;
  final Group group;
  final Function onChecked;

  const EditGroupsCheckBox({
    Key key,
    @required this.checked,
    @required this.group,
    @required this.onChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Dimens.default_horizontal_margin,
      ),
      title: Text(group.name),
      value: checked,
      onChanged: (newValue) {
        onChecked.call(newValue, group);
      },
      controlAffinity: ListTileControlAffinity.platform,
    );
  }
}

bool isGroupSelected(List<Group> selectedGroups, Group group) {
  return selectedGroups.indexWhere((element) => element.id == group.id) != -1;
}
