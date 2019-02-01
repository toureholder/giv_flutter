import 'dart:convert';

import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_request.dart';
import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/repository/api/request/log_in_with_provider_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/login_assistance_request.dart';
import 'package:giv_flutter/model/user/repository/api/request/sign_up_request.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart' as http;

class UserApi extends BaseApi {
  Future<HttpResponse<ApiResponse>> signUp(SignUpRequest request) async {
    HttpStatus status;
    try {
      final response =
          await http.post('$baseUrl/signup', body: request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiResponse.fromNetwork(jsonDecode(response.body));

      return HttpResponse<ApiResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiResponse>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<LogInResponse>> login(LogInRequest request) async {
    HttpStatus status;
    try {
      final response = await http.post('$baseUrl/auth/login',
          body: request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = LogInResponse.fromNetwork(jsonDecode(response.body));

      return HttpResponse<LogInResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<LogInResponse>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<LogInResponse>> loginWithProvider(
      LogInWithProviderRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return HttpResponse<LogInResponse>(
        status: HttpStatus.ok, data: LogInResponse.mock());
  }

  Future<ApiResponse> forgotPassword(LoginAssistanceRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return ApiResponse.mock();
  }

  Future<ApiResponse> resendActivation(LoginAssistanceRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return ApiResponse.mock();
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
