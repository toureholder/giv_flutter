import 'package:faker/faker.dart';
import 'package:giv_flutter/model/location/location_part.dart';

class Location {
  City city;
  State state;
  Country country;

  Location({this.city, this.state, this.country});

  Location.fromLocationPartIds(
      {String countryId, String stateId, String cityId})
      : country = Country(id: countryId),
        state = State(id: stateId),
        city = City(id: cityId);

  String get shortName => city?.name ?? state?.name ?? country?.name;

  String get mediumName {
    final array = <String>[];

    if (city?.isOk ?? false) array.add(city.name);
    if (state?.isOk ?? false) array.add(state.name);
    if ((country?.isOk ?? false) && array.length < 2) array.add(country.name);

    return array.join(', ');
  }

  String get longName {
    final array = <String>[];

    if (city?.isOk ?? false) array.add(city.name);
    if (state?.isOk ?? false) array.add(state.name);
    if (country?.isOk ?? false) array.add(country.name);

    return array.join(', ');
  }

  bool equals(Location location) {
    if (location == null) return this == null;

    return country?.id == location.country?.id &&
        state?.id == location.state?.id &&
        city?.id == location.city?.id;
  }

  bool get isOk =>
      (country?.isOk ?? true) && (state?.isOk ?? true) && (city?.isOk ?? true);

  bool get isComplete =>
      (country?.isFilledIn ?? false) &&
      (state?.isFilledIn ?? false) &&
      (city?.isFilledIn ?? false);

  // Serialization

  static final String cityKey = 'city';
  static final String stateKey = 'state';
  static final String countryKey = 'country';
  static final String nameKey = 'name';
  static final String idKey = 'id';

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    Country country = json.containsKey(countryKey) && json[countryKey] != null
        ? Country(
            id: json[countryKey][idKey],
            name: json[countryKey][nameKey],
          )
        : null;

    State state = json.containsKey(stateKey) && json[stateKey] != null
        ? State(
            id: json[stateKey][idKey],
            name: json[stateKey][nameKey],
          )
        : null;

    City city = json.containsKey(cityKey) && json[cityKey] != null
        ? City(
            id: json[cityKey][idKey],
            name: json[cityKey][nameKey],
          )
        : null;

    if (city?.propertiesAreNull ?? true) city = null;
    if (state?.propertiesAreNull ?? true) state = null;
    if (country?.propertiesAreNull ?? true) country = null;

    return Location(country: country, state: state, city: city);
  }

  Location.fake()
      : country = Country(id: '3469034', name: 'Brasil'),
        state = State(id: '3463504', name: 'Distrito Federal');

  Location.fakeMissingNames()
      : country = Country(id: '3469034'),
        state = State(id: '3463504');

  Map<String, dynamic> toJson() => {
        cityKey: {idKey: city?.id, nameKey: city?.name},
        stateKey: {idKey: state?.id, nameKey: state?.name},
        countryKey: {idKey: country?.id, nameKey: country?.name},
      };

  Location copy() => Location.fromJson(toJson());

  static List<Country> mockCountries() {
    final faker = new Faker();
    final List<Country> list = [];

    list.add(Country(id: '3469034', name: 'Brasil'));

    for (var i = 0; i < 200; i++) {
      list.add(Country(
          id: faker.randomGenerator.string(6), name: faker.address.country()));
    }

    return list;
  }

  static List<State> mockStates() {
    final faker = new Faker();
    final List<State> list = [];

    list.add(State(id: '3463504', name: 'Distrito Federal'));

    for (var i = 0; i < 200; i++) {
      list.add(State(
          id: faker.randomGenerator.string(6), name: faker.address.city()));
    }

    return list;
  }

  static List<City> mockCities() {
    final faker = new Faker();
    final List<City> list = [];

    list.add(City(id: '6324222', name: 'Brasília'));

    for (var i = 0; i < 200; i++) {
      list.add(City(
          id: faker.randomGenerator.string(6),
          name: faker.address.neighborhood()));
    }

    return list;
  }
}
