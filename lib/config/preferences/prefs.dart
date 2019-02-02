import 'dart:convert';

import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/token_store.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  // General

  static Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  // Location

  static final String _locationJsonKey = 'location';

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
