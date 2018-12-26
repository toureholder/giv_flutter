class Dimens {
  static const double GRID = 2.0;

  static const double default_horizontal_margin = GRID * 10;
  static const double default_vertical_margin = GRID * 10;
  static const double default_rounded_corner_border_radius = 5.0;

  static const double home_product_image_dimension = GRID * 60;
  static const double search_result_image_height = GRID * 64;

  static double grid(int times) {
    return GRID * times;
  }
}
