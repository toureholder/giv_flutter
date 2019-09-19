import 'dart:convert';

import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache_provider.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationCache implements LocationCacheProvider {
  static final String _locationDetailKey = 'cache_location_details';

  final SharedPreferences sharedPreferences;

  LocationCache({@required this.sharedPreferences});

  @override
  Location getLocationDetails(Location location) {
    final cacheKey = getLocationDetailsCacheKey(location);

    String jsonString = sharedPreferences.getString(cacheKey);

    try {
      return Location.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  @override
  Future<bool> saveLocationDetails(Location location) async {
    final cacheKey = getLocationDetailsCacheKey(location);
    return sharedPreferences.setString(cacheKey, json.encode(location.toJson()));
  }

  @override
  String getLocationDetailsCacheKey(Location location) {
    final cacheKeyBuffer = StringBuffer(_locationDetailKey);
    cacheKeyBuffer.write('_country_id${location.country?.id}');
    cacheKeyBuffer.write('_state_id${location.state?.id}');
    cacheKeyBuffer.write('_city_id${location.city?.id}');
    return cacheKeyBuffer.toString();
  }
}