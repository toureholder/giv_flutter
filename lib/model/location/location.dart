import 'package:faker/faker.dart';
import 'package:giv_flutter/model/location/location_part.dart';

class Location {
  String cityId;
  String stateId;
  String countryId;
  String name;

  Location({this.cityId, this.stateId, this.countryId, this.name});

  // Serialization

  static final String cityIdKey = 'cityId';
  static final String stateIdKey = 'stateId';
  static final String countryIdKey = 'countryId';
  static final String nameKey = 'name';

  Location.fromJson(Map<String, dynamic> json)
      : cityId = json[cityIdKey],
        stateId = json[stateIdKey],
        countryId = json[countryIdKey],
        name = json[nameKey];

  static Location mock() => Location(
      cityId: '6324222',
      stateId: '3463504',
      countryId: '3469034',
      name: 'Brasília');

  Map<String, dynamic> toJson() => {
        cityIdKey: cityId,
        stateIdKey: stateId,
        countryIdKey: countryId,
        nameKey: name
      };

  Location copy() => Location.fromJson(toJson());

  bool equals(Location location) {
    return countryId == location.countryId &&
        stateId == location.stateId &&
        cityId == location.cityId;
  }

  static List<Country> mockCountries() {
    final faker = new Faker();
    final List<Country> list = [];

    for (var i = 0; i < 200; i++) {
      list.add(Country(
          id: faker.randomGenerator.string(6), name: faker.address.country()));
    }

    list.add(Country(id: '3469034', name: 'Brasil'));
    return list;
  }

  static List<State> mockStates() {
    final faker = new Faker();
    final List<State> list = [];

    for (var i = 0; i < 200; i++) {
      list.add(State(
          id: faker.randomGenerator.string(6), name: faker.address.city()));
    }

    list.add(State(id: '3463504', name: 'Distrito Federal'));
    return list;
  }

  static List<City> mockCities() {
    final faker = new Faker();
    final List<City> list = [];

    for (var i = 0; i < 200; i++) {
      list.add(City(
          id: faker.randomGenerator.string(6),
          name: faker.address.neighborhood()));
    }

    list.add(City(id: '6324222', name: 'Brasília'));
    return list;
  }
}
