import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:giv_flutter/features/phone_verification/bloc/phone_verification_bloc.dart';
import 'package:giv_flutter/model/user/user.dart' as GivUser;
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  PhoneVerificationBloc bloc;
  MockFirebaseAuth mockFirebaseAuth;
  MockPhoneVerificationStatusPublishSubject
      mockPhoneVerificationStatusPublishSubject;
  MockUserRepository mockUserRepository;
  MockDiskStorageProvider mockDiskStorageProvider;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockPhoneVerificationStatusPublishSubject =
        MockPhoneVerificationStatusPublishSubject();
    mockUserRepository = MockUserRepository();
    mockDiskStorageProvider = MockDiskStorageProvider();
    bloc = PhoneVerificationBloc(
      firebaseAuth: mockFirebaseAuth,
      verificationStatusSubject: mockPhoneVerificationStatusPublishSubject,
      userRepository: mockUserRepository,
      diskStorage: mockDiskStorageProvider,
    );
  });

  tearDown(() {
    mockPhoneVerificationStatusPublishSubject.close();
  });

  group('verifyPhoneNumber', () {
    test('calls firebaseAuth.verifyPhoneNumber with phone number', () async {
      // Given
      final countryCode = '55';
      final phoneNumber = '61981178512';

      // When
      await bloc.verifyPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      // Then
      final fullPhoneNumber = '+$countryCode$phoneNumber';

      verify(
        mockFirebaseAuth.verifyPhoneNumber(
          phoneNumber: '$fullPhoneNumber',
          timeout: PhoneVerificationBloc.codeAutoRetrievalTimeoutTime,
          verificationCompleted: bloc.onVerificationCompleted,
          verificationFailed: bloc.onVerificationFailed,
          codeSent: bloc.onCodeSent,
          codeAutoRetrievalTimeout: bloc.onCodeAutoRetrievalTimeout,
          forceResendingToken: null,
        ),
      ).called(1);
    });
  });

  group('onVerificationCompleted', () {
    test('sends update user request on verification completed ', () async {
      // Given
      final countryCode = '55';
      final phoneNumber = '61981178512';

      await bloc.verifyPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      // When
      bloc.onVerificationCompleted(MockAuthCredential());

      // Then
      verify(mockUserRepository.updateMe({
        GivUser.User.countryCallingCodeKey: countryCode,
        GivUser.User.phoneNumberKey: phoneNumber,
        GivUser.User.isPhoneVerifiedKey: true,
      })).called(1);
    });
  });

  group('onCodeAutoRetrievalTimeout', () {
    test('adds correct status to stream', () {
      // When
      bloc.onCodeAutoRetrievalTimeout('anyVerificationId');

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.codeAutoRetrievalTimeout,
      )).called(1);
    });
  });

  group('onCodeSent', () {
    test('adds correct status to stream', () {
      // When
      bloc.onCodeSent('anyVerificationId', 0);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.codeSent,
      )).called(1);
    });
  });

  group('onChangedNumberButtonTapped', () {
    test('adds userWantsToChangeNumber status to stream', () {
      // When
      bloc.onChangedNumberButtonTapped();

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.userWantsToChangeNumber,
      )).called(1);
    });
  });

  group('onManuallyEnterCodeButtonTapped', () {
    test('adds codeAutoRetrievalTimeout status to stream', () {
      // When
      bloc.onManuallyEnterCodeButtonTapped();

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.codeAutoRetrievalTimeout,
      )).called(1);
    });
  });

  group('onVerificationFailed', () {
    test(
        'adds codeNotSentUnknownError status to stream when error code is not handled',
        () {
      // Given
      final authException = FirebaseAuthException(
        code: 'unKnownCode',
        message: 'any message',
      );

      // When
      bloc.onVerificationFailed(authException);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.codeNotSentUnknownError,
      )).called(1);
    });

    test(
        'adds codeNotSentQuotaExceeded status to stream when error code is quotaExceded',
        () {
      // Given
      final authException = FirebaseAuthException(
        code: 'quotaExceded',
        message: 'any message',
      );

      // When
      bloc.onVerificationFailed(authException);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.codeNotSentQuotaExceeded,
      )).called(1);
    });
  });

  group('resendCode', () {
    test('calls firebaseAuth with forceResendingToken', () async {
      // Given
      // // First verification attempt
      final countryCode = '55';
      final phoneNumber = '61981178512';

      await bloc.verifyPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      // // Code was sent
      final forceResendingToken = 185099742;
      bloc.onCodeSent('anyVerificationId', forceResendingToken);

      // When
      // // User requests a code resent
      bloc.resendCode();

      // Then
      final fullPhoneNumber = '+$countryCode$phoneNumber';

      verify(
        mockFirebaseAuth.verifyPhoneNumber(
          phoneNumber: '$fullPhoneNumber',
          timeout: PhoneVerificationBloc.codeAutoRetrievalTimeoutTime,
          verificationCompleted: bloc.onVerificationCompleted,
          verificationFailed: bloc.onVerificationFailed,
          codeSent: bloc.onCodeSent,
          codeAutoRetrievalTimeout: bloc.onCodeAutoRetrievalTimeout,
          forceResendingToken: forceResendingToken,
        ),
      ).called(1);
    });

    test('adds resendingCode status to stream', () async {
      // Given
      // // First verification attempt
      final countryCode = '55';
      final phoneNumber = '61981178512';

      await bloc.verifyPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      // // Code was sent
      final forceResendingToken = 185099742;
      bloc.onCodeSent('anyVerificationId', forceResendingToken);

      // When
      // // User requests a code resent
      bloc.resendCode();

      // Then
      // // resendingCode status is added to stream
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.resendingCode,
      )).called(1);

      // // sendingCode status is not added again.
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.sendingCode,
      )).called(1);
    });
  });

  group('validateCode', () {
    String smsCode;
    String verificationId;

    setUp(() async {
      // Given
      smsCode = '123456';
      verificationId = 'someVerificationId';
      await bloc.onCodeSent(verificationId);
    });

    test('adds verificationInProgress status to stream', () async {
      // When
      await bloc.validateCode(smsCode);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.verificationInProgress,
      )).called(1);
    });

    test('calls firebaseAuth signInWithCredential', () async {
      // When
      await bloc.validateCode(smsCode);

      // Then
      verify(mockFirebaseAuth.signInWithCredential(any));
    });

    test(
        'sends update user request when firebaseAuth signInWithCredential returns a user',
        () async {
      // Given
      final countryCode = '55';
      final phoneNumber = '61981178512';

      await bloc.verifyPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => MockUserCredential());

      // When
      await bloc.validateCode(smsCode);

      // Then
      verify(mockUserRepository.updateMe({
        GivUser.User.countryCallingCodeKey: countryCode,
        GivUser.User.phoneNumberKey: phoneNumber,
        GivUser.User.isPhoneVerifiedKey: true,
      })).called(1);
    });

    test(
        'adds verificationFailedUnknownError status to stream when firebaseAuth signInWithCredential doesn\'t return a user',
        () async {
      // Given
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => null);

      // When
      await bloc.validateCode(smsCode);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.verificationFailedUnknownError,
      )).called(1);
    });

    test(
        'adds verificationFailedInvalidCode status to stream when firebaseAuth signInWithCredential throws Platform error with code  ERROR_INVALID_VERIFICATION_CODE',
        () async {
      // Given
      when(mockFirebaseAuth.signInWithCredential(any)).thenThrow(
        PlatformException(
          code: 'ERROR_INVALID_VERIFICATION_CODE',
        ),
      );

      // When
      await bloc.validateCode(smsCode);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.verificationFailedInvalidCode,
      )).called(1);

      verifyNever(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.verificationFailedUnknownError,
      ));
    });

    test(
        'adds verificationFailedUnknownError status to stream when firebaseAuth signInWithCredential throws a generic error',
        () async {
      // Given
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenThrow('generic error message here');

      // When
      await bloc.validateCode(smsCode);

      // Then
      verify(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.verificationFailedUnknownError,
      )).called(1);

      verifyNever(mockPhoneVerificationStatusPublishSubject.add(
        PhoneVerificationStatus.verificationFailedInvalidCode,
      ));
    });
  });

  group('updateUser', () {
    final countryCode = '55';
    final phoneNumber = '61981178512';

    setUp(() async {
      await bloc.verifyPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      when(mockDiskStorageProvider.setUser(any)).thenAnswer((_) async => true);
    });

    test('calls user repository with correct arguments', () async {
      // When
      await bloc.updateUser();

      // Then
      verify(mockUserRepository.updateMe({
        GivUser.User.countryCallingCodeKey: countryCode,
        GivUser.User.phoneNumberKey: phoneNumber,
        GivUser.User.isPhoneVerifiedKey: true,
      })).called(1);
    });

    test(
        'adds verificationComplete status to sink when repository call succeeds',
        () async {
      // Given
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<GivUser.User>(
                status: HttpStatus.ok,
                data: GivUser.User.fake(),
              ));

      // When
      await bloc.updateUser();

      // Then
      final status =
          verify(mockPhoneVerificationStatusPublishSubject.add(captureAny))
              .captured
              .last;

      expect(status, PhoneVerificationStatus.verificationCompleted);
    });

    test('saves user to disk storage when repository call succeeds', () async {
      // Given
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<GivUser.User>(
                status: HttpStatus.ok,
                data: GivUser.User.fake(),
              ));

      // When
      await bloc.updateUser();

      // Then
      verify(mockDiskStorageProvider.setUser(any)).called(1);
    });

    test('doesn\'t save user to disk storage when repository call fails',
        () async {
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<GivUser.User>(
                status: HttpStatus.unauthorized,
                data: null,
              ));

      await bloc.updateUser();

      verifyNever(mockDiskStorageProvider.setUser(any));
    });

    test(
        'adds verificationFailedUnknownError status to sink when repository call fails',
        () async {
      // Given
      when(mockUserRepository.updateMe(any))
          .thenAnswer((_) async => HttpResponse<GivUser.User>(
                status: HttpStatus.unauthorized,
                data: null,
              ));

      // When
      await bloc.updateUser();

      // Then
      final status =
          verify(mockPhoneVerificationStatusPublishSubject.add(captureAny))
              .captured
              .last;

      expect(status, PhoneVerificationStatus.verificationFailedUnknownError);
    });

    test(
        'adds verificationFailedUnknownError status to sink when repository call throws',
        () async {
      // Given
      when(mockUserRepository.updateMe(any)).thenThrow('throwable');

      // When
      await bloc.updateUser();

      // Then
      final status =
          verify(mockPhoneVerificationStatusPublishSubject.add(captureAny))
              .captured
              .last;

      expect(status, PhoneVerificationStatus.verificationFailedUnknownError);
    });
  });
}
