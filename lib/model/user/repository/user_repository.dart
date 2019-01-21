import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/sign_up_request.dart';

class UserRepository {
  final userApi = UserApi();

  Future<ApiResponse> signUp(SignUpRequest request) => userApi.signUp(request);
}