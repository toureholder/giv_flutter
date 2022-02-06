import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/categories/ui/sub_categories.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:provider/provider.dart';

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
        products = json['listings'] == null
            ? null
            : Product.fromDynamicList(json['listings']),
        subCategories =
            json['children'] == null ? null : fromDynamicList(json['children']),
        displayOrder =
            json['display_order'] == null ? null : json['display_order'];

  void goToSubCategoryOrResult(
    Navigation navigation, {
    ListingType listingType,
  }) {
    if (subCategories?.isNotEmpty ?? false) {
      navigation.push(SubCategories(
        category: this,
        listingType: listingType,
      ));
    } else {
      navigation.push(Consumer<SearchResultBloc>(
        builder: (context, bloc, child) => SearchResult(
          category: this,
          listingType: listingType,
          bloc: bloc,
        ),
      ));
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
    return fromDynamicList(parsed);
  }

  static List<ProductCategory> fromDynamicList(List<dynamic> list) {
    return list
        .map<ProductCategory>((json) => ProductCategory.fromJson(json))
        .toList();
  }

  static List<ProductCategory> fakeList({@required int quantity}) {
    final list = <ProductCategory>[];

    quantity = quantity ?? 5;

    for (int i = 0; i < quantity; i++) {
      list.add(ProductCategory(
        id: i,
        simpleName: "Perto de você",
        canonicalName: "Perto de você",
        products: Product.fakeList(),
      ));
    }

    return list;
  }

  static List<ProductCategory> fakeListHomeContent() {
    return [
      ProductCategory(
        id: 34,
        simpleName: "Perto de você",
        canonicalName: "Perto de você",
        products: Product.fakeList(),
      ),
      ProductCategory(
        id: 35,
        simpleName: "Livros",
        canonicalName: "Livros",
        products: Product.fakeList(),
      ),
    ];
  }

  static List<ProductCategory> fakeListBrowsing() {
    return [
      ProductCategory(
          id: 0,
          simpleName: "Livros",
          canonicalName: "Example",
          subCategories: [
            ProductCategory(
              id: 1,
              simpleName: "Tudo de livros",
              canonicalName: "Example",
            ),
            ProductCategory(
              id: 2,
              simpleName: "Economia",
              canonicalName: "Example",
            ),
            ProductCategory(
              id: 3,
              simpleName: "Romance",
              canonicalName: "Example",
            ),
            ProductCategory(
              id: 4,
              simpleName: "Auto-ajuda",
              canonicalName: "Example",
            ),
            ProductCategory(
              id: 5,
              simpleName: "Em inglês",
              canonicalName: "Example",
            ),
          ]),
      ProductCategory(
          id: 10,
          simpleName: "Roupa",
          canonicalName: "Example",
          subCategories: [
            ProductCategory(
                id: 11,
                simpleName: "Masculino",
                canonicalName: "Example",
                subCategories: [
                  ProductCategory(
                    id: 111,
                    simpleName: 'Todos os tamanhos',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 112,
                    simpleName: 'Tamanho P',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 113,
                    simpleName: 'Tamanho M',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 114,
                    simpleName: 'Tamanho G',
                    canonicalName: "Example",
                  ),
                ]),
            ProductCategory(
                id: 12,
                simpleName: "Feminino",
                canonicalName: "Example",
                subCategories: [
                  ProductCategory(
                    id: 121,
                    simpleName: 'Todos os tamanhos',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 122,
                    simpleName: 'Tamanho P',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 123,
                    simpleName: 'Tamanho M',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 124,
                    simpleName: 'Tamanho G',
                    canonicalName: "Example",
                  ),
                ]),
            ProductCategory(
                id: 13,
                simpleName: "Infantil",
                canonicalName: "Example",
                subCategories: [
                  ProductCategory(
                    id: 131,
                    simpleName: 'Todos os tamanhos',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 132,
                    simpleName: 'Tamanho P',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 133,
                    simpleName: 'Tamanho M',
                    canonicalName: "Example",
                  ),
                  ProductCategory(
                    id: 134,
                    simpleName: 'Tamanho G',
                    canonicalName: "Example",
                  ),
                ]),
          ]),
      ProductCategory(
        id: 20,
        simpleName: "Música e hobbies",
        canonicalName: "Música e hobbies",
      )
    ];
  }

  factory ProductCategory.fake() => ProductCategory(
        id: 20,
        simpleName: "Música e hobbies",
        canonicalName: "Música e hobbies",
      );

  factory ProductCategory.fakeWithProducts() => ProductCategory(
        id: 35,
        simpleName: "Livros",
        products: Product.fakeList(),
      );

  factory ProductCategory.fakeWithSubCategories() => ProductCategory(
        id: 13,
        simpleName: "Infantil",
        canonicalName: "Roupa infantil",
        subCategories: [
          ProductCategory(
            id: 131,
            simpleName: 'Todos os tamanhos',
            canonicalName: 'Roupa infantil de todos os tamanhos',
          ),
          ProductCategory(
            id: 132,
            simpleName: 'Tamanho P',
            canonicalName: 'Roupa infantil tamanho P',
          ),
          ProductCategory(
            id: 133,
            simpleName: 'Tamanho M',
            canonicalName: 'Roupa infantil tamanho M',
          ),
          ProductCategory(
            id: 134,
            simpleName: 'Tamanho G',
            canonicalName: 'Roupa infantil tamanho G',
          ),
        ],
      );

  static String getCategoryListTitles(List<ProductCategory> categories) =>
      categories.map((it) => it.canonicalName).join(', ');
}
