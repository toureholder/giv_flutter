import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class PhoneVerificationBloc {
  final UserRepository userRepository;
  final DiskStorageProvider diskStorage;
  final FirebaseAuth firebaseAuth;
  final PublishSubject<PhoneVerificationStatus> verificationStatusSubject;

  PhoneVerificationBloc({
    @required this.userRepository,
    @required this.diskStorage,
    @required this.firebaseAuth,
    @required this.verificationStatusSubject,
  });

  int _forceResendingToken;
  String _countryCode;
  String _phoneNumber;
  String _fullPhoneNumber;
  String _verificationId;

  Observable<PhoneVerificationStatus> get verificationStatusStream =>
      verificationStatusSubject.stream;

  Future<void> verifyPhoneNumber({
    String countryCode,
    String phoneNumber,
    int forceResendingToken,
  }) async {
    if (countryCode != null && phoneNumber != null) {
      verificationStatusSubject.add(PhoneVerificationStatus.sendingCode);
      _countryCode = countryCode;
      _phoneNumber = phoneNumber;
      _fullPhoneNumber = '+$countryCode$phoneNumber';
    }

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '$_fullPhoneNumber',
      verificationCompleted: onVerificationCompleted,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      timeout: PhoneVerificationBloc.codeAutoRetrievalTimeoutTime,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      forceResendingToken: forceResendingToken,
    );
  }

  void onVerificationCompleted(AuthCredential phoneAuthCredential) async {
    await this.updateUser();
  }

  void onCodeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;

    verificationStatusSubject.add(
      PhoneVerificationStatus.codeAutoRetrievalTimeout,
    );
  }

  Future<void> onCodeSent(String verificationId,
      [int forceResendingToken]) async {
    _verificationId = verificationId;

    verificationStatusSubject.add(PhoneVerificationStatus.codeSent);

    _forceResendingToken = forceResendingToken;
  }

  void onChangedNumberButtonTapped() {
    verificationStatusSubject.add(
      PhoneVerificationStatus.userWantsToChangeNumber,
    );
  }

  void onManuallyEnterCodeButtonTapped() {
    verificationStatusSubject.add(
      PhoneVerificationStatus.codeAutoRetrievalTimeout,
    );
  }

  void onVerificationFailed(AuthException error) {
    print('error.code: ${error.code}');
    print('error.message: ${error.message}');

    final status = error.code == 'quotaExceded'
        ? PhoneVerificationStatus.codeNotSentQuotaExceeded
        : PhoneVerificationStatus.codeNotSentUnknownError;

    verificationStatusSubject.add(status);
  }

  static final codeAutoRetrievalTimeoutTime = Duration(seconds: 30);

  Future<void> resendCode() async {
    verificationStatusSubject.add(PhoneVerificationStatus.resendingCode);
    await this.verifyPhoneNumber(forceResendingToken: _forceResendingToken);
  }

  Future<void> validateCode(String smsCode) async {
    verificationStatusSubject.add(
      PhoneVerificationStatus.verificationInProgress,
    );

    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    try {
      final result = await this.firebaseAuth.signInWithCredential(
            phoneAuthCredential,
          );

      if (result != null) {
        await this.updateUser();
      } else {
        verificationStatusSubject.add(
          PhoneVerificationStatus.verificationFailedUnknownError,
        );
      }
    } catch (e) {
      if (e is PlatformException &&
          e.code == 'ERROR_INVALID_VERIFICATION_CODE') {
        verificationStatusSubject.add(
          PhoneVerificationStatus.verificationFailedInvalidCode,
        );
      } else {
        verificationStatusSubject.add(
          PhoneVerificationStatus.verificationFailedUnknownError,
        );
      }
    }
  }

  Future<void> updateUser() async {
    try {
      var response = await userRepository.updateMe({
        User.countryCallingCodeKey: _countryCode,
        User.phoneNumberKey: _phoneNumber,
        User.isPhoneVerifiedKey: true,
      });

      if (response.data != null) {
        await diskStorage.setUser(response.data);
        verificationStatusSubject.add(
          PhoneVerificationStatus.verificationCompleted,
        );
      } else {
        verificationStatusSubject.add(
          PhoneVerificationStatus.verificationFailedUnknownError,
        );
      }
    } catch (error) {
      verificationStatusSubject.add(
        PhoneVerificationStatus.verificationFailedUnknownError,
      );
    }
  }
}

enum PhoneVerificationStatus {
  sendingCode,
  codeSent,
  codeNotSentQuotaExceeded,
  codeNotSentUnknownError,
  codeAutoRetrievalTimeout,
  userWantsToChangeNumber,
  resendingCode,
  verificationInProgress,
  verificationCompleted,
  verificationFailedInvalidCode,
  verificationFailedUnknownError,
}
