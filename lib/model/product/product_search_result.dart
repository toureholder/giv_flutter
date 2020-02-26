import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';

class ProductSearchResult {
  final Location location;
  final List<Product> products;

  ProductSearchResult({this.location, this.products});

  ProductSearchResult.fromJson(Map<String, dynamic> json)
      : location = Location.fromJson(json['location']),
        products = Product.fromDynamicList(json['listings']);

  ProductSearchResult.fake()
      : location = Location.fake(),
        products = Product.fakeList();

  ProductSearchResult.fakeEmpty()
      : location = Location.fake(),
        products = [];
}
