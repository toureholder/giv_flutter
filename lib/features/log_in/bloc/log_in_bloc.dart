import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/user/log_in_request.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/model/user/log_in_with_provider.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/token_store.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class LogInBloc {
  final _userRepository = UserRepository();

  final _responsePublishSubject = PublishSubject<StreamEvent<LogInResponse>>();

  Observable<StreamEvent<LogInResponse>> get responseStream =>
      _responsePublishSubject.stream;

  dispose() {
    _responsePublishSubject.close();
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

  Future<void> _saveToPreferences(LogInResponse response) async {
    await Prefs.setUser(response.user);
    await Prefs.setTokens(TokenStore(
        firebaseAuthToken: response.longLivedToken,
        longLivedToken: response.longLivedToken));
  }
}
