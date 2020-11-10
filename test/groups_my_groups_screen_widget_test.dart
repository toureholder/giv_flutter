import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_create_group_cta.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_join_group_cta.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_membership_list_item.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_subtitle.dart';
import 'package:giv_flutter/features/listing/ui/edit_groups.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

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
        subject: MyGroupsScreen(bloc: mockMyGroupsBloc),
        dependencies: [
          ChangeNotifierProvider<GroupUpdatedAction>(
            create: (context) => GroupUpdatedAction(),
          ),
          Provider<MyGroupsBloc>(
            create: (_) => mockMyGroupsBloc,
          ),
          Provider<LogInBloc>(
            create: (_) => MockLoginBloc(),
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

  loadMembershipList({WidgetTester tester, bool isEmpty = false}) async {
    final list = isEmpty ? <GroupMembership>[] : GroupMembership.fakeList();
    subject.add(list);
    await tester.pump(Duration.zero);
  }

  userIsLoggedIn() {
    when(mockMyGroupsBloc.getUser()).thenReturn(User.fake());
  }

  group('ui', () {
    setUp(() {
      userIsLoggedIn();
    });

    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(MyGroupsScreen), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.ancestor(
          of: testUtil.findInternationalizedText('my_groups_screen_title'),
          matching: find.byType(CustomAppBar));

      expect(finder, findsOneWidget);
    });

    testWidgets('has create group call to action', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester);
      expect(find.byType(MyGroupsCreateGroupCTA), findsOneWidget);
    });

    testWidgets('has join group call to action', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester);
      expect(find.byType(MyGroupsJoinGroupCTA), findsOneWidget);
    });

    testWidgets('has "Groups" subtitle if user has groups',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester);
      expect(find.byType(MyGroupsSubTitle), findsOneWidget);
    });

    testWidgets('does NOT have "Groups" subtitle if user has no groups',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester, isEmpty: true);
      expect(find.byType(MyGroupsSubTitle), findsNothing);
    });

    testWidgets('has memerhsip items if user has groups',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester);
      expect(
        find.byType(MembershipListItem),
        findsNWidgets(
          GroupMembership.fakeList().length,
        ),
      );
    });

    testWidgets('does NOT have memerhsip items if user has no groups',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester, isEmpty: true);
      expect(find.byType(MembershipListItem), findsNothing);
    });
  });

  group('handles user authentication', () {
    testWidgets('redirects to sign in screen if user is not authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockMyGroupsBloc.getUser()).thenReturn(null);

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsOneWidget);
    });

    testWidgets('does not redirect to sign in screen if user is authenticated',
        (WidgetTester tester) async {
      // Given
      userIsLoggedIn();

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsNothing);
    });
  });

  group('handles stream events', () {
    setUp(() {
      userIsLoggedIn();
    });

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

    testWidgets('shows list when list is added to sink',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadMembershipList(tester: tester);

      expect(
        find.byType(NewListingGroupsList),
        findsNothing,
      );
    });
  });
}
