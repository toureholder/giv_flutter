import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class LogInBloc {
  final _userRepository = UserRepository();

  final _loginPublishSubject = PublishSubject<HttpResponse<LogInResponse>>();

  final _forgotPasswordPublishSubject =
      PublishSubject<StreamEvent<ApiResponse>>();

  final _resendActivationPublishSubject =
      PublishSubject<StreamEvent<ApiResponse>>();

  Observable<HttpResponse<LogInResponse>> get responseStream =>
      _loginPublishSubject.stream;

  Observable<StreamEvent<ApiResponse>> get forgotPasswordStream =>
      _forgotPasswordPublishSubject.stream;

  Observable<StreamEvent<ApiResponse>> get resendActivationStream =>
      _resendActivationPublishSubject.stream;

  dispose() {
    _loginPublishSubject.close();
    _forgotPasswordPublishSubject.close();
    _resendActivationPublishSubject.close();
  }

  login(LogInRequest request) async {
    try {
      _loginPublishSubject.sink.add(HttpResponse.loading());
      var response = await _userRepository.login(request);

      if (response.data != null)
        await _saveToPreferences(response.data);

      _loginPublishSubject.sink
          .add(response);
    } catch (error) {
      _loginPublishSubject.addError(error);
    }
  }

  loginWithProvider(LogInWithProviderRequest request) async {
    try {
      _loginPublishSubject.sink.add(HttpResponse.loading());
      var response = await _userRepository.loginWithProvider(request);

      if (response.data != null)
        await _saveToPreferences(response.data);

      _loginPublishSubject.sink
          .add(response);
    } catch (error) {
      _loginPublishSubject.addError(error);
    }
  }

  forgotPassword(LoginAssistanceRequest request) async {
    try {
      _forgotPasswordPublishSubject.sink.add(StreamEvent.loading());
      final response = await _userRepository.forgotPassword(request);
      _forgotPasswordPublishSubject.sink
          .add(StreamEvent<ApiResponse>(data: response));
    } catch (error) {
      _forgotPasswordPublishSubject.addError(error);
    }
  }

  resendActivation(LoginAssistanceRequest request) async {
    try {
      _resendActivationPublishSubject.sink.add(StreamEvent.loading());
      final response = await _userRepository.resendActivation(request);
      _resendActivationPublishSubject.sink
          .add(StreamEvent<ApiResponse>(data: response));
    } catch (error) {
      _resendActivationPublishSubject.addError(error);
    }
  }

  Future<void> _saveToPreferences(LogInResponse response) async {
    await Prefs.setUser(response.user);

    await Future.wait([
      Prefs.setServerToken(response.longLivedToken),
      Prefs.setFirebaseToken(response.firebaseAuthToken)
    ]);
  }
}
