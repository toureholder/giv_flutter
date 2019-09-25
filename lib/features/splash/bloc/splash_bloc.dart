import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class SplashBloc {
  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final AppConfigRepository appConfigRepository;
  final DiskStorageProvider diskStorage;
  final SessionProvider session;

  SplashBloc({
    @required this.userRepository,
    @required this.locationRepository,
    @required this.appConfigRepository,
    @required this.diskStorage,
    @required this.session,
  });

  Future<HttpResponse<User>> getMe() => userRepository.getMe();

  Future<HttpResponse<Location>> getMyLocation(Coordinates coordinates) =>
      locationRepository.getMyLocation(coordinates);

  Future<HttpResponse<AppConfig>> getConfig() =>
      appConfigRepository.getConfig();

  Future<bool> persistAppConfig(AppConfig appConfig) => diskStorage.setAppConfiguration(appConfig);

  bool hasPreferredLocation() => diskStorage.getLocation() != null;

  Future<bool> persistLocation(Location location) => diskStorage.setLocation(location);

  bool isAuthenticated() => session.isAuthenticated();

  Future<bool> persistUser(User user) => diskStorage.setUser(user);
}
