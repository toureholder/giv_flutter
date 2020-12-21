import 'dart:convert';

import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String userKey = 'user';
const String serverTokenKey = 'server_token';
const String firebaseTokenKey = 'firebase_token';
const String hasAgreedToCustomerServiceKey = 'has_agreed_to_customer_service';
const String hasSeenCreateGroupIntroductionKey =
    'has_seen_create_group_introduction';
const String hasSeenJoinGroupIntroductionKey =
    'has_seen_join_group_introduction';
const String hasSeenDonationIntroductionKey = 'has_seen_donation_introduction';
const String hasSeenDonationRequestIntroductionKey =
    'has_seen_donation_request_introduction';
const String locationKey = 'location';
const String appConfigKey = 'settings';

class SharedPreferencesStorage implements DiskStorageProvider {
  SharedPreferencesStorage(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<bool> clearAll() => sharedPreferences.clear();

  @override
  Future<bool> clearFirebaseToken() =>
      sharedPreferences.remove(firebaseTokenKey);

  @override
  Future<bool> clearServerToken() => sharedPreferences.remove(serverTokenKey);

  @override
  Future<bool> clearUser() => sharedPreferences.remove(userKey);

  @override
  CachePayload getCachePayloadItem(String cacheKey) {
    String jsonString = sharedPreferences.getString(cacheKey);
    try {
      return CachePayload.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  String getFirebaseToken() => sharedPreferences.get(firebaseTokenKey);

  @override
  Location getLocation() {
    String jsonString = sharedPreferences.getString(locationKey);

    try {
      return Location.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  Location getLocationCacheItem(String cacheKey) {
    String jsonString = sharedPreferences.getString(cacheKey);

    try {
      return Location.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  String getServerToken() => sharedPreferences.get(serverTokenKey);

  @override
  AppConfig getAppConfiguration() {
    String jsonString = sharedPreferences.getString(appConfigKey);

    try {
      return AppConfig.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  User getUser() {
    String jsonString = sharedPreferences.getString(userKey);

    try {
      return User.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  bool hasAgreedToCustomerService() =>
      sharedPreferences.getBool(hasAgreedToCustomerServiceKey) ?? false;

  @override
  Future<bool> setAppConfiguration(AppConfig appConfig) => sharedPreferences
      .setString(appConfigKey, json.encode(appConfig.toJson()));

  @override
  Future<bool> setFirebaseToken(String token) =>
      sharedPreferences.setString(firebaseTokenKey, token);

  @override
  Future<bool> setHasAgreedToCustomerService() =>
      sharedPreferences.setBool(hasAgreedToCustomerServiceKey, true);

  @override
  Future<bool> setLocation(Location location) =>
      sharedPreferences.setString(locationKey, json.encode(location.toJson()));

  @override
  Future<bool> setServerToken(String token) =>
      sharedPreferences.setString(serverTokenKey, token);

  @override
  Future<bool> setUser(User user) =>
      sharedPreferences.setString(userKey, json.encode(user.toJson()));

  @override
  Future<bool> setLocationCacheItem(String cacheKey, Location location) =>
      sharedPreferences.setString(cacheKey, json.encode(location.toJson()));

  @override
  Future<bool> setCachePayloadItem(String cacheKey, CachePayload payload) =>
      sharedPreferences.setString(cacheKey, json.encode(payload.toJson()));

  @override
  bool hasSeenCreateGroupIntroduction() =>
      sharedPreferences.getBool(hasSeenCreateGroupIntroductionKey) ?? false;

  @override
  Future<bool> setHasSeenCreateGroupIntroduction() =>
      sharedPreferences.setBool(hasSeenCreateGroupIntroductionKey, true);

  @override
  bool hasSeenJoinGroupIntroduction() =>
      sharedPreferences.getBool(hasSeenJoinGroupIntroductionKey) ?? false;

  @override
  Future<bool> setHasSeenJoinGroupIntroduction() =>
      sharedPreferences.setBool(hasSeenJoinGroupIntroductionKey, true);

  @override
  bool hasSeenDonationIntroduction() =>
      sharedPreferences.getBool(hasSeenDonationIntroductionKey) ?? false;

  @override
  Future<bool> setHasSeenDonationIntroduction() =>
      sharedPreferences.setBool(hasSeenDonationIntroductionKey, true);

  @override
  bool hasSeenDonationRequestIntroduction() =>
      sharedPreferences.getBool(hasSeenDonationRequestIntroductionKey) ?? false;

  @override
  Future<bool> setHasSeenDonationRequestIntroduction() =>
      sharedPreferences.setBool(hasSeenDonationRequestIntroductionKey, true);
}
