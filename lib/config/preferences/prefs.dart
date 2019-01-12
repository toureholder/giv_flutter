import 'dart:convert';

import 'package:giv_flutter/model/location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
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

    return prefs.setString(_locationJsonKey, location.toJson().toString());
  }
}
