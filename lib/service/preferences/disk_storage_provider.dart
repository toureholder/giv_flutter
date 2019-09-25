

import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';

abstract class DiskStorageProvider {
  Future<bool> clearAll();

  Future<bool> setServerToken(String token);
  Future<bool> clearServerToken();
  String getServerToken();

  Future<bool> setFirebaseToken(String token);
  Future<bool> clearFirebaseToken();
  String getFirebaseToken();

  Future<bool> setHasAgreedToCustomerService();
  bool hasAgreedToCustomerService();

  Future<bool> setLocation(Location location);
  Location getLocation();

  Future<bool> setAppConfiguration(AppConfig appConfig);
  AppConfig getAppConfiguration();

  Future<bool> setUser(User user);
  Future<bool> clearUser();
  User getUser();
}