import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/sign_up_request.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final _userRepository = UserRepository();

  final _responsePublishSubject = PublishSubject<StreamEvent<ApiResponse>>();

  Observable<StreamEvent<ApiResponse>> get responseStream =>
      _responsePublishSubject.stream;

  dispose() {
    _responsePublishSubject.close();
  }

  signUp(SignUpRequest request) async {
    try {
      _responsePublishSubject.sink.add(StreamEvent.loading());
      var response = await _userRepository.signUp(request);
      _responsePublishSubject.sink
          .add(StreamEvent<ApiResponse>(data: response));
    } catch (error) {
      _responsePublishSubject.addError(error);
    }
  }
}
