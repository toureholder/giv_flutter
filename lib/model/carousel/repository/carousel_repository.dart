import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/carousel/repository/api/carousel_api.dart';

class CarouselRepository {
  final carouselApi = CarouselApi();

  Future<List<CarouselItem>> getHomeCarouselItems() =>
      carouselApi.getHomeCarouselItems();
}
