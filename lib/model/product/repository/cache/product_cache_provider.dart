import 'package:giv_flutter/model/product/product_category.dart';

abstract class ProductCacheProvider {
  List<ProductCategory> getCategories(bool fetchAll);
  Future<bool> saveCategories(String responseBody, bool fetchAll);
  String getCategoriesCacheKey(bool fetchAll);
}