class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);

  factory Coordinates.fake() => Coordinates(15.8102797, -47.8921486);
}
