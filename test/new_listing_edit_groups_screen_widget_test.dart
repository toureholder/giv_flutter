import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/listing/ui/edit_groups.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  TestUtil testUtil;
  MockMyGroupsBloc mockMyGroupsBloc;
  PublishSubject<List<GroupMembership>> subject;

  setUp(() {
    testUtil = TestUtil();
    mockMyGroupsBloc = MockMyGroupsBloc();
    testableWidget = testUtil.makeTestableWidget(
        subject: EditGroups(myGroupsBloc: mockMyGroupsBloc),
        dependencies: [
          Provider<MyGroupsBloc>(
            create: (_) => mockMyGroupsBloc,
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ]);

    subject = PublishSubject<List<GroupMembership>>();

    when(mockMyGroupsBloc.stream).thenAnswer((_) => subject.stream);
  });

  tearDown(() {
    subject.close();
  });

  loadMembershipList({
    WidgetTester tester,
    List<GroupMembership> memberships,
  }) async {
    final list = memberships ?? [];
    subject.add(list);
    await tester.pump(Duration.zero);
  }

  group('ui', () {
    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(EditGroups), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.ancestor(
          of: testUtil.findInternationalizedText(
            'new_listing_edit_groups_screen_title',
          ),
          matching: find.byType(CustomAppBar));

      expect(finder, findsOneWidget);
    });

    testWidgets('shows an EditGroupsCheckBox for each item in list',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final memberships = GroupMembership.fakeList();

      await loadMembershipList(
        tester: tester,
        memberships: memberships,
      );

      expect(
        find.byType(EditGroupsCheckBox),
        findsNWidgets(memberships.length),
      );
    });
  });

  group('actions', () {
    testWidgets('requests memberships from bloc', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      verify(mockMyGroupsBloc.getMyMemberships()).called(1);
    });
  });

  group('handles stream events', () {
    testWidgets('starts showing CircularProgressIndicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'doesn\'t show CircularProgressIndicator when list is added to sink',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadMembershipList(tester: tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'shows NewListingGroupsList when list with memberships is added to sink',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadMembershipList(
        tester: tester,
        memberships: GroupMembership.fakeList(),
      );

      expect(find.byType(NewListingGroupsList), findsOneWidget);
      expect(find.byType(NewListingGroupsListEmptyState), findsNothing);
    });

    testWidgets('shows a CheckboxListTile for each memberships',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final list = GroupMembership.fakeList();

      await loadMembershipList(
        tester: tester,
        memberships: list,
      );

      expect(find.byType(CheckboxListTile), findsNWidgets(list.length));
      expect(find.byType(NewListingGroupsListEmptyState), findsNothing);
    });

    testWidgets(
        'shows NewListingGroupsListEmptyState when list without memberships is added to sink',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadMembershipList(
        tester: tester,
        memberships: [],
      );

      expect(find.byType(NewListingGroupsListEmptyState), findsOneWidget);
      expect(find.byType(NewListingGroupsList), findsNothing);
    });
  });
}
