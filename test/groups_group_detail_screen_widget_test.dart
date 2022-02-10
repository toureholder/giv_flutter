import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_hero.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_screen.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
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
  MockGroupDetailBloc mockBloc;
  PublishSubject<List<Product>> subject;
  PublishSubject<HttpResponse<GroupMembership>> leaveGroupSubject;
  PublishSubject<HttpResponse<void>> addManyListingsSubject;
  int fakeMembershipId;

  setUp(() {
    testUtil = TestUtil();
    mockBloc = MockGroupDetailBloc();
    fakeMembershipId = 1;
    testableWidget = testUtil.makeTestableWidget(
        subject: GroupDetailScreen(
          bloc: mockBloc,
          membershipId: fakeMembershipId,
        ),
        dependencies: [
          Provider<MockGroupDetailBloc>(
            create: (_) => mockBloc,
          ),
          Provider<LogInBloc>(
            create: (_) => MockLoginBloc(),
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          )
        ]);

    subject = PublishSubject<List<Product>>();
    leaveGroupSubject = PublishSubject<HttpResponse<GroupMembership>>();
    addManyListingsSubject = PublishSubject<HttpResponse<void>>();

    when(mockBloc.productsStream).thenAnswer((_) => subject.stream);
    when(mockBloc.leaveGroupStream).thenAnswer((_) => leaveGroupSubject.stream);
    when(mockBloc.addListingsStream).thenAnswer(
      (_) => addManyListingsSubject.stream,
    );

    when(mockBloc.getMembershipById(any)).thenReturn(GroupMembership.fake());
  });

  tearDown(() {
    subject.close();
    leaveGroupSubject.close();
    addManyListingsSubject.close();
  });

  userIsLoggedIn() {
    when(mockBloc.getUser()).thenReturn(User.fake());
  }

  loadProductList({WidgetTester tester, bool isEmpty = false}) async {
    final list = isEmpty ? <Product>[] : Product.fakeList();
    subject.add(list);
    await tester.pump(Duration.zero);
  }

  group('ui', () {
    setUp(() {
      userIsLoggedIn();
    });

    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(GroupDetailScreen), findsOneWidget);
    });

    testWidgets('has share button', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(ShareIconButton), findsOneWidget);
    });

    testWidgets('has see more button', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(MoreIconButton), findsOneWidget);
    });

    testWidgets('has hero with group\'s name', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadProductList(tester: tester);

      final fakeMembership = GroupMembership.fake(id: 123);
      when(mockBloc.getMembershipById(fakeMembershipId))
          .thenReturn(fakeMembership);

      final finder = find.ancestor(
        of: find.text(fakeMembership.group.name),
        matching: find.byType(GroupDetailHero),
      );

      expect(finder, findsOneWidget);
    });
  });

  group('bottom sheet', () {
    setUp(() {
      userIsLoggedIn();
    });

    testWidgets('shows bottom sheet when more icon button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(MoreIconButton),
        warnIfMissed: false,
      );

      await tester.pump();

      expect(find.byType(BottomSheet), findsOneWidget);

      await testUtil.closeBottomSheetOrDialog(tester);

      expect(find.byType(BottomSheet), findsNothing);
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

      await loadProductList(tester: tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows empty state when empty list is added to sink',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadProductList(tester: tester, isEmpty: true);

      expect(find.byType(GroupDetailProductsEmptyState), findsOneWidget);
    });

    testWidgets(
        'does NOT show empty state when list with items is added to sink',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await loadProductList(tester: tester);

      expect(find.byType(GroupDetailProductsEmptyState), findsNothing);
    });
  });

  group('handles user authentication', () {
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
