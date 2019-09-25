import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class LogInBloc {
  LogInBloc({
    @required this.userRepository,
    @required this.session,
    @required this.loginPublishSubject,
    @required this.loginAssistancePublishSubject,
    @required this.firebaseAuth,
    @required this.facebookLogin,
  });

  final UserRepository userRepository;
  final SessionProvider session;
  final PublishSubject<HttpResponse<LogInResponse>> loginPublishSubject;
  final PublishSubject<HttpResponse<ApiResponse>> loginAssistancePublishSubject;
  final FirebaseAuth firebaseAuth;
  final FacebookLogin facebookLogin;

  Observable<HttpResponse<LogInResponse>> get loginResponseStream =>
      loginPublishSubject.stream;

  Observable<HttpResponse<ApiResponse>> get loginAssistanceStream =>
      loginAssistancePublishSubject.stream;

  dispose() {
    loginPublishSubject.close();
    loginAssistancePublishSubject.close();
  }

  login(LogInRequest request) async {
    try {
      loginPublishSubject.sink.add(HttpResponse.loading());
      var response = await userRepository.login(request);

      if (response.data != null) await _saveToPreferences(response.data);

      loginPublishSubject.sink.add(response);
    } catch (error) {
      loginPublishSubject.addError(error);
    }
  }

  loginToFacebook() => facebookLogin.logInWithReadPermissions(['email']);

  loginWithProvider(LogInWithProviderRequest request) async {
    try {
      loginPublishSubject.sink.add(HttpResponse.loading());
      var response = await userRepository.loginWithProvider(request);

      if (response.data != null) await _saveToPreferences(response.data);

      loginPublishSubject.sink.add(response);
    } catch (error) {
      loginPublishSubject.addError(error);
    }
  }

  forgotPassword(LoginAssistanceRequest request) async {
    try {
      loginAssistancePublishSubject.sink.add(HttpResponse.loading());
      final response = await userRepository.forgotPassword(request);
      loginAssistancePublishSubject.sink.add(response);
    } catch (error) {
      loginAssistancePublishSubject.addError(error);
    }
  }

  resendActivation(LoginAssistanceRequest request) async {
    try {
      loginAssistancePublishSubject.sink.add(HttpResponse.loading());
      final response = await userRepository.resendActivation(request);
      loginAssistancePublishSubject.sink.add(response);
    } catch (error) {
      loginAssistancePublishSubject.addError(error);
    }
  }

  Future<void> _saveToPreferences(LogInResponse response) async {


    await Future.wait([
      session.logUserIn(response),
      firebaseAuth.signInWithCustomToken(token: response.firebaseAuthToken)
    ]);
  }
}
