import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/sign_up_request.dart';

class UserApi {
  Future<ApiResponse> signUp(SignUpRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return ApiResponse.mock();
  }
}