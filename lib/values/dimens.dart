class Dimens {
  static const double GRID = 2.0;

  static const double default_horizontal_margin = GRID * 10;
  static const double default_vertical_margin = GRID * 10;
  static const double default_vertical_margin_and_a_half = GRID * 15;
  static const double double_default_margin = GRID * 20;
  static const double default_rounded_corner_border_radius = 5.0;
  static const double button_border_radius = 2.5;

  static const double home_product_image_dimension = GRID * 60;
  static const double search_result_image_height = GRID * 64;
  static const double app_bar_bottom_border_height = 1.0;
  static const double button_flat_height = 48.0;
  static const double sign_in_submit_button_margin_top = 48.0;
  static const double bottom_action_button_container_height = 90.0;
  static const double settings_tile_icon_size = 18.0;
  static const double category_list_tile_vertical_padding = GRID * 9;

  static double grid(int times) {
    return GRID * times;
  }
}
