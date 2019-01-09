import 'package:giv_flutter/model/product/product.dart';
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

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    await Future.delayed(Duration(seconds: 2));
    return Product.getMockList();
  }

  Future<List<Product>> getProductsBySearchQuery(String q) async {
    await Future.delayed(Duration(seconds: 2));
    return Product.getMockList();
  }
}