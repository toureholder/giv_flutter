import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/log_in_request.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/model/user/log_in_with_provider.dart';
import 'package:giv_flutter/model/user/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/token_store.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class LogInBloc {
  final _userRepository = UserRepository();

  final _responsePublishSubject = PublishSubject<StreamEvent<LogInResponse>>();

  final _forgotPasswordPublishSubject =
      PublishSubject<StreamEvent<ApiResponse>>();

  final _resendActivationPublishSubject =
      PublishSubject<StreamEvent<ApiResponse>>();

  Observable<StreamEvent<LogInResponse>> get responseStream =>
      _responsePublishSubject.stream;

  Observable<StreamEvent<ApiResponse>> get forgotPasswordStream =>
      _forgotPasswordPublishSubject.stream;

  Observable<StreamEvent<ApiResponse>> get resendActivationStream =>
      _resendActivationPublishSubject.stream;

  dispose() {
    _responsePublishSubject.close();
    _forgotPasswordPublishSubject.close();
    _resendActivationPublishSubject.close();
  }

  login(LogInRequest request) async {
    try {
      _responsePublishSubject.sink.add(StreamEvent.loading());
      var response = await _userRepository.login(request);

      await _saveToPreferences(response);

      _responsePublishSubject.sink
          .add(StreamEvent<LogInResponse>(data: response));
    } catch (error) {
      _responsePublishSubject.addError(error);
    }
  }

  loginWithProvider(LogInWithProviderRequest request) async {
    try {
      _responsePublishSubject.sink.add(StreamEvent.loading());
      var response = await _userRepository.loginWithProvider(request);

      await _saveToPreferences(response);

      _responsePublishSubject.sink
          .add(StreamEvent<LogInResponse>(data: response));
    } catch (error) {
      _responsePublishSubject.addError(error);
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
    await Prefs.setTokens(TokenStore(
        firebaseAuthToken: response.longLivedToken,
        longLivedToken: response.longLivedToken));
  }
}
