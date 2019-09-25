import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/log_in/ui/log_in.dart';
import 'package:giv_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:giv_flutter/features/sign_up/ui/sign_up.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
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
  PublishSubject<HttpResponse<ApiResponse>> apiResponseSubject;
  Finder emailField;
  Finder nameField;
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
      subject: SignUp(
        bloc: mockSignUpBloc,
      ),
      dependencies: [
        Provider<LogInBloc>(
          builder: (_) => mockLoginBloc,
        ),
        Provider<SignUpBloc>(
          builder: (_) => mockSignUpBloc,
        ),
        Provider<Util>(
          builder: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [
        mockNavigatorObserver,
      ],
    );

    apiResponseSubject = PublishSubject<HttpResponse<ApiResponse>>();
    when(mockSignUpBloc.responseStream)
        .thenAnswer((_) => apiResponseSubject.stream);

    nameField = find.byType(NameFormField);
    emailField = find.byType(EmailFormField);
    passwordField = find.byType(PasswordFormField);
    submitButton = find.byType(SubmitSignUpButton);
    passwordVisibilityToggle = find.byType(PasswordVisibilityToggle);
  });

  tearDown(() {
    apiResponseSubject.close();
  });

  group('validates fields before attempting login', () {
    testWidgets(
      'attempts sign up if form input valid',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        const String name = 'Test User';
        const String email = 'test@test.com';
        const String password = 'qwertyuiop';

        await tester.enterText(nameField, name);
        await tester.enterText(emailField, email);
        await tester.enterText(passwordField, password);
        await tester.tap(submitButton);

        verify(mockSignUpBloc.signUp(any)).called(1);
      },
    );

    testWidgets(
      'does not attempt sign up if form input is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        await tester.tap(submitButton);

        verifyNever(mockSignUpBloc.signUp(any));
      },
    );

    group('validates name', () {
      testWidgets(
        'does not attempt sign up if name is empty',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = '';
          const String email = 'test.com';
          const String password = 'qwertyuiop';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );

      testWidgets(
        'does not attempt sign up if name is only white spaces',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = '                ';
          const String email = 'test.com';
          const String password = 'qwertyuiop';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );
    });

    group('validates email', () {
      testWidgets(
        'does not attempt sign up if email is not a valid email',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = 'Test User';
          const String email = 'test.com';
          const String password = 'qwertyuiop';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );

      testWidgets(
        'does not attempt sign up if email is empty',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = 'Test User';
          const String email = '';
          const String password = 'qwertyuiop';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );

      testWidgets(
        'does not attempt sign up if email is only white spaces',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = 'TestUser';
          const String email = '               ';
          const String password = 'qwertyuiop';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );
    });

    group('validates password', () {
      testWidgets(
        'does not attempt sign up if password is too short',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = 'Test User';
          const String email = 'test@test.com';
          const String password = '123';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );

      testWidgets(
        'does not attempt sign up if password is empty',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = 'Test User';
          const String email = 'test@test.com';
          const String password = '';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );

      testWidgets(
        'does not attempt sign up if password is only white spaces',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = 'TestUser';
          const String email = 'test@test.com';
          const String password = '               ';

          await tester.enterText(nameField, name);
          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          verifyNever(mockSignUpBloc.signUp(any));
        },
      );
    });
  });

  group('shows validation messages', () {
    group('shows name validation messages', () {
      testWidgets(
        'shows invalid name message if name is empty',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = '';

          await tester.enterText(nameField, name);
          await tester.tap(submitButton);

          await tester.pumpAndSettle();

          final Finder errorMessage = testUtil
              .findInternationalizedText('validation_message_name_required');

          expect(errorMessage, findsOneWidget);
        },
      );

      testWidgets(
        'shows invalid name message if name has only whitespaces',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String name = '                 ';

          await tester.enterText(nameField, name);
          await tester.tap(submitButton);

          await tester.pumpAndSettle();

          final Finder errorMessage = testUtil
              .findInternationalizedText('validation_message_name_required');

          expect(errorMessage, findsOneWidget);
        },
      );
    });

    group('shows email validation messages', () {
      testWidgets(
        'shows invalid email error message',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String email = 'invalid email';

          await tester.enterText(emailField, email);
          await tester.tap(submitButton);

          await tester.pumpAndSettle();

          final Finder errorMessage = testUtil
              .findInternationalizedText('validation_message_email_required');

          expect(errorMessage, findsOneWidget);
        },
      );

      testWidgets(
        'shows invalid email error message for empty emails',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String email = '';

          await tester.enterText(emailField, email);
          await tester.tap(submitButton);

          await tester.pumpAndSettle();

          final Finder errorMessage = testUtil
              .findInternationalizedText('validation_message_email_required');

          expect(errorMessage, findsOneWidget);
        },
      );
    });

    group('shows password validation messages', () {
      testWidgets(
        'shows password too short message',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String password = '123';

          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          await tester.pumpAndSettle();

          final Finder errorMessage = testUtil.findInternationalizedText(
              'validation_message_password_min_length');

          expect(errorMessage, findsOneWidget);
        },
      );

      testWidgets(
        'shows invalid password message',
        (WidgetTester tester) async {
          await tester.pumpWidget(testableWidget);

          const String email = 'test@test.com';
          const String password = '          ';

          await tester.enterText(emailField, email);
          await tester.enterText(passwordField, password);
          await tester.tap(submitButton);

          await tester.pumpAndSettle();

          final Finder errorMessage = testUtil.findInternationalizedText(
              'validation_message_password_not_only_whitspaces');

          expect(errorMessage, findsOneWidget);
        },
      );
    });
  });

  group('toggles password visibility', () {
    testWidgets('toggles password visibility icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(VisibilityOffIcon), findsOneWidget);
      expect(find.byType(VisibilityIcon), findsNothing);

      await tester.tap(passwordVisibilityToggle);

      await tester.pumpAndSettle();

      expect(find.byType(VisibilityIcon), findsOneWidget);
      expect(find.byType(VisibilityOffIcon), findsNothing);
    });
  });

  group('navigates as expected', () {
    testWidgets('navigates to log in page', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(SignUpAlreadyHaveAnAccountWidget));

      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPush(any, any));
      expect(find.byType(LogIn), findsOneWidget);
    });
  });

  group('handles stream events', () {
    testWidgets('shows circular progress inidicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      apiResponseSubject.sink
          .add(HttpResponse<ApiResponse>(state: StreamEventState.loading));

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to success screen on login success',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      apiResponseSubject.sink.add(HttpResponse<ApiResponse>(
          data: ApiResponse.fake(), status: HttpStatus.created));

      await tester.pump(Duration.zero);

      verify(mockNavigatorObserver.didPush(any, any));
    });

    testWidgets(
      'shows account taken alert dialog when response status code is 409',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        apiResponseSubject.sink.add(
            HttpResponse<ApiResponse>(data: null, status: HttpStatus.conflict));

        await tester.pump(Duration.zero);

        final Finder dialog = find.byType(AlertDialog);
        final Finder content =
            testUtil.findInternationalizedText('sign_up_error_409_messge');
        expect(find.descendant(of: dialog, matching: content), findsOneWidget);
      },
    );

    testWidgets(
      'shows alert dialog when response status code is other than 201 or 409',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        apiResponseSubject.sink.add(HttpResponse<ApiResponse>(
            data: null, status: HttpStatus.badRequest));

        await tester.pump(Duration.zero);

        final Finder dialog = find.byType(AlertDialog);
        final Finder content =
            testUtil.findInternationalizedText('error_generic_message');
        expect(find.descendant(of: dialog, matching: content), findsOneWidget);
      },
    );
  });
}
