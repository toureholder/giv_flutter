class Dimens {
  static const double GRID = 2.0;

  static const double default_horizontal_margin = GRID * 10;
  static const double default_vertical_margin = GRID * 10;

  static double grid(int times) {
    return GRID * times;
  }
}
