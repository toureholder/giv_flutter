import 'dart:convert';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:meta/meta.dart';

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
  UserApi({@required HttpClientWrapper client}) : super(client: client);

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

  Future<HttpResponse<ApiResponse>> forgotPassword(LoginAssistanceRequest request) async {
    HttpStatus status;
    try {
      final response =
      await post('$baseUrl/password_resets/emails', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<ApiResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiResponse>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<ApiResponse>> resendActivation(LoginAssistanceRequest request) async {
    HttpStatus status;
    try {
      final response =
      await post('$baseUrl/email_confirmations/resend', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<ApiResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiResponse>(
          status: status, message: error.toString());
    }
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
      final response = await patch('$baseUrl/me', userUpdate);

      status = HttpResponse.codeMap[response.statusCode];
      final data = User.fromJson(jsonDecode(response.body));

      return HttpResponse<User>(status: status, data: data);
    } catch (error) {
      return HttpResponse<User>(status: status, message: error.toString());
    }
  }
}
