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
