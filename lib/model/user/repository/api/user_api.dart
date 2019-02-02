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

class UserApi extends BaseApi {
  Future<HttpResponse<ApiResponse>> signUp(SignUpRequest request) async {
    HttpStatus status;
    try {
      final response =
          await post('$baseUrl/signup', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<ApiResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiResponse>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<LogInResponse>> login(LogInRequest request) async {
    HttpStatus status;
    try {
      final response =
          await post('$baseUrl/auth/login', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = LogInResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<LogInResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<LogInResponse>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<LogInResponse>> loginWithProvider(
      LogInWithProviderRequest request) async {
    HttpStatus status;
    try {
      final response =
          await post('$baseUrl/auth/provider', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = LogInResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<LogInResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<LogInResponse>(
          status: status, message: error.toString());
    }
  }

  Future<ApiResponse> forgotPassword(LoginAssistanceRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return ApiResponse.mock();
  }

  Future<ApiResponse> resendActivation(LoginAssistanceRequest request) async {
    await Future.delayed(Duration(seconds: 4));
    return ApiResponse.mock();
  }

  Future<HttpResponse<User>> getMe() async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/me');

      status = HttpResponse.codeMap[response.statusCode];
      final data = User.fromJson(jsonDecode(response.body));

      return HttpResponse<User>(status: status, data: data);
    } catch (error) {
      return HttpResponse<User>(status: status, message: error.toString());
    }
  }

  Future<HttpResponse<User>> updateMe(Map<String, dynamic> userUpdate) async {
    HttpStatus status;
    try {
      final response = await put('$baseUrl/me', userUpdate);

      status = HttpResponse.codeMap[response.statusCode];
      final data = User.fromJson(jsonDecode(response.body));

      return HttpResponse<User>(status: status, data: data);
    } catch (error) {
      return HttpResponse<User>(status: status, message: error.toString());
    }
  }
}
