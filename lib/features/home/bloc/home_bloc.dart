import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
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

      _contentPublishSubject.sink.add(HomeContent(results[0], results[1]));
    } catch (err) {
      _contentPublishSubject.sink.addError(err);
    }

  }
}

