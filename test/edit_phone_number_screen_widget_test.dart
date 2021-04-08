import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/phone_verification/bloc/phone_verification_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_automatic_code_retrieval.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_input_code.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_input_phone_number.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_resending_code.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_verification_in_progress.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen_state_verification_success.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/shared/change_number_button.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  TestUtil testUtil;
  MockSettingsBloc mockSettingsBloc;
  MockPhoneVerificationBloc mockPhoneVerificationBloc;
  PublishSubject<HttpResponse<User>> userHttpResposnePublishSubject;
  PublishSubject<PhoneVerificationStatus> verificationStatusPublishSubject;
  User fakeUser;

  setUp(() {
    testUtil = TestUtil();
    mockSettingsBloc = MockSettingsBloc();
    mockPhoneVerificationBloc = MockPhoneVerificationBloc();
    fakeUser = User.fake();
    testableWidget = testUtil.makeTestableWidget(
        subject: EditPhoneNumber(
          settingsBloc: mockSettingsBloc,
          phoneVerificationBloc: mockPhoneVerificationBloc,
          user: fakeUser,
        ),
        dependencies: [
          Provider<MockSettingsBloc>(
            create: (_) => mockSettingsBloc,
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ]);

    userHttpResposnePublishSubject = PublishSubject<HttpResponse<User>>();

    verificationStatusPublishSubject =
        PublishSubject<PhoneVerificationStatus>();

    when(mockSettingsBloc.userUpdateStream)
        .thenAnswer((_) => userHttpResposnePublishSubject.stream);

    when(mockPhoneVerificationBloc.verificationStatusStream)
        .thenAnswer((_) => verificationStatusPublishSubject.stream);
  });

  tearDown(() {
    userHttpResposnePublishSubject.close();
    verificationStatusPublishSubject.close();
  });

  Future<void> addStatusToStream(
    WidgetTester tester,
    PhoneVerificationStatus status,
  ) async {
    verificationStatusPublishSubject.sink.add(status);
    await tester.pump(Duration.zero);
  }

  group('ui', () {
    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(EditPhoneNumber), findsOneWidget);
    });

    testWidgets('has title text', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(H6Text), findsOneWidget);
    });
  });

  group('phone verification states', () {
    testWidgets('starts with input phone number screen without loading button',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(EditPhoneNumberStateInputPhoneNumber), findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(EditPhoneNumberVerifyButton),
              matching: find.byType(ButtonProgressIndicator)),
          findsNothing);
    });

    testWidgets(
        'shows input phone number screen with loading button when sendingCode status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.sendingCode);

      expect(find.byType(EditPhoneNumberStateInputPhoneNumber), findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(EditPhoneNumberVerifyButton),
              matching: find.byType(ButtonProgressIndicator)),
          findsOneWidget);
    });

    testWidgets(
        'shows input code state when codeSent status is added to stream and platform is iOS',
        (WidgetTester tester) async {
      when(mockSettingsBloc.platform).thenReturn(TargetPlatform.iOS);

      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.codeSent);

      expect(
        find.byType(EditPhoneNumberScreenStateInputCode),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows input code state state when codeAutoRetrievalTimeout status is added to stream',
        (WidgetTester tester) async {
      when(mockSettingsBloc.platform).thenReturn(TargetPlatform.android);

      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.codeAutoRetrievalTimeout);

      expect(
        find.byType(EditPhoneNumberScreenStateInputCode),
        findsOneWidget,
      );

      expect(
          find.descendant(
              of: find.byType(EditPhoneNumberVerifyButton),
              matching: find.byType(ButtonProgressIndicator)),
          findsNothing);
    });

    testWidgets(
        'shows automatic sms handling state when codeSent status is added to stream and platform is android',
        (WidgetTester tester) async {
      when(mockSettingsBloc.platform).thenReturn(TargetPlatform.android);

      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.codeSent);

      expect(
        find.byType(EditPhoneNumberScreenStateAutomaticCodeRetrieval),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows input number state when userWantsToChangeNumber status is added to stream after auto-retrieval state',
        (WidgetTester tester) async {
      when(mockSettingsBloc.platform).thenReturn(TargetPlatform.android);

      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.codeSent);

      expect(
        find.byType(EditPhoneNumberScreenStateAutomaticCodeRetrieval),
        findsOneWidget,
      );

      await addStatusToStream(
          tester, PhoneVerificationStatus.userWantsToChangeNumber);

      expect(
        find.byType(EditPhoneNumberStateInputPhoneNumber),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows input number state with dialog when codeNotSentQuotaExceded status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.codeNotSentQuotaExceeded);

      expect(
        find.byType(EditPhoneNumberStateInputPhoneNumber),
        findsOneWidget,
      );

      expect(
        testUtil.findDialogByContent(
            'settings_edit_phone_number_code_not_sent_quota_dialog_content'),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows input number state when codeNotSentUnknownError status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.codeNotSentUnknownError);

      expect(
        find.byType(EditPhoneNumberStateInputPhoneNumber),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows verification in progress state when verificationInProgress status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.verificationInProgress);

      expect(
        find.byType(EditPhoneNumberScreenStateVerificationInProgress),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows verification failed because of invalid code state when verificationFailedInvalidCode status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.verificationFailedInvalidCode);

      expect(
        find.byType(EditPhoneNumberScreenStateInputCode),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows verification failed because for unknown reason state when verificationFailedUnknownError status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.verificationFailedUnknownError);

      expect(
        find.byType(EditPhoneNumberScreenStateInputCode),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows resending code state when resendingCode status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.resendingCode);

      expect(
        find.byType(EditPhoneNumberScreenStateResendingCode),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows verificationCompleted state when verificationCompleted status is added to stream',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.verificationCompleted);

      expect(
        find.byType(EditPhoneNumberScreenStateVerificationSuccess),
        findsOneWidget,
      );
    });
  });

  group('input number screen', () {
    testWidgets(
        'calls phone verification bloc phoneVerify when user taps verify button',
        (WidgetTester tester) async {
      // Given
      final input = '61987654321';

      // When
      await tester.pumpWidget(testableWidget);

      final inputFinder = find.byType(EditPhoneNumberFormField);
      final verifyButtonFinder = find.byType(EditPhoneNumberVerifyButton);

      await tester.enterText(inputFinder, input);
      await tester.tap(verifyButtonFinder);

      verify(mockPhoneVerificationBloc.verifyPhoneNumber(
        countryCode: Config.defaultCountryCallingCode,
        phoneNumber: input,
      )).called(1);
    });
  });

  group('auto-retrieval screen', () {
    bringUpAutoRetrievalScreen(WidgetTester tester) async {
      when(mockSettingsBloc.platform).thenReturn(TargetPlatform.android);

      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.codeSent);

      expect(
        find.byType(EditPhoneNumberScreenStateAutomaticCodeRetrieval),
        findsOneWidget,
      );
    }

    testWidgets(
        'clicking on ChangedNumberButton calls verification bloc onChangedNumberButtonTapped',
        (WidgetTester tester) async {
      await bringUpAutoRetrievalScreen(tester);

      await tester.tap(find.byType(ChangedNumberButton));

      verify(mockPhoneVerificationBloc.onChangedNumberButtonTapped()).called(1);
    });

    testWidgets(
        'clicking on ManuallyEnterCodeButton calls verification bloc onManuallyEnterCodeButtonTapped',
        (WidgetTester tester) async {
      await bringUpAutoRetrievalScreen(tester);

      await tester.tap(find.byType(ManuallyEnterCodeButton));

      verify(mockPhoneVerificationBloc.onManuallyEnterCodeButtonTapped())
          .called(1);
    });
  });

  group('input code screen', () {
    bringUpInputCodeScreen(WidgetTester tester) async {
      when(mockSettingsBloc.platform).thenReturn(TargetPlatform.iOS);

      await tester.pumpWidget(testableWidget);

      await addStatusToStream(tester, PhoneVerificationStatus.codeSent);

      expect(
        find.byType(EditPhoneNumberScreenStateInputCode),
        findsOneWidget,
      );
    }

    // Future<void> fillInCodeInput(WidgetTester tester, String code) async {
    //   final finder = find.byType(VerificationCodeInput);
    //   await tester.enterText(finder, code);

    //   // Allow some time for auto disposal of PinCodeTextField _textEditingController and _focusNode?
    //   await tester.pumpAndSettle(const Duration(seconds: 1));
    // }

    testWidgets(
        'clicking on ChangedNumberButton calls verification bloc onChangedNumberButtonTapped',
        (WidgetTester tester) async {
      await bringUpInputCodeScreen(tester);

      await tester.tap(find.byType(ChangedNumberButton));

      verify(mockPhoneVerificationBloc.onChangedNumberButtonTapped()).called(1);
    });

    testWidgets(
        'clicking on ResendCodeButton calls verification bloc resendCode',
        (WidgetTester tester) async {
      await bringUpInputCodeScreen(tester);

      await tester.tap(find.byType(ResendCodeButton));

      verify(mockPhoneVerificationBloc.resendCode()).called(1);
    });

    // testWidgets(
    //     'calls verification bloc validateCode when user inputs 6 digits',
    //     (WidgetTester tester) async {
    //   // Given
    //   await bringUpInputCodeScreen(tester);

    //   await fillInCodeInput(tester, '12345');

    //   verifyNever(mockPhoneVerificationBloc.validateCode(any));

    //   await fillInCodeInput(tester, '123456');

    //   // Then
    //   final capturedArg =
    //       verify(mockPhoneVerificationBloc.validateCode(captureAny))
    //           .captured
    //           .last;

    //   expect(capturedArg, '123456');
    // });
  });

  group('verification complete sceen', () {
    bringUpVerificationCompleteScreen(WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await addStatusToStream(
          tester, PhoneVerificationStatus.verificationCompleted);

      expect(
        find.byType(EditPhoneNumberScreenStateVerificationSuccess),
        findsOneWidget,
      );
    }

    testWidgets('clicking on \'ok\' button closes edit phone number screen ',
        (WidgetTester tester) async {
      await bringUpVerificationCompleteScreen(tester);

      expect(find.byType(EditPhoneNumber), findsOneWidget);

      await tester.tap(
          find.byType(EditPhoneNumberScreenStateVerificationSuccessOkButton));

      await tester.pumpAndSettle();

      expect(find.byType(EditPhoneNumber), findsNothing);
    });
  });
}
