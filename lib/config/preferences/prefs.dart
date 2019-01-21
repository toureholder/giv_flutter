import 'dart:convert';

import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/token_store.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

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

  static final String _tokenStoreKey = 'tokens';

  static Future<TokenStore> getTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonString = prefs.getString(_tokenStoreKey);

    try {
      return TokenStore.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  static Future<bool> setTokens(TokenStore tokens) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenStoreKey, json.encode(tokens.toJson()));
  }
}
