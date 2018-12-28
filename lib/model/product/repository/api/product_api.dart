import 'package:giv_flutter/model/product/product_category.dart';

class ProductApi {

  Future<List<ProductCategory>> getFeaturedProductsCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return ProductCategory.homeMock();
  }

  Future<List<ProductCategory>> getSearchCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return ProductCategory.browseMock();
  }
}