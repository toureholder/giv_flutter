import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/listing/ui/new_listing_for_radio_group.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
  });

  Widget makeTestableWidget({
    ValueChanged<ListingFor> onValueChanged,
    bool isListingPrivate,
    List<Group> groups,
  }) {
    onValueChanged = onValueChanged ?? (ListingFor option) {};
    isListingPrivate = isListingPrivate ?? true;
    groups = groups ?? [];

    return testUtil.makeTestableWidget(
        subject: NewListingForRadioGroup(
          onValueChanged: onValueChanged,
          isListingPrivate: isListingPrivate,
          groups: groups,
          isError: false,
        ),
        dependencies: [
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ]);
  }

  group('ui', () {
    testWidgets('widget builds', (WidgetTester tester) async {
      testableWidget = makeTestableWidget();
      await tester.pumpWidget(testableWidget);
      expect(find.byType(NewListingForRadioGroup), findsOneWidget);
    });

    testWidgets(
        'list tile has correct text if listing is private but has no groups',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isListingPrivate: true,
        groups: [],
      );
      await tester.pumpWidget(testableWidget);
      expect(
        find.descendant(
            of: find.byType(ListTile),
            matching: testUtil
                .findInternationalizedText('new_listing_for_who_only_groups')),
        findsOneWidget,
      );
    });

    testWidgets(
        'list tile has correct text if listing is private and has multiple groups',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isListingPrivate: true,
        groups: Group.fakeList(),
      );
      await tester.pumpWidget(testableWidget);
      expect(
        find.descendant(
            of: find.byType(ListTile),
            matching: testUtil.findInternationalizedText(
                'new_listing_for_who_only_these_groups')),
        findsOneWidget,
      );
    });

    testWidgets(
        'list tile has correct text if listing is private and has one group',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isListingPrivate: true,
        groups: [Group.fake()],
      );
      await tester.pumpWidget(testableWidget);
      expect(
        find.descendant(
            of: find.byType(ListTile),
            matching: testUtil.findInternationalizedText(
                'new_listing_for_who_only_one_group')),
        findsOneWidget,
      );
    });

    testWidgets('shows list of groups if listing is private and has groups',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isListingPrivate: true,
        groups: Group.fakeList(),
      );
      await tester.pumpWidget(testableWidget);
      expect(find.byType(NewListingForTheseGroups), findsOneWidget);
    });

    testWidgets(
        'does NOT show list of groups if listing is private but has no groups',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isListingPrivate: true,
        groups: [],
      );
      await tester.pumpWidget(testableWidget);
      expect(find.byType(NewListingForTheseGroups), findsNothing);
    });

    testWidgets('does NOT show list of groups if listing is private',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(isListingPrivate: false);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(NewListingForTheseGroups), findsNothing);
    });

    testWidgets('shows group names if is private and groups array is not empty',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isListingPrivate: true,
        groups: Group.fakeList(),
      );
      await tester.pumpWidget(testableWidget);

      final expectedText = Group.fakeList().map((it) => it.name).join(', ');

      expect(
        find.descendant(
          of: find.byType(NewListingForTheseGroups),
          matching: find.text(expectedText),
        ),
        findsOneWidget,
      );
    });
  });
}
