class LocationPart {
  final String id;
  final String name;

  LocationPart({this.id, this.name});

  bool get isComplete =>
      this != null &&
      (id != null && id.isNotEmpty) &&
      (name != null && name.isNotEmpty);
}

class Country extends LocationPart {
  Country({String id, String name}) : super(id: id, name: name);
}

class State extends LocationPart {
  State({String id, String name}) : super(id: id, name: name);
}

class City extends LocationPart {
  City({String id, String name}) : super(id: id, name: name);
}
