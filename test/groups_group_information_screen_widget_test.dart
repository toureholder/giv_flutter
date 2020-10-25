import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/groups/group_information/ui/group_information_screen.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  TestUtil testUtil;
  MockGroupInformationBloc mockBloc;
  PublishSubject<List<GroupMembership>> loadMembershipsSubject;
  int fakeMembershipId;

  setUp(() {
    testUtil = TestUtil();
    mockBloc = MockGroupInformationBloc();
    fakeMembershipId = 1;
    testableWidget = testUtil.makeTestableWidget(
        subject: GroupInformationScreen(
          bloc: mockBloc,
          membershipId: fakeMembershipId,
        ),
        dependencies: [
          Provider<MockGroupInformationBloc>(
            create: (_) => mockBloc,
          ),
          Provider<LogInBloc>(
            create: (_) => MockLoginBloc(),
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          )
        ]);

    loadMembershipsSubject = PublishSubject<List<GroupMembership>>();

    when(mockBloc.loadMembershipsStream)
        .thenAnswer((_) => loadMembershipsSubject.stream);
  });

  tearDown(() {
    loadMembershipsSubject.close();
  });

  userIsLoggedIn() {
    when(mockBloc.getUser()).thenReturn(User.fake());
  }

  loadMembershipList({WidgetTester tester, bool isEmpty = false}) async {
    final list = isEmpty ? <GroupMembership>[] : GroupMembership.fakeList();
    loadMembershipsSubject.add(list);
    await tester.pump(Duration.zero);
  }

  group('ui', () {
    setUp(() {
      userIsLoggedIn();
    });

    testWidgets('widget builds', (WidgetTester tester) async {
      // Given
      when(mockBloc.getMembershipById(fakeMembershipId))
          .thenReturn(GroupMembership.fake());

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(GroupInformationScreen), findsOneWidget);
    });
  });

  group('handles stream events', () {
    setUp(() {
      userIsLoggedIn();
      when(mockBloc.getMembershipById(fakeMembershipId))
          .thenReturn(GroupMembership.fake());
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
  });

  group('handles admin user', () {
    setUp(() {
      userIsLoggedIn();
    });

    testWidgets('shows edit buttton if authenticated user is group admin',
        (WidgetTester tester) async {
      // Given
      when(mockBloc.getMembershipById(fakeMembershipId))
          .thenReturn(GroupMembership.fake(isAdmin: true));

      // When
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester);

      expect(find.byType(EditIconButton), findsOneWidget);
    });

    testWidgets(
        'does NOT show edit buttton if authenticated user is not group admin',
        (WidgetTester tester) async {
      // Given
      when(mockBloc.getMembershipById(fakeMembershipId))
          .thenReturn(GroupMembership.fake(isAdmin: false));

      // When
      await tester.pumpWidget(testableWidget);
      await loadMembershipList(tester: tester);

      expect(find.byType(EditIconButton), findsNothing);
    });
  });

  group('handles user authentication', () {
    setUp(() {
      when(mockBloc.getMembershipById(fakeMembershipId))
          .thenReturn(GroupMembership.fake());
    });

    testWidgets('redirects to sign in screen if user is not authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockBloc.getUser()).thenReturn(null);

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
}
