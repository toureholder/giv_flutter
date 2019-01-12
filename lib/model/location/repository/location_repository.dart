import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
import 'package:giv_flutter/model/location/location_list.dart';

class LocationRepository {
  final locationApi = LocationApi();

  Future<List<Country>> getCountries() => locationApi.getCountries();

  Future<List<State>> getStates(String countryId) =>
      locationApi.getStates(countryId);

  Future<List<City>> getCities(String stateId) =>
      locationApi.getCities(stateId);

  Future<LocationList> getLocationList(Location location) =>
      locationApi.getLocationList(location);
}
