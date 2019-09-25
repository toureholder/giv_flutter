import 'dart:convert';
import 'dart:io';

import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/custom_http_headers.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BaseApi {
  BaseApi({@required this.client});

  final HttpClientWrapper client;

  final String baseUrl = Config.baseUrl;
  final String bearer = 'Bearer';

  Future<http.Response> delete(String url) async {
    final headers = _getDefaultHeaders();
    return client.http.delete(url, headers: headers);
  }

  Future<http.Response> get(String url, {Map<String, dynamic> params}) async {
    final headers = _getDefaultHeaders();

    final urlBuffer = new StringBuffer(url);
    if (params != null && params.isNotEmpty) {
      urlBuffer.write('?');
      List<String> paramsList = [];
      params.forEach((String key, value) {
        if (value != null) paramsList.add('$key=$value');
      });
      urlBuffer.write(paramsList.join('&'));
    }

    return client.http.get(urlBuffer.toString(), headers: headers);
  }

  Future<http.Response> patch(String url, Map<String, dynamic> body) =>
      put(url, body);

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = _getApplicationJsonContentTypeHeaders();
    return client.http.post(url, body: json.encode(body), headers: headers);
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final headers = _getApplicationJsonContentTypeHeaders();
    return client.http.put(url, body: json.encode(body), headers: headers);
  }

  Map<String, String> _getDefaultHeaders() {
    String token = client.diskStorage.getServerToken();
    return {
      HttpHeaders.authorizationHeader: '$bearer $token',
      CustomHttpHeaders.clientVersionHeader: Config.buildNumber.toString(),
      CustomHttpHeaders.clientNameHeader: Config.clientName
    };
  }

  Map<String, String> _getApplicationJsonContentTypeHeaders() {
    final headers = _getDefaultHeaders();
    headers.addAll({HttpHeaders.contentTypeHeader: 'application/json'});
    return headers;
  }
}
