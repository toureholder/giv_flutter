import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';

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

  Future<bool> setHasSeenCreateGroupIntroduction();
  bool hasSeenCreateGroupIntroduction();

  Future<bool> setHasSeenJoinGroupIntroduction();
  bool hasSeenJoinGroupIntroduction();

  Future<bool> setHasSeenDonationIntroduction();
  bool hasSeenDonationIntroduction();

  Future<bool> setHasSeenDonationRequestIntroduction();
  bool hasSeenDonationRequestIntroduction();

  Future<bool> setLocation(Location location);
  Location getLocation();

  Future<bool> setAppConfiguration(AppConfig appConfig);
  AppConfig getAppConfiguration();

  Future<bool> setUser(User user);
  Future<bool> clearUser();
  User getUser();

  Location getLocationCacheItem(String cacheKey);
  Future<bool> setLocationCacheItem(String cacheKey, Location location);

  Future<bool> setCachePayloadItem(String cacheKey, CachePayload payload);
  CachePayload getCachePayloadItem(String cacheKey);
}
