import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class HomeBloc {
  HomeBloc({
    @required this.productRepository,
    @required this.carouselRepository,
  });

  final ProductRepository productRepository;
  final CarouselRepository carouselRepository;
  final _contentPublishSubject = PublishSubject<HomeContent>();

  Observable<HomeContent> get content => _contentPublishSubject.stream;

  dispose() {
    _contentPublishSubject.close();
  }

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
        _contentPublishSubject.sink.add(HomeContent(
            heroItems: heroItemsResponse.data,
            productCategories: featuredCategoriesResponse.data));
      else
        _contentPublishSubject.sink.addError(heroItemsResponse);
    } catch (err) {
      _contentPublishSubject.sink.addError(err);
    }
  }
}
