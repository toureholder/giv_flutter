import 'package:giv_flutter/features/home/model/quick_menu_item.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product_category.dart';

class HomeContent {
  final List<CarouselItem> heroItems;
  final List<ProductCategory> productCategories;
  final List<QuickMenuItem> quickMenuItems;

  HomeContent({this.heroItems, this.productCategories, this.quickMenuItems});

  HomeContent.fake()
      : heroItems = CarouselItem.fakeList(),
        quickMenuItems = QuickMenuItem.fakeList(),
        productCategories = ProductCategory.fakeListHomeContent();
}
