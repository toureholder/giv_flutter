import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';

class ProductApi {
  Future<List<ProductCategory>> getFeaturedProductsCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return ProductCategory.homeMock();
  }

  Future<List<ProductCategory>> getSearchCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return ProductCategory.browseMock();
  }

  Future<ProductSearchResult> getProductsByCategory(
      {int categoryId, Location location, bool isHardFilter = true}) async {
    await Future.delayed(Duration(seconds: 2));
    return ProductSearchResult.mock();
  }

  Future<ProductSearchResult> getProductsBySearchQuery(
      {String q, Location location, bool isHardFilter = true}) async {
    await Future.delayed(Duration(seconds: 2));
    return ProductSearchResult.mock();
  }

  Future<List<Product>> getMyProducts() async {
    await Future.delayed(Duration(seconds: 2));
    return Product.getMockList();
  }
}
