import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product_category.dart';

class HomeContent {
  List<CarouselItem> heroItems;
  List<ProductCategory> productCategories;

  HomeContent({this.heroItems, this.productCategories});

  HomeContent.fake()
      : heroItems = CarouselItem.fakeList(),
        productCategories = ProductCategory.fakeListHomeContent();
}
