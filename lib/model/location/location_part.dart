import 'dart:convert';

class LocationPart {
  final String id;
  final String name;

  LocationPart({this.id, this.name});

  bool get isOk =>
      this == null ||
      (id != null && id.isNotEmpty) && (name != null && name.isNotEmpty);

  bool get propertiesAreNull => id == null && name == null;
}

class Country extends LocationPart {
  final String id;
  final String name;

  Country({this.id, this.name}) : super(id: id, name: name);

  Country.fromJson(Map<String, dynamic> json)
      : id = '${json['id']}',
        name = json['name'];

  static List<Country> fromDynamicList(List<dynamic> list) {
    return (list == null)
        ? []
        : list.map<Country>((json) => Country.fromJson(json)).toList();
  }

  static List<Country> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return fromDynamicList(parsed);
  }
}

class State extends LocationPart {
  final String id;
  final String name;

  State({this.id, this.name}) : super(id: id, name: name);

  State.fromJson(Map<String, dynamic> json)
      : id = '${json['id']}',
        name = json['name'];

  factory State.fake() => State(id: '123', name: 'Somes state');

  static List<State> fromDynamicList(List<dynamic> list) {
    return (list == null)
        ? []
        : list.map<State>((json) => State.fromJson(json)).toList();
  }

  static List<State> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return fromDynamicList(parsed);
  }
}

class City extends LocationPart {
  final String id;
  final String name;

  City({this.id, this.name}) : super(id: id, name: name);

  City.fromJson(Map<String, dynamic> json)
      : id = '${json['id']}',
        name = json['name'];

  factory City.fake() => City(id: '123', name: 'Somes state');

  static List<City> fromDynamicList(List<dynamic> list) {
    return (list == null)
        ? []
        : list.map<City>((json) => City.fromJson(json)).toList();
  }

  static List<City> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return fromDynamicList(parsed);
  }
}
