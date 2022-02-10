import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/log_in/ui/log_in_assistance.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/authenticated_user_updated_action.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/form/email_form_field.dart';
import 'package:giv_flutter/util/form/password_form_field.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockLoginBloc mockLoginBloc;
  MockSignUpBloc mockSignUpBloc;
  MockNavigatorObserver mockNavigatorObserver;
  Widget testableWidget;
  PublishSubject<HttpResponse<LogInResponse>> loginSubject;
  Finder emailField;
  Finder passwordField;
  Finder submitButton;
  Finder passwordVisibilityToggle;
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
    mockLoginBloc = MockLoginBloc();
    mockSignUpBloc = MockSignUpBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    testableWidget = testUtil.makeTestableWidget(
      subject: LogIn(
        bloc: mockLoginBloc,
      ),
      dependencies: [
        Provider<LogInBloc>(
          create: (_) => mockLoginBloc,
        ),
        Provider<SignUpBloc>(
          create: (_) => mockSignUpBloc,
        ),
        Provider<HomeBloc>(
          create: (_) => MockHomeBloc(),
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
        ChangeNotifierProvider<AuthUserUpdatedAction>(
          create: (context) => AuthUserUpdatedAction(),
        ),
      ],
      navigatorObservers: [
        mockNavigatorObserver,
      ],
    );

    loginSubject = PublishSubject<HttpResponse<LogInResponse>>();

    when(mockLoginBloc.loginResponseStream)
        .thenAnswer((_) => loginSubject.stream);

    emailField = find.byType(EmailFormField);
    passwordField = find.byType(PasswordFormField);
    submitButton = find.byType(SubmitLogInButton);
    passwordVisibilityToggle = find.byType(PasswordVisibilityToggle);
  });

  tearDown(() {
    loginSubject.close();
    reset(mockNavigatorObserver);
  });

  group('validates fields before attempting login', () {
    testWidgets(
      'attempts login if email and password are valid',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        const String email = 'test@test.com';
        const String password = 'qwertyuiop';

        await tester.enterText(emailField, email);
        await tester.enterText(passwordField, password);
        await tester.tap(
          submitButton,
          warnIfMissed: false,
        );

        verify(mockLoginBloc.login(any)).called(1);
      },
    );

    testWidgets(
      'does not attempt login if email is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        await tester.enterText(passwordField, 'qwertyuiop');
        await tester.tap(
          submitButton,
          warnIfMissed: false,
        );

        verifyNever(mockLoginBloc.login(any));
      },
    );

    testWidgets(
      'does not attempt login if password is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        await tester.enterText(emailField, 'test@test.com');
        await tester.tap(
          submitButton,
          warnIfMissed: false,
        );

        verifyNever(mockLoginBloc.login(any));
      },
    );

    testWidgets(
      'does not attempt login if email is not a valid email',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        const String email = 'invalid email';
        const String password = 'qwertyuiop';

        await tester.enterText(emailField, email);
        await tester.enterText(passwordField, password);
        await tester.tap(
          submitButton,
          warnIfMissed: false,
        );

        verifyNever(mockLoginBloc.login(any));
      },
    );

    testWidgets(
      'attempts login even if password is too short',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        const String email = 'test@test.com';
        const String password = '1';

        await tester.enterText(emailField, email);
        await tester.enterText(passwordField, password);
        await tester.tap(
          submitButton,
          warnIfMissed: false,
        );

        verify(mockLoginBloc.login(any)).called(1);
      },
    );
  });

  group('shows validation messages', () {
    testWidgets('shows invalid email error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'invalid email';
      const String password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(
        submitButton,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      final Finder errorMessage = testUtil
          .findInternationalizedText('validation_message_email_required');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows invalid email error message for empty emails',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = '';
      const String password = 'qwertyuiop';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(
        submitButton,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      final Finder errorMessage = testUtil
          .findInternationalizedText('validation_message_email_required');

      expect(errorMessage, findsOneWidget);
    });

    testWidgets('shows required field message for empty passwords',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      const String email = 'test@test.com';
      const String password = '';

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(
        submitButton,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      final Finder errorMessage =
          testUtil.findInternationalizedText('validation_message_required');

      expect(errorMessage, findsOneWidget);
    });
  });

  group('toggles password visibility', () {
    testWidgets('toggles password visibility icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(VisibilityOffIcon), findsOneWidget);
      expect(find.byType(VisibilityIcon), findsNothing);

      await tester.tap(
        passwordVisibilityToggle,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      expect(find.byType(VisibilityIcon), findsOneWidget);
      expect(find.byType(VisibilityOffIcon), findsNothing);
    });
  });

  group('navigates as expected', () {
    testWidgets('navigates to forgot password page',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(ForgotPasswordButton),
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPush(any, any));
      expect(find.byType(LoginAssistance), findsOneWidget);
    });

    testWidgets('navigates to resend email page', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(ResendEmailButton),
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPush(any, any));
      expect(find.byType(LoginAssistance), findsOneWidget);
    });

    testWidgets('navigates to sign up page', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(LogInDontHaveAnAccountWidget),
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPush(any, any));
      expect(find.byType(SignUp), findsOneWidget);
    });
  });

  group('handles stream events', () {
    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      loginSubject.sink
          .add(HttpResponse<LogInResponse>(state: StreamEventState.loading));

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to base screen on login success',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      loginSubject.sink.add(HttpResponse<LogInResponse>(
          data: LogInResponse.fake(), status: HttpStatus.ok));

      await tester.pump(Duration.zero);

      verify(mockNavigatorObserver.didPush(any, any));
    });

    testWidgets(
      'shows bad credentials alert dialog when response status code is 422',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        loginSubject.sink.add(HttpResponse<LogInResponse>(
            data: null, status: HttpStatus.unprocessableEntity));

        await tester.pump(Duration.zero);

        expect(
          testUtil.findDialogByContent('log_in_error_bad_credentials_title'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows account not ativated dialog when response status code is 406',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        loginSubject.sink.add(HttpResponse<LogInResponse>(
            data: null, status: HttpStatus.notAcceptable));

        await tester.pump(Duration.zero);

        expect(
          testUtil.findDialogByContent('log_in_error_not_activated_title'),
          findsOneWidget,
        );
      },
    );
  });
}
