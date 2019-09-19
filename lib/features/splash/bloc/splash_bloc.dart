import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class SplashBloc {
  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final AppConfigRepository appConfigRepository;

  SplashBloc({
    @required this.userRepository,
    @required this.locationRepository,
    @required this.appConfigRepository,
  });

  Future<HttpResponse<User>> getMe() => userRepository.getMe();

  Future<HttpResponse<Location>> getMyLocation(Coordinates coordinates) =>
      locationRepository.getMyLocation(coordinates);

  Future<HttpResponse<AppConfig>> getConfig() =>
      appConfigRepository.getConfig();
}
