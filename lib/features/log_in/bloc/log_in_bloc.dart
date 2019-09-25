import 'package:firebase_auth/firebase_auth.dart';
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
  });

  final UserRepository userRepository;
  final SessionProvider session;

  final _loginPublishSubject = PublishSubject<HttpResponse<LogInResponse>>();

  final _loginAssistancePublishSubject =
      PublishSubject<HttpResponse<ApiResponse>>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Observable<HttpResponse<LogInResponse>> get loginResponseStream =>
      _loginPublishSubject.stream;

  Observable<HttpResponse<ApiResponse>> get loginAssistanceStream =>
      _loginAssistancePublishSubject.stream;

  dispose() {
    _loginPublishSubject.close();
    _loginAssistancePublishSubject.close();
  }

  login(LogInRequest request) async {
    try {
      _loginPublishSubject.sink.add(HttpResponse.loading());
      var response = await userRepository.login(request);

      if (response.data != null) await _saveToPreferences(response.data);

      _loginPublishSubject.sink.add(response);
    } catch (error) {
      _loginPublishSubject.addError(error);
    }
  }

  loginWithProvider(LogInWithProviderRequest request) async {
    try {
      _loginPublishSubject.sink.add(HttpResponse.loading());
      var response = await userRepository.loginWithProvider(request);

      if (response.data != null) await _saveToPreferences(response.data);

      _loginPublishSubject.sink.add(response);
    } catch (error) {
      _loginPublishSubject.addError(error);
    }
  }

  forgotPassword(LoginAssistanceRequest request) async {
    try {
      _loginAssistancePublishSubject.sink.add(HttpResponse.loading());
      final response = await userRepository.forgotPassword(request);
      _loginAssistancePublishSubject.sink.add(response);
    } catch (error) {
      _loginAssistancePublishSubject.addError(error);
    }
  }

  resendActivation(LoginAssistanceRequest request) async {
    try {
      _loginAssistancePublishSubject.sink.add(HttpResponse.loading());
      final response = await userRepository.resendActivation(request);
      _loginAssistancePublishSubject.sink.add(response);
    } catch (error) {
      _loginAssistancePublishSubject.addError(error);
    }
  }

  Future<void> _saveToPreferences(LogInResponse response) async {


    await Future.wait([
      session.logUserIn(response),
      _firebaseAuth.signInWithCustomToken(token: response.firebaseAuthToken)
    ]);
  }
}
