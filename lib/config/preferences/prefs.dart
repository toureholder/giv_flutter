import 'dart:convert';

import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // General

  static Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_userKey),
      prefs.remove(_serverTokenKey),
      prefs.remove(_firebaseTokenKey)
    ]);
  }

  static Future<bool> isAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverTokenKey) != null;
  }

  // Has seen agreed to customer service dialog

  static final String _hasAgreedToCustomerService =
      'has_agreed_to_customer_service';

  static Future<bool> hasAgreedToCustomerService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasAgreedToCustomerService) ?? false;
  }

  static Future<bool> setHasAgreedToCustomerService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_hasAgreedToCustomerService, true);
  }

  // Location

  static final String _locationJsonKey = 'location';

  static Future<bool> hasPreferredLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationJsonKey) != null;
  }

  static Future<Location> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonString = prefs.getString(_locationJsonKey);

    try {
      return Location.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  static Future<bool> setLocation(Location location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_locationJsonKey, json.encode(location.toJson()));
  }

  // Settings

  static final String _settingsJsonKey = 'settings';

  static Future<AppConfig> getSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonString = prefs.getString(_settingsJsonKey);

    try {
      return AppConfig.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  static Future<bool> setSettings(AppConfig settings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_settingsJsonKey, json.encode(settings.toJson()));
  }

  // User

  static final String _userKey = 'user';

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonString = prefs.getString(_userKey);

    try {
      return User.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  static Future<bool> setUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userKey, json.encode(user.toJson()));
  }

  // Tokens

  static final String _serverTokenKey = 'server_token';

  static Future<String> getServerToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverTokenKey);
  }

  static Future<bool> setServerToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_serverTokenKey, token);
  }

  static final String _firebaseTokenKey = 'firebase_token';

  static Future<String> getFirebaseToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firebaseTokenKey);
  }

  static Future<bool> setFirebaseToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_firebaseTokenKey, token);
  }
}
