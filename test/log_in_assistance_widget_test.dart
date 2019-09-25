import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/ui/log_in_assistance.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockLoginBloc mockLoginBloc;
  MockNavigatorObserver mockNavigatorObserver;
  Widget testableWidget;
  TestUtil testUtil;
  Finder emailField;
  Finder submitButton;
  PublishSubject<HttpResponse<ApiResponse>> apiResponseSubject;

  setUp(() {
    testUtil = TestUtil();
    mockLoginBloc = MockLoginBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    emailField = find.byType(EmailFormField);
    submitButton = find.byType(SubmitButton);
    apiResponseSubject = PublishSubject<HttpResponse<ApiResponse>>();

    when(mockLoginBloc.loginAssistanceStream)
        .thenAnswer((_) => apiResponseSubject.stream);
  });

  Widget makeTestableWidget(LoginAssistancePage page) =>
      testUtil.makeTestableWidget(
        subject: LoginAssistance(
          bloc: mockLoginBloc,
          page: page,
        ),
        dependencies: [
          Provider<LogInBloc>(
            builder: (_) => mockLoginBloc,
          ),
          Provider<Util>(
            builder: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  tearDown(() {
    reset(mockNavigatorObserver);
    reset(mockLoginBloc);
  });

  group('displays correct information', () {
    testWidgets('displays correct title', (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      expect(find.text(page.title), findsOneWidget);
    });

    testWidgets('displays correct instructions', (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      expect(find.text(page.instructions), findsOneWidget);
    });
  });

  group('validates fields before attempting to submit', () {
    testWidgets('doesn\'t submit if email is empty',
        (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      await tester.tap(submitButton);

      verifyNever(mockLoginBloc.resendActivation(any));
      verifyNever(mockLoginBloc.forgotPassword(any));
    });

    testWidgets('doesn\'t submit if email is not valid',
        (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      await tester.enterText(emailField, 'test.com');

      await tester.tap(submitButton);

      verifyNever(mockLoginBloc.resendActivation(any));
      verifyNever(mockLoginBloc.forgotPassword(any));
    });

    testWidgets('submits forgotPassword request if email is valid',
        (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      await tester.enterText(emailField, 'test@test.com');

      await tester.tap(submitButton);

      verifyNever(mockLoginBloc.resendActivation(any));
      verify(mockLoginBloc.forgotPassword(any)).called(1);
    });

    testWidgets('submits resendActivation request if email is valid',
        (WidgetTester tester) async {
      final page =
          LoginAssistancePage.fake(LoginAssistanceType.resendActivation);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      await tester.enterText(emailField, 'test@test.com');

      await tester.tap(submitButton);

      verifyNever(mockLoginBloc.forgotPassword(any));
      verify(mockLoginBloc.resendActivation(any)).called(1);
    });
  });

  group('shows validation messages', () {
    testWidgets('shows invalid email error message',
        (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      final Finder errorMessage = testUtil
          .findInternationalizedText('validation_message_email_required');

      expect(errorMessage, findsOneWidget);
    });
  });

  group('handles stream events', () {
    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      apiResponseSubject.sink
          .add(HttpResponse<ApiResponse>(state: StreamEventState.loading));

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to success screen', (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      apiResponseSubject.sink.add(HttpResponse<ApiResponse>(
          status: HttpStatus.ok, data: ApiResponse.fake()));

      await tester.pump(Duration.zero);

      verify(mockNavigatorObserver.didPush(any, any));
    });

    testWidgets('shows alert dialog when forgot password request fails',
        (WidgetTester tester) async {
      final page = LoginAssistancePage.fake(LoginAssistanceType.forgotPassword);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      apiResponseSubject.sink.add(
          HttpResponse<ApiResponse>(status: HttpStatus.notFound, data: null));

      await tester.pump(Duration.zero);

      final Finder dialog = find.byType(AlertDialog);
      final Finder content = testUtil
          .findInternationalizedText('login_assistance_email_not_found_title');
      expect(find.descendant(of: dialog, matching: content), findsOneWidget);
    });

    testWidgets('shows alert dialog when resend activation request fails',
        (WidgetTester tester) async {
      final page =
          LoginAssistancePage.fake(LoginAssistanceType.resendActivation);

      testableWidget = makeTestableWidget(page);

      await tester.pumpWidget(testableWidget);

      apiResponseSubject.sink.add(
          HttpResponse<ApiResponse>(status: HttpStatus.notFound, data: null));

      await tester.pump(Duration.zero);

      final Finder dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
    });
  });

  tearDownAll((){
    apiResponseSubject.close();
  });
}
