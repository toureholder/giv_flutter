import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache_provider.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';
import 'package:meta/meta.dart';

class ProductCache implements ProductCacheProvider {
  static final productCategoryCacheTTLInSeconds = 180;

  final DiskStorageProvider diskStorage;

  ProductCache({@required this.diskStorage});

  @override
  List<ProductCategory> getCategories({
    bool fetchAll,
    ListingType type,
  }) {
    final cacheKey = _getCategoriesCacheKey(fetchAll: fetchAll, type: type);

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
    String responseBody, {
    bool fetchAll,
    ListingType type,
  }) async {
    final cacheKey = _getCategoriesCacheKey(fetchAll: fetchAll, type: type);

    final payload = CachePayload(
        ttlInSeconds: productCategoryCacheTTLInSeconds,
        serializedData: responseBody);

    await diskStorage.setCachePayloadItem(cacheKey, payload);

    return payload;
  }

  String _getCategoriesCacheKey({bool fetchAll, ListingType type}) {
    final cacheKeyBuffer = StringBuffer(PRODUCT_CATEGORIES_CACHE_KEY);

    if (fetchAll != null && fetchAll) {
      cacheKeyBuffer.write('__fetch_all');
    }

    if (type != null) {
      cacheKeyBuffer.write('__type_${listingTypeToStringMap[type]}');
    }

    return cacheKeyBuffer.toString();
  }

  static const String PRODUCT_CATEGORIES_CACHE_KEY = 'cache_product_categories';
}
