import 'dart:convert';

import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class AppConfigApi extends BaseApi {
  AppConfigApi({
    @required HttpClientWrapper client,
  }) : super(client: client);

  Future<HttpResponse<AppConfig>> getConfig() async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/settings');

      status = HttpResponse.codeMap[response.statusCode];
      final data = AppConfig.fromJson(jsonDecode(response.body));

      return HttpResponse<AppConfig>(status: status, data: data);
    } catch (error) {
      return HttpResponse<AppConfig>(status: status, message: error.toString());
    }
  }
}