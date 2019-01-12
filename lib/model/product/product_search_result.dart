import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';

class ProductSearchResult {
  final Location location;
  final List<Product> products;

  ProductSearchResult({this.location, this.products});

  ProductSearchResult.mock()
      : location = Location.mock(),
        products = Product.getMockList();
}
