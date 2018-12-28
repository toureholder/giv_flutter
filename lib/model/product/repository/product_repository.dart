import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';

class ProductRepository {
  final productApi = ProductApi();

  Future<List<ProductCategory>> getFeaturedProductsCategories() =>
      productApi.getFeaturedProductsCategories();

  Future<List<ProductCategory>> getSearchCategories() =>
      productApi.getSearchCategories();
}