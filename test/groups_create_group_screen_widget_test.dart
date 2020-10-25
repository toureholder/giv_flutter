import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/groups/create_group/bloc/create_group_bloc.dart';
import 'package:giv_flutter/features/groups/create_group/ui/create_group_form.dart';
import 'package:giv_flutter/features/groups/create_group/ui/create_group_sceen.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/form/custom_text_form_field.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  TestUtil testUtil;
  MockCreateGroupBloc mockCreateGroupBloc;
  PublishSubject<HttpResponse<Group>> groupHttpResponseSubject;

  setUp(() {
    testUtil = TestUtil();
    mockCreateGroupBloc = MockCreateGroupBloc();
    testableWidget = testUtil.makeTestableWidget(
        subject: CreateGroupScreen(bloc: mockCreateGroupBloc),
        dependencies: [
          Provider<CreateGroupBloc>(
            create: (_) => mockCreateGroupBloc,
          ),
          Provider<LogInBloc>(
            create: (_) => MockLoginBloc(),
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          )
        ]);

    groupHttpResponseSubject = PublishSubject<HttpResponse<Group>>();

    when(mockCreateGroupBloc.groupStream)
        .thenAnswer((_) => groupHttpResponseSubject.stream);
  });

  tearDown(() {
    groupHttpResponseSubject.close();
  });

  group('ui', () {
    setUp(() {
      when(mockCreateGroupBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(CreateGroupScreen), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.ancestor(
          of: testUtil.findInternationalizedText('create_group_screen_title'),
          matching: find.byType(CustomAppBar));

      expect(finder, findsOneWidget);
    });

    testWidgets('has a form', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(CreateGroupForm), findsOneWidget);
    });
  });

  group('form submission', () {
    setUp(() {
      when(mockCreateGroupBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('sends create group request if form is valid',
        (WidgetTester tester) async {
      final groupName = 'My shiny new group';
      await tester.pumpWidget(testableWidget);

      final textField = find.byType(CustomTextFormField);
      final button = find.byType(PrimaryButton);

      await tester.enterText(textField, groupName);
      await tester.tap(button);

      final capturedRequest = verify(
        mockCreateGroupBloc.createGroup(captureAny),
      ).captured.last;

      expect(capturedRequest, isA<CreateGroupRequest>());
      expect(capturedRequest.name, groupName);
    });

    testWidgets('does not send create group request if form is not valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final button = find.byType(PrimaryButton);

      await tester.tap(button);

      verifyNever(mockCreateGroupBloc.createGroup(captureAny));
    });

    testWidgets('shows validation message if form is not valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final button = find.byType(PrimaryButton);

      await tester.tap(button);

      await tester.pumpAndSettle();

      final message = testUtil.findInternationalizedText(
        'validation_message_required',
      );

      expect(message, findsOneWidget);
    });
  });

  group('handles stream events', () {
    setUp(() {
      // User is be logged in
      when(mockCreateGroupBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      groupHttpResponseSubject.sink.add(HttpResponse.loading());

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows generic error dialog when http error is unknown',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(testableWidget);

      groupHttpResponseSubject.sink.add(HttpResponse<Group>(
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

      groupHttpResponseSubject.sink.addError('some error');

      await tester.pump(Duration.zero);

      // Then
      expect(find.byType(GenericErrorDialog), findsOneWidget);
    });
  });

  group('handles user authentication', () {
    testWidgets('redirects to sign in screen if user is not authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockCreateGroupBloc.getUser()).thenReturn(null);

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsOneWidget);
    });

    testWidgets('does not redirect to sign in screen if user is authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockCreateGroupBloc.getUser()).thenReturn(User.fake());

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsNothing);
    });
  });
}
