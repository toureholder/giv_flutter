import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
import 'package:giv_flutter/model/location/location_list.dart';
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
}
