import 'package:giv_flutter/model/location/location.dart';

abstract class LocationCacheProvider {
  Location getLocationDetails(Location location);
  Future<bool> saveLocationDetails(Location location);
}