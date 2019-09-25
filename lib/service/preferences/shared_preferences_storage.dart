import 'dart:convert';

import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _userKey = 'user';
const String _serverTokenKey = 'server_token';
const String _firebaseTokenKey = 'firebase_token';
const String _hasAgreedToCustomerServiceKey = 'has_agreed_to_customer_service';
const String _locationKey = 'location';
const String _appConfigKey = 'settings';

class SharedPreferencesStorage implements DiskStorageProvider {
  SharedPreferencesStorage(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<bool> clearAll() => sharedPreferences.clear();

  @override
  Future<bool> clearFirebaseToken() =>
      sharedPreferences.remove(_firebaseTokenKey);

  @override
  Future<bool> clearServerToken() => sharedPreferences.remove(_serverTokenKey);

  @override
  Future<bool> clearUser() => sharedPreferences.remove(_userKey);

  @override
  String getFirebaseToken() => sharedPreferences.get(_firebaseTokenKey);

  @override
  Location getLocation() {
    String jsonString = sharedPreferences.getString(_locationKey);

    try {
      return Location.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  String getServerToken() => sharedPreferences.get(_serverTokenKey);

  @override
  AppConfig getAppConfiguration() {
    String jsonString = sharedPreferences.getString(_appConfigKey);

    try {
      return AppConfig.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  User getUser() {
    String jsonString = sharedPreferences.getString(_userKey);

    try {
      return User.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  bool hasAgreedToCustomerService() =>
      sharedPreferences.getBool(_hasAgreedToCustomerServiceKey) ?? false;

  @override
  Future<bool> setAppConfiguration(AppConfig appConfig) => sharedPreferences
      .setString(_appConfigKey, json.encode(appConfig.toJson()));

  @override
  Future<bool> setFirebaseToken(String token) =>
      sharedPreferences.setString(_firebaseTokenKey, token);

  @override
  Future<bool> setHasAgreedToCustomerService() =>
      sharedPreferences.setBool(_hasAgreedToCustomerServiceKey, true);

  @override
  Future<bool> setLocation(Location location) =>
      sharedPreferences.setString(_locationKey, json.encode(location.toJson()));

  @override
  Future<bool> setServerToken(String token) =>
      sharedPreferences.setString(_serverTokenKey, token);

  @override
  Future<bool> setUser(User user) =>
      sharedPreferences.setString(_userKey, json.encode(user.toJson()));
}
