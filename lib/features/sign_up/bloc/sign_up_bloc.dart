import 'package:meta/meta.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final UserRepository userRepository;

  final _responsePublishSubject = PublishSubject<HttpResponse<ApiResponse>>();

  SignUpBloc({@required this.userRepository});

  Observable<HttpResponse<ApiResponse>> get responseStream =>
      _responsePublishSubject.stream;

  dispose() {
    _responsePublishSubject.close();
  }

  signUp(SignUpRequest request) async {
    try {
      _responsePublishSubject.sink.add(HttpResponse.loading());

      HttpResponse<ApiResponse> response =
          await userRepository.signUp(request);

      _responsePublishSubject.sink.add(response);
    } catch (error) {
      _responsePublishSubject.addError(error);
    }
  }
}
