import 'dart:convert';
import 'dart:io';

import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:giv_flutter/util/network/custom_http_headers.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  BaseApi({@required this.client});

  final http.Client client;

  final String baseUrl = Config.baseUrl;
  final String bearer = 'Bearer';

  http.Client tempClient;

  // TODO: Depend on disk storage

  Future<http.Response> delete(String url) async {
    // Remove after refactor
    tempClient = client ?? http.Client();
    final headers = await _getDefaultHeaders();
    return tempClient.delete(url, headers: headers);
  }

  Future<http.Response> get(String url, {Map<String, dynamic> params}) async {
    // Remove after refactor
    tempClient = client ?? http.Client();
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

    return tempClient.get(urlBuffer.toString(), headers: headers);
  }

  Future<http.Response> patch(String url, Map<String, dynamic> body) =>
      put(url, body);

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    // Remove after refactor
    tempClient = client ?? http.Client();
    final headers = await _getApplicationJsonContentTypeHeaders();
    return tempClient.post(url, body: json.encode(body), headers: headers);
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    // Remove after refactor
    tempClient = client ?? http.Client();
    final headers = await _getApplicationJsonContentTypeHeaders();
    return tempClient.put(url, body: json.encode(body), headers: headers);
  }

  Future<Map<String, String>> _getDefaultHeaders() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(sharedPreferences);

    String token = storage.getServerToken();
    return {
      HttpHeaders.authorizationHeader: '$bearer $token',
      CustomHttpHeaders.clientVersionHeader: Config.buildNumber.toString(),
      CustomHttpHeaders.clientNameHeader: Config.clientName
    };
  }

  Future<Map<String, String>> _getApplicationJsonContentTypeHeaders() async {
    final headers = await _getDefaultHeaders();
    headers.addAll({HttpHeaders.contentTypeHeader: 'application/json'});
    return headers;
  }
}
