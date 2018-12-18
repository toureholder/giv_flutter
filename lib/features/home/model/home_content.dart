import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product_category.dart';

class HomeContent {
  final List<CarouselItem> heroItems;
  final List<ProductCategory> productCategories;

  HomeContent(this.heroItems, this.productCategories);
}