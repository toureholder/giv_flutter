import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';

abstract class ProductCacheProvider {
  List<ProductCategory> getCategories({
    bool fetchAll,
    ListingType type,
  });

  Future<CachePayload> saveCategories(
    String responseBody, {
    bool fetchAll,
    ListingType type,
  });
}
