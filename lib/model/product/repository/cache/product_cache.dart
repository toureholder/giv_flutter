import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache_provider.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';
import 'package:meta/meta.dart';

class ProductCache implements ProductCacheProvider {
  static final ttlProductCategoryCache = 180;
  static final String _productCategoriesCacheKey = 'cache_product_categories';

  final DiskStorageProvider diskStorage;

  ProductCache({@required this.diskStorage});

  @override
  List<ProductCategory> getCategories(bool fetchAll) {
    final cacheKey = _getCategoriesCacheKey(fetchAll);

    try {
      CachePayload payload = diskStorage.getCachePayloadItem(cacheKey);
      return payload.isValid
          ? ProductCategory.parseList(payload.serializedData)
          : null;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<CachePayload> saveCategories(
      String responseBody, bool fetchAll) async {
    final cacheKey = _getCategoriesCacheKey(fetchAll);
    final payload = CachePayload(
        ttlInSeconds: ttlProductCategoryCache, serializedData: responseBody);
    await diskStorage.setCachePayloadItem(cacheKey, payload);
    return payload;
  }

  String _getCategoriesCacheKey(bool fetchAll) {
    final cacheKeyBuffer = StringBuffer(_productCategoriesCacheKey);
    if (fetchAll) cacheKeyBuffer.write('_fetch_all');
    return cacheKeyBuffer.toString();
  }
}
