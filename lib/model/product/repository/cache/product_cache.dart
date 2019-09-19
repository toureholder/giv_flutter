import 'dart:convert';

import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache_provider.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCache implements ProductCacheProvider {
  static final ttlProductCategoryCache = 180;
  static final String _productCategoriesCacheKey = 'cache_product_categories';

  final SharedPreferences sharedPreferences;

  ProductCache({@required this.sharedPreferences});

  @override
  List<ProductCategory> getCategories(bool fetchAll) {
    final cacheKey = getCategoriesCacheKey(fetchAll);

    String jsonString = sharedPreferences.getString(cacheKey);

    try {
      CachePayload payload = CachePayload.fromJson(jsonDecode(jsonString));
      return payload.isValid
          ? ProductCategory.parseList(payload.serializedData)
          : null;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<bool> saveCategories(String responseBody, bool fetchAll) {
    final cacheKey = getCategoriesCacheKey(fetchAll);
    final payload = CachePayload(
        ttlInSeconds: ttlProductCategoryCache, serializedData: responseBody);
    return sharedPreferences.setString(cacheKey, json.encode(payload.toJson()));
  }

  @override
  String getCategoriesCacheKey(bool fetchAll) {
    final cacheKeyBuffer = StringBuffer(_productCategoriesCacheKey);
    if (fetchAll) cacheKeyBuffer.write('_fetch_all');
    return cacheKeyBuffer.toString();
  }
}
