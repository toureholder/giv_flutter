import 'package:giv_flutter/model/user/log_in_request.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
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
    print(request.email);
    try {
      _responsePublishSubject.sink.add(StreamEvent.loading());
      var response = await _userRepository.login(request);
      _responsePublishSubject.sink
          .add(StreamEvent<LogInResponse>(data: response));
    } catch (error) {
      _responsePublishSubject.addError(error);
    }
  }
}
