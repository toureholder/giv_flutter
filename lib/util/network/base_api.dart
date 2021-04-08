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
  final contentTypeApplicationJson = 'application/json';

  Future<http.Response> delete(String url) async {
    final baseReq = _getBaseRequest(url);

    return client.http.delete(
      baseReq.uri,
      headers: baseReq.headers,
    );
  }

  Future<http.Response> get(String url, {Map<String, dynamic> params}) async {
    final urlBuffer = new StringBuffer(url);

    if (params != null && params.isNotEmpty) {
      urlBuffer.write('?');
      List<String> paramsList = [];
      params.forEach((String key, value) {
        if (value != null) paramsList.add('$key=$value');
      });
      urlBuffer.write(paramsList.join('&'));
    }

    final baseReq = _getBaseRequest(urlBuffer.toString());

    return client.http.get(
      baseReq.uri,
      headers: baseReq.headers,
    );
  }

  Future<http.Response> patch(String url, Map<String, dynamic> body) =>
      put(url, body);

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final baseReq = _getBaseRequest(
      url,
      contentType: contentTypeApplicationJson,
    );

    return client.http.post(
      baseReq.uri,
      headers: baseReq.headers,
      body: json.encode(body),
    );
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final baseReq = _getBaseRequest(
      url,
      contentType: contentTypeApplicationJson,
    );

    return client.http.put(
      baseReq.uri,
      headers: baseReq.headers,
      body: json.encode(body),
    );
  }

  Map<String, String> _getHeaders({String contentType}) {
    String token = client.diskStorage.getServerToken();

    final headers = {
      HttpHeaders.authorizationHeader: '$bearer $token',
      CustomHttpHeaders.clientVersionHeader: Config.buildNumber.toString(),
      CustomHttpHeaders.clientNameHeader: Config.clientName,
    };

    if (contentType != null) {
      headers.addAll({HttpHeaders.contentTypeHeader: contentType});
    }

    return headers;
  }

  BaseApiRequest _getBaseRequest(String url, {String contentType}) {
    final headers = _getHeaders(contentType: contentType);
    final uri = BaseApi.stringToUri(url);

    return BaseApiRequest(uri, headers);
  }

  static Uri stringToUri(String url) => Uri.parse(url);
}

class BaseApiRequest {
  final Uri uri;
  final Map<String, String> headers;

  BaseApiRequest(
    this.uri,
    this.headers,
  );
}
