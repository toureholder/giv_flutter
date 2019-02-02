import 'dart:io';

import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  final String baseUrl = Config.baseUrl;
  final String bearer = 'Bearer';

  Future<http.Response> delete(String url) async {
    final headers = await _getHeaders();
    return http.delete(url, headers: headers);
  }

  Future<http.Response> get(String url) async {
    final headers = await _getHeaders();
    return http.get(url, headers: headers);
  }

  Future<http.Response> patch(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.patch(url, body: body, headers: headers);
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.post(url, body: body, headers: headers);
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.put(url, body: body, headers: headers);
  }

  Future<Map<String, String>> _getHeaders() async {
    String token = await Prefs.getServerToken();
    return {HttpHeaders.authorizationHeader: '$bearer $token'};
  }
}
