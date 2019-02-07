import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/categories/ui/sub_categories.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:meta/meta.dart';

class ProductCategory {
  final int id;
  final String simpleName;
  final String canonicalName;
  final List<Product> products;
  final List<ProductCategory> subCategories;
  final int displayOrder;

  ProductCategory(
      {this.id,
      @required this.simpleName,
      this.canonicalName,
      this.products,
      this.subCategories,
      this.displayOrder});

  ProductCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        simpleName = json['simple_name'],
        canonicalName = json['canonical_name'],
        products = null,
        subCategories = convertDynamicList(json['children']),
        displayOrder = json['display_order'];

  void goToSubCategoryOrResult(Navigation navigation) {
    if (subCategories?.isNotEmpty ?? false) {
      navigation.push(SubCategories(category: this));
    } else {
      navigation.push(SearchResult(category: this));
    }
  }

  bool get hasSubCategories => subCategories?.isNotEmpty ?? false;

  String getNameAsParent(BuildContext context) {
    final prefix = GetLocalizedStringFunction(context)(
        'sub_categories_parent_category_prefix');
    return '$prefix ${canonicalName.toLowerCase()}';
  }

  static List<ProductCategory> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return convertDynamicList(parsed);
  }

  static List<ProductCategory> convertDynamicList(List<dynamic> list) {
    return list
        .map<ProductCategory>((json) => ProductCategory.fromJson(json))
        .toList();
  }

  static List<ProductCategory> homeMock() {
    return [
      ProductCategory(
          id: 34, simpleName: "Perto de você", products: Product.getMockList()),
      ProductCategory(
          id: 35, simpleName: "Livros", products: Product.getMockList()),
      ProductCategory(
          id: 36,
          simpleName: "Roupas femininas",
          products: Product.getMockList())
    ];
  }

  static List<ProductCategory> browseMock() {
    return [
      ProductCategory(id: 0, simpleName: "Livros", subCategories: [
        ProductCategory(id: 1, simpleName: "Tudo de livros"),
        ProductCategory(id: 2, simpleName: "Economia"),
        ProductCategory(id: 3, simpleName: "Romance"),
        ProductCategory(id: 4, simpleName: "Auto-ajuda"),
        ProductCategory(id: 5, simpleName: "Em inglês"),
      ]),
      ProductCategory(id: 10, simpleName: "Roupa", subCategories: [
        ProductCategory(id: 11, simpleName: "Masculino", subCategories: [
          ProductCategory(id: 111, simpleName: 'Todos os tamanhos'),
          ProductCategory(id: 112, simpleName: 'Tamanho P'),
          ProductCategory(id: 113, simpleName: 'Tamanho M'),
          ProductCategory(id: 114, simpleName: 'Tamanho G'),
        ]),
        ProductCategory(id: 12, simpleName: "Feminino", subCategories: [
          ProductCategory(id: 121, simpleName: 'Todos os tamanhos'),
          ProductCategory(id: 122, simpleName: 'Tamanho P'),
          ProductCategory(id: 123, simpleName: 'Tamanho M'),
          ProductCategory(id: 124, simpleName: 'Tamanho G'),
        ]),
        ProductCategory(id: 13, simpleName: "Infantil", subCategories: [
          ProductCategory(id: 131, simpleName: 'Todos os tamanhos'),
          ProductCategory(id: 132, simpleName: 'Tamanho P'),
          ProductCategory(id: 133, simpleName: 'Tamanho M'),
          ProductCategory(id: 134, simpleName: 'Tamanho G'),
        ]),
      ]),
      ProductCategory(
        id: 20,
        simpleName: "Música e hobbies",
      )
    ];
  }

  static String getCategoryListTitles(List<ProductCategory> categories) =>
      categories.map((it) => it.canonicalName).join(', ');
}
