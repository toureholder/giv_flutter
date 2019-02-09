import 'package:giv_flutter/model/location/location_part.dart';

class LocationList {
  List<Country> countries;
  List<State> states;
  List<City> cities;

  LocationList({this.countries, this.states, this.cities});

  LocationList.fromJson(Map<String, dynamic> json)
      : countries = Country.fromDynamicList(json['countries']),
        states = State.fromDynamicList(json['states']),
        cities = City.fromDynamicList(json['cities']);
}
