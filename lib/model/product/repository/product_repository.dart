import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';

class ProductRepository {
  final productApi = ProductApi();

  Future<List<ProductCategory>> getFeaturedProductsCategories() =>
      productApi.getFeaturedProductsCategories();

  Future<List<ProductCategory>> getSearchCategories() =>
      productApi.getSearchCategories();

  Future<List<Product>> getProductsByCategory(int categoryId) =>
      productApi.getProductsByCategory(categoryId);

  Future<List<Product>> getProductsBySearchQuery(String q) =>
      productApi.getProductsBySearchQuery(q);
}
