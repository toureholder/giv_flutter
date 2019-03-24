import 'dart:convert';

import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCache {
  static final ttlProductCategoryCache = 180;

  static final String _productCategoriesCacheKey = 'cache_product_categories';

  static Future<List<ProductCategory>> getCategories(bool fetchAll) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cacheKey = getCategoriesCacheKey(fetchAll);

    String jsonString = prefs.getString(cacheKey);

    try {
      CachePayload payload = CachePayload.fromJson(jsonDecode(jsonString));
      return payload.isValid
          ? ProductCategory.parseList(payload.serializedData)
          : null;
    } catch (error) {
      return null;
    }
  }

  static Future<bool> saveCategories(String responseBody, bool fetchAll) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cacheKey = getCategoriesCacheKey(fetchAll);
    final payload = CachePayload(
        ttlInSeconds: ttlProductCategoryCache, serializedData: responseBody);
    return prefs.setString(cacheKey, json.encode(payload.toJson()));
  }

  static String getCategoriesCacheKey(bool fetchAll) {
    final cacheKeyBuffer = StringBuffer(_productCategoriesCacheKey);
    if (fetchAll) cacheKeyBuffer.write('_fetch_all');
    return cacheKeyBuffer.toString();
  }
}
