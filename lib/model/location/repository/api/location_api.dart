import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/location_list.dart';

class LocationApi {

  Future<List<Country>> getCountries() async {
    await Future.delayed(Duration(seconds: 1));
    return Location.mockCountries();
  }

  Future<List<State>> getStates(String countryId) async {
    await Future.delayed(Duration(seconds: 1));
    return Location.mockStates();
  }

  Future<List<City>> getCities(String stateId) async {
    await Future.delayed(Duration(seconds: 1));
    return Location.mockCities();
  }

  Future<LocationList> getLocationList(Location location) async {
    await Future.delayed(Duration(seconds: 2));
    var lists = LocationList();
    lists.countries = Location.mockCountries();
    if (location.countryId != null) lists.states = Location.mockStates();
    if (location.stateId != null) lists.cities = Location.mockCities();
    return lists;
  }
}
