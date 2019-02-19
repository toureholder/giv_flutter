import 'dart:convert';

import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/model/product/product_category.dart';

class CarouselItem {
  final String imageUrl;
  final String linkUrl;
  final String title;
  final String caption;
  final ProductCategory productCategory;
  final String actionId;

  CarouselItem({
    this.imageUrl,
    this.linkUrl,
    this.title,
    this.caption,
    this.productCategory,
    this.actionId,
  });

  CarouselItem.fromJson(Map<String, dynamic> json)
      : imageUrl = json['image_url'],
        linkUrl = json['link_url'],
        title = json['title'],
        caption = json['caption'],
        actionId = json['action_id'],
        productCategory = json['category'] == null ? null : ProductCategory.fromJson(json['category']);

  static List<CarouselItem> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return fromDynamicList(parsed);
  }

  static List<CarouselItem> fromDynamicList(List<dynamic> list) {
    return list
        .map<CarouselItem>((json) => CarouselItem.fromJson(json))
        .toList();
  }

  static List<CarouselItem> mockList() {
    return [
      CarouselItem(
        imageUrl: 'https://picsum.photos/400/300/?image=20',
        title: 'Quanta coisa!',
        caption: 'Dê uma pesquisada, vai ;)',
        actionId: Base.actionIdSearch,
      ),
      CarouselItem(
        imageUrl: 'https://picsum.photos/400/300/?image=1073',
        title: 'Melhore seu inglês',
        caption: 'Veja os livros sendo doados',
        productCategory: ProductCategory(id: 5, simpleName: "Livros em inglês"),
      ),
      CarouselItem(
        imageUrl: 'https://picsum.photos/400/300/?image=535',
        title: 'Abra espaço para o novo',
        caption: 'Descubra como é fácil doar',
        actionId: Base.actionIdPost,
      ),
    ];
  }
}
