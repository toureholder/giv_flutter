import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class LocationRepository {
  final locationApi = LocationApi();

  Future<HttpResponse<List<Country>>> getCountries() =>
      locationApi.getCountries();

  Future<HttpResponse<List<State>>> getStates(String countryId) =>
      locationApi.getStates(countryId);

  Future<HttpResponse<List<City>>> getCities(
          String countryId, String stateId) =>
      locationApi.getCities(countryId, stateId);

  Future<HttpResponse<LocationList>> getLocationList(Location location) =>
      locationApi.getLocationList(location);

  Future<HttpResponse<Location>> getLocationDetails(Location location) async {
    Location cached = await LocationCache.getLocationDetails(location);

    if (cached != null) {
      return HttpResponse<Location>(status: HttpStatus.ok, data: cached);
    } else {
      final response = await locationApi.getLocationDetails(location);
      if (response.data != null)
        await LocationCache.saveLocationDetails(response.data);
      return response;
    }
  }
}
