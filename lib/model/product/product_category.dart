import 'package:giv_flutter/model/product/product.dart';
import 'package:meta/meta.dart';

class ProductCategory {
  final String title;
  final List<Product> products;

  ProductCategory({@required this.title, @required this.products});

  static List<ProductCategory> mockList() {
    return [
      ProductCategory(
          title: "Perto de você",
          products: Product.getMockList(6)
      ),
      ProductCategory(
          title: "Livros - Brasília, DF",
          products: Product.getMockList(6, prefix: "2")
      ),
      ProductCategory(
          title: "Roupas femininas - Brasília, DF",
          products: Product.getMockList(6, prefix: "9")
      )
    ];
  }
}