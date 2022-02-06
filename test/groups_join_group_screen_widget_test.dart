import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/groups/join_group/bloc/join_group_bloc.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_access_code_input.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_get_more_info_row.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_screen.dart';
import 'package:giv_flutter/features/groups/join_group/ui/join_group_try_again_button.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
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
  MockJoinGroupBloc mockJoinGroupBloc;
  PublishSubject<HttpResponse<GroupMembership>> membershipHttpResponseSubject;

  setUp(() {
    testUtil = TestUtil();
    mockJoinGroupBloc = MockJoinGroupBloc();
    testableWidget = testUtil.makeTestableWidget(
        subject: JoinGroupScreen(bloc: mockJoinGroupBloc),
        dependencies: [
          Provider<JoinGroupBloc>(
            create: (_) => mockJoinGroupBloc,
          ),
          Provider<LogInBloc>(
            create: (_) => MockLoginBloc(),
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          )
        ]);

    membershipHttpResponseSubject =
        PublishSubject<HttpResponse<GroupMembership>>();

    when(mockJoinGroupBloc.groupMembershipStream)
        .thenAnswer((_) => membershipHttpResponseSubject.stream);
  });

  tearDown(() {
    membershipHttpResponseSubject.close();
  });

  // ignore: unused_element
  Future<void> fillInCodeInput(WidgetTester tester, String token) async {
    final finder = find.byType(JoinGroupAccessCodeInput);
    await tester.enterText(finder, token);

    // Allow some time for auto disposal of PinCodeTextField _textEditingController and _focusNode?
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  group('ui', () {
    setUp(() {
      when(mockJoinGroupBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(JoinGroupScreen), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.ancestor(
          of: testUtil.findInternationalizedText('join_group_screen_title'),
          matching: find.byType(CustomAppBar));

      expect(finder, findsOneWidget);
    });

    testWidgets('has an access code input', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.byType(JoinGroupAccessCodeInput);

      expect(finder, findsOneWidget);
    });

    testWidgets('has an get more info row', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.byType(JoinGroupGetMoreInfoRow);

      expect(finder, findsOneWidget);
    });

    testWidgets('shows bottom sheet when GetMoreInfoRow is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(JoinGroupGetMoreInfoRow));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      await testUtil.closeBottomSheetOrDialog(tester);

      expect(find.byType(BottomSheet), findsNothing);
    });
  });

  group('access code input', () {
    setUp(() {
      when(mockJoinGroupBloc.getUser()).thenReturn(User.fake());
    });

    // testWidgets('sends join group request when field is filled in',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(testableWidget);
    //   final token = '1234';

    //   // When
    //   await fillInCodeInput(tester, token);

    //   // Then
    //   final capturedRequest =
    //       verify(mockJoinGroupBloc.joinGroup(captureAny)).captured.last;

    //   expect(capturedRequest.accessToken, token);
    // });
  });

  group('handles stream events', () {
    setUp(() {
      // User is be logged in
      when(mockJoinGroupBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      membershipHttpResponseSubject.sink.add(HttpResponse.loading());

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows group not found dialog when group is not found',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      membershipHttpResponseSubject.sink.add(HttpResponse<GroupMembership>(
        data: null,
        status: HttpStatus.notFound,
      ));

      await tester.pump(Duration.zero);

      // Then
      expect(
        testUtil.findDialogByContent('join_group_screen_group_not_found_title'),
        findsOneWidget,
      );
    });

    testWidgets('shows already a member dialog when user is already a member',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      membershipHttpResponseSubject.sink.add(HttpResponse<GroupMembership>(
        data: null,
        status: HttpStatus.conflict,
      ));

      await tester.pump(Duration.zero);

      // Then
      expect(
        testUtil.findDialogByContent(
            'join_group_screen_group_already_a_member_title'),
        findsOneWidget,
      );
    });

    testWidgets('shows generic error dialog when http error is unknown',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      membershipHttpResponseSubject.sink.add(HttpResponse<GroupMembership>(
        data: null,
        status: HttpStatus.unprocessableEntity,
      ));

      await tester.pump(Duration.zero);

      // Then
      expect(find.byType(GenericErrorDialog), findsOneWidget);
    });

    testWidgets('shows generic error dialog on any unknown error',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      membershipHttpResponseSubject.sink.addError('some error');

      await tester.pump(Duration.zero);

      // Then
      expect(find.byType(GenericErrorDialog), findsOneWidget);
    });
  });

  group('try again button', () {
    setUp(() {
      // User is be logged in
      when(mockJoinGroupBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('try again button is not intially visible',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(JoinGroupTryAgainButton), findsNothing);
    });

    testWidgets('after generic error, try again button is visible',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      membershipHttpResponseSubject.sink.addError('some error');

      await tester.pump(Duration.zero);

      // Then
      expect(find.byType(GenericErrorDialog), findsOneWidget);
      expect(find.byType(JoinGroupTryAgainButton), findsOneWidget);
    });

    testWidgets('try again button resends request',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      membershipHttpResponseSubject.sink.addError('some error');

      await tester.pump(Duration.zero);

      // Then
      final button = find.byType(JoinGroupTryAgainButton);
      expect(button, findsOneWidget);

      // When
      await testUtil.closeBottomSheetOrDialog(tester);
      await tester.tap(button);

      // Then
      verify(mockJoinGroupBloc.joinGroup(any));
    });
  });

  group('handles user authentication', () {
    testWidgets('redirects to sign in screen if user is not authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockJoinGroupBloc.getUser()).thenReturn(null);

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsOneWidget);
    });

    testWidgets('does not redirect to sign in screen if user is authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockJoinGroupBloc.getUser()).thenReturn(User.fake());

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsNothing);
    });
  });
}
