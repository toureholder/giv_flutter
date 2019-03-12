import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/user_api.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class UserRepository {
  final userApi = UserApi();

  Future<HttpResponse<ApiResponse>> signUp(SignUpRequest request) =>
      userApi.signUp(request);

  Future<HttpResponse<LogInResponse>> login(LogInRequest request) =>
      userApi.login(request);

  Future<HttpResponse<LogInResponse>> loginWithProvider(
          LogInWithProviderRequest request) =>
      userApi.loginWithProvider(request);

  Future<HttpResponse<User>> getMe() => userApi.getMe();

  Future<HttpResponse<User>> updateMe(Map<String, dynamic> userUpdate) => userApi.updateMe(userUpdate);

  Future<HttpResponse<ApiResponse>> forgotPassword(LoginAssistanceRequest request) =>
      userApi.forgotPassword(request);

  Future<HttpResponse<ApiResponse>> resendActivation(LoginAssistanceRequest request) =>
      userApi.resendActivation(request);
}
