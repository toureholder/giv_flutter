import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/sign_up_request.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final _userRepository = UserRepository();

  final _responsePublishSubject = PublishSubject<HttpResponse<ApiResponse>>();

  Observable<HttpResponse<ApiResponse>> get responseStream =>
      _responsePublishSubject.stream;

  dispose() {
    _responsePublishSubject.close();
  }

  signUp(SignUpRequest request) async {
    try {
      _responsePublishSubject.sink.add(HttpResponse.loading());

      HttpResponse<ApiResponse> response =
          await _userRepository.signUp(request);

      _responsePublishSubject.sink.add(response);
    } catch (error) {
      _responsePublishSubject.addError(error);
    }
  }
}
