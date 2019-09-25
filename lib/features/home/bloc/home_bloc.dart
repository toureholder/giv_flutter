import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class HomeBloc {
  HomeBloc({
    @required this.productRepository,
    @required this.carouselRepository,
    @required this.diskStorage,
    @required this.contentPublishSubject,
  });

  final ProductRepository productRepository;
  final CarouselRepository carouselRepository;
  final DiskStorageProvider diskStorage;
  final PublishSubject<HomeContent> contentPublishSubject;

  Observable<HomeContent> get content => contentPublishSubject.stream;

  dispose() {
    contentPublishSubject.close();
  }

  User getUser() => diskStorage.getUser();

  fetchContent() async {
    try {
      var results = await Future.wait([
        carouselRepository.getHomeCarouselItems(),
        productRepository.getFeaturedProductsCategories()
      ]);

      HttpResponse<List<CarouselItem>> heroItemsResponse = results[0];
      HttpResponse<List<ProductCategory>> featuredCategoriesResponse =
          results[1];

      if (heroItemsResponse.status == HttpStatus.ok &&
          featuredCategoriesResponse.status == HttpStatus.ok)
        contentPublishSubject.sink.add(HomeContent(
            heroItems: heroItemsResponse.data,
            productCategories: featuredCategoriesResponse.data));
      else
        contentPublishSubject.sink.addError(heroItemsResponse);
    } catch (err) {
      contentPublishSubject.sink.addError(err);
    }
  }
}
