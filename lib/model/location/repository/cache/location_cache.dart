import 'dart:convert';

import 'package:giv_flutter/model/location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationCache {

  static final String _locationDetailKey = 'cache_location_details';

  static Future<Location> getLocationDetails(Location location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cacheKey = getLocationDetailsCacheKey(location);

    String jsonString = prefs.getString(cacheKey);

    try {
      return Location.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  static Future<bool> saveLocationDetails(Location location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cacheKey = getLocationDetailsCacheKey(location);
    return prefs.setString(cacheKey, json.encode(location.toJson()));
  }

  static String getLocationDetailsCacheKey(Location location) {
    final cacheKeyBuffer = StringBuffer(_locationDetailKey);
    cacheKeyBuffer.write('_country_id${location.country?.id}');
    cacheKeyBuffer.write('_state_id${location.state?.id}');
    cacheKeyBuffer.write('_city_id${location.city?.id}');
    return cacheKeyBuffer.toString();
  }
}