import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final UserRepository userRepository;
  final PublishSubject<HttpResponse<ApiResponse>> responsePublishSubject;

  SignUpBloc({
    @required this.userRepository,
    @required this.responsePublishSubject,
  });

  Observable<HttpResponse<ApiResponse>> get responseStream =>
      responsePublishSubject.stream;

  dispose() {
    responsePublishSubject.close();
  }

  signUp(SignUpRequest request) async {
    try {
      responsePublishSubject.sink.add(HttpResponse.loading());

      HttpResponse<ApiResponse> response = await userRepository.signUp(request);

      responsePublishSubject.sink.add(response);
    } catch (error) {
      responsePublishSubject.addError(error);
    }
  }
}
