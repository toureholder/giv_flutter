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

  factory LocationList.fakeOnlyCountries() => LocationList(
        countries: [
          Country(
            id: '1',
            name: 'Brasil',
          ),
        ],
        states: [],
        cities: [],
      );

  factory LocationList.fakeCountriesAndStates() => LocationList(
        countries: [
          Country(id: '1', name: 'Brasil'),
        ],
        states: [
          State(id: '1', name: 'DF'),
          State(id: '2', name: 'AC'),
          State(id: '3', name: 'SP'),
        ],
        cities: [],
      );

  factory LocationList.fake() => LocationList(
        countries: [
          Country(id: '1', name: 'Brasil'),
        ],
        states: [
          State(id: '1', name: 'DF'),
          State(id: '2', name: 'AC'),
          State(id: '3', name: 'SP'),
        ],
        cities: [
          City(id: '1', name: 'Brasília'),
          City(id: '2', name: 'Taguatinga'),
        ],
      );
}
