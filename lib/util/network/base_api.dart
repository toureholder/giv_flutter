import 'dart:convert';
import 'dart:io';

import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  final String baseUrl = Config.baseUrl;
  final String bearer = 'Bearer';

  Future<http.Response> delete(String url) async {
    final headers = await _getDefaultHeaders();
    return http.delete(url, headers: headers);
  }

  Future<http.Response> get(String url, {Map<String, dynamic> params}) async {
    final headers = await _getDefaultHeaders();

    final urlBuffer = new StringBuffer(url);
    if (params != null && params.isNotEmpty) {
      urlBuffer.write('?');
      List<String> paramsList = [];
      params.forEach((String key, value) {
        if (value != null) paramsList.add('$key=$value');
      });
      urlBuffer.write(paramsList.join('&'));
    }

    return http.get(urlBuffer.toString(), headers: headers);
  }

  Future<http.Response> patch(String url, Map<String, dynamic> body) =>
      put(url, body);

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = await _getApplicationJsonContentTypeHeaders();
    return http.post(url, body: json.encode(body), headers: headers);
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final headers = await _getApplicationJsonContentTypeHeaders();
    return http.put(url, body: json.encode(body), headers: headers);
  }

  Future<Map<String, String>> _getDefaultHeaders() async {
    String token = await Prefs.getServerToken();
    return {HttpHeaders.authorizationHeader: '$bearer $token'};
  }

  Future<Map<String, String>> _getApplicationJsonContentTypeHeaders() async {
    final headers = await _getDefaultHeaders();
    headers.addAll({HttpHeaders.contentTypeHeader: 'application/json'});
    return headers;
  }
}
