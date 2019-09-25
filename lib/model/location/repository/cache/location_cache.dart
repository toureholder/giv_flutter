import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache_provider.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:meta/meta.dart';

class LocationCache implements LocationCacheProvider {
  static final String locationDetailKey = 'cache_location_details';

  final DiskStorageProvider diskStorage;

  LocationCache({@required this.diskStorage});

  @override
  Location getLocationDetails(Location location) {
    final cacheKey = _getLocationDetailsCacheKey(location);
    return diskStorage.getLocationCacheItem(cacheKey);
  }

  @override
  Future<bool> saveLocationDetails(Location location) async {
    final cacheKey = _getLocationDetailsCacheKey(location);
    return diskStorage.setLocationCacheItem(cacheKey, location);
  }

  String _getLocationDetailsCacheKey(Location location) {
    final cacheKeyBuffer = StringBuffer(locationDetailKey);
    cacheKeyBuffer.write('_country_id${location.country?.id}');
    cacheKeyBuffer.write('_state_id${location.state?.id}');
    cacheKeyBuffer.write('_city_id${location.city?.id}');
    return cacheKeyBuffer.toString();
  }
}
