import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/log_in_request.dart';
import 'package:giv_flutter/model/user/log_in_response.dart';
import 'package:giv_flutter/model/user/log_in_with_provider.dart';
import 'package:giv_flutter/model/user/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/sign_up_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class UserRepository {
  final userApi = UserApi();

  Future<HttpResponse<ApiResponse>> signUp(SignUpRequest request) =>
      userApi.signUp(request);

  Future<LogInResponse> login(LogInRequest request) => userApi.login(request);

  Future<LogInResponse> loginWithProvider(LogInWithProviderRequest request) =>
      userApi.loginWithProvider(request);

  Future<User> getMe() => userApi.getMe();

  Future<User> updateMe(User user) => userApi.updateMe(user);

  Future<ApiResponse> forgotPassword(LoginAssistanceRequest request) =>
      userApi.forgotPassword(request);

  Future<ApiResponse> resendActivation(LoginAssistanceRequest request) =>
      userApi.resendActivation(request);
}
