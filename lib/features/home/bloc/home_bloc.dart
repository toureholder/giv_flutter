import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _productRepository = ProductRepository();
  final _carouselRepository = CarouselRepository();

  final _contentPublishSubject = PublishSubject<HomeContent>();

  Observable<HomeContent> get content =>
      _contentPublishSubject.stream;

  dispose() {
    _contentPublishSubject.close();
  }

  fetchContent() async {
    try {
      var results = await Future.wait([
        _carouselRepository.getHomeCarouselItems(),
        _productRepository.getFeaturedProductsCategories()
      ]);

      HttpResponse<List<CarouselItem>> heroItemsResponse = results[0] as HttpResponse;

      if (heroItemsResponse.status == HttpStatus.ok)
        _contentPublishSubject.sink.add(HomeContent(heroItems: heroItemsResponse.data, productCategories: results[1]));
      else
        _contentPublishSubject.sink.addError(heroItemsResponse);
    } catch (err) {
      _contentPublishSubject.sink.addError(err);
    }
  }
}

