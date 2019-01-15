import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/features/product/categories/ui/sub_categories.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:meta/meta.dart';

class ProductCategory {
  final int id;
  final String title;
  final List<Product> products;
  final List<ProductCategory> subCategories;

  ProductCategory ({
    @required this.id,
    @required this.title,
    this.products,
    this.subCategories});

  void goToSubCategoryOrResult(Navigation navigation) {
    if (subCategories?.isNotEmpty ?? false) {
      navigation.push(SubCategories(category: this));
    } else {
      navigation.push(SearchResult(category: this));
    }
  }

  bool get hasSubCategories => subCategories?.isNotEmpty ?? false;

  static List<ProductCategory> homeMock() {
    return [
      ProductCategory(
          id: 34,
          title: "Perto de você",
          products: Product.getMockList()
      ),
      ProductCategory(
          id: 35,
          title: "Livros",
          products: Product.getMockList()
      ),
      ProductCategory(
          id: 36,
          title: "Roupas femininas",
          products: Product.getMockList()
      )
    ];
  }

  static List<ProductCategory> browseMock() {
    return [
      ProductCategory(
          id: 0,
          title: "Livros",
          subCategories: [
            ProductCategory(id: 1, title: "Tudo de livros"),
            ProductCategory(id: 2, title: "Economia"),
            ProductCategory(id: 3, title: "Romance"),
            ProductCategory(id: 4, title: "Auto-ajuda"),
            ProductCategory(id: 5, title: "Em inglês"),
          ]
      ),
      ProductCategory(
          id: 10,
          title: "Roupa",
          subCategories: [
            ProductCategory(
                id: 11,
                title: "Masculino",
                subCategories: [
                  ProductCategory(id: 111, title: 'Todos os tamanhos'),
                  ProductCategory(id: 112, title: 'Tamanho P'),
                  ProductCategory(id: 113, title: 'Tamanho M'),
                  ProductCategory(id: 114, title: 'Tamanho G'),
                ]),
            ProductCategory(
                id: 12,
                title: "Feminino",
                subCategories: [
                  ProductCategory(id: 121, title: 'Todos os tamanhos'),
                  ProductCategory(id: 122, title: 'Tamanho P'),
                  ProductCategory(id: 123, title: 'Tamanho M'),
                  ProductCategory(id: 124, title: 'Tamanho G'),
                ]),
            ProductCategory(
                id: 13,
                title: "Infantil",
                subCategories: [
                  ProductCategory(id: 131, title: 'Todos os tamanhos'),
                  ProductCategory(id: 132, title: 'Tamanho P'),
                  ProductCategory(id: 133, title: 'Tamanho M'),
                  ProductCategory(id: 134, title: 'Tamanho G'),
                ]),
          ]
      ),
      ProductCategory(
          id: 20,
          title: "Música e hobbies",
      )
    ];
  }
}