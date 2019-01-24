import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/log_in_request.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/model/user/log_in_with_provider.dart';
import 'package:giv_flutter/model/user/sign_up_request.dart';
import 'package:giv_flutter/model/user/user.dart';

class UserApi {
  Future<ApiResponse> signUp(SignUpRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return ApiResponse.mock();
  }

  Future<LogInResponse> login(LogInRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return LogInResponse.mock();
  }

  Future<LogInResponse> loginWithProvider(LogInWithProviderRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return LogInResponse.mock();
  }

  Future<User> getMe() async {
    await Future.delayed(Duration(seconds: 2));
    return User.mock();
  }

  Future<User> updateMe(User user) async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }
}