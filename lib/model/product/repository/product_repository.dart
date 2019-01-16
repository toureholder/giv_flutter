import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';

class ProductRepository {
  final productApi = ProductApi();

  Future<List<ProductCategory>> getFeaturedProductsCategories() =>
      productApi.getFeaturedProductsCategories();

  Future<List<ProductCategory>> getSearchCategories() =>
      productApi.getSearchCategories();

  Future<ProductSearchResult> getProductsByCategory(
          {int categoryId, Location location, bool isHardFilter = true}) =>
      productApi.getProductsByCategory(
          categoryId: categoryId,
          location: location,
          isHardFilter: isHardFilter);

  Future<ProductSearchResult> getProductsBySearchQuery(
          {String q, Location location, bool isHardFilter = true}) =>
      productApi.getProductsBySearchQuery(
          q: q, location: location, isHardFilter: isHardFilter);
}