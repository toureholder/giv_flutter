import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/app_config/repository/api/app_config_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class AppConfigRepository {
  Future<HttpResponse<AppConfig>> getConfig() => AppConfigApi().getConfig();
}