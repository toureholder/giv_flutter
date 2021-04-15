import 'package:giv_flutter/base/custom_error.dart';
import 'package:giv_flutter/model/app_config/repository/app_config_repository.dart';
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SplashBloc {
  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final AppConfigRepository appConfigRepository;
  final DiskStorageProvider diskStorage;
  final SessionProvider session;
  final PublishSubject<bool> tasksSuccessSubject;

  SplashBloc({
    @required this.userRepository,
    @required this.locationRepository,
    @required this.appConfigRepository,
    @required this.diskStorage,
    @required this.session,
    @required this.tasksSuccessSubject,
  });

  dispose() => tasksSuccessSubject.close();

  Stream<bool> get tasksStateStream => tasksSuccessSubject.stream;

  runTasks() async {
    try {
      await Future.wait([
        _loadAppConfig(),
        _loadPreferredLocation(),
        _loadCurrentUser(),
      ]);

      tasksSuccessSubject.sink.add(true);
    } catch (error) {
      tasksSuccessSubject.sink.addError(error);
    }
  }

  Future _loadAppConfig() async {
    final response = await appConfigRepository.getConfig();

    if (response.status == HttpStatus.preconditionFailed)
      throw CustomError.forceUpdate;

    if (response.data != null)
      await diskStorage.setAppConfiguration(response.data);
  }

  Future _loadPreferredLocation() async {
    if (diskStorage.getLocation() == null) {
      final response =
          await locationRepository.getMyLocation(Coordinates(0, 0));

      if (response.data != null) await diskStorage.setLocation(response.data);
    }
  }

  Future _loadCurrentUser() async {
    if (session.isAuthenticated()) {
      final response = await userRepository.getMe();
      if (response.data != null) await diskStorage.setUser(response.data);
    }
  }
}
