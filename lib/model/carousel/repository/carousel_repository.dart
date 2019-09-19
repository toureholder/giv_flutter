import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/carousel/repository/api/carousel_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class CarouselRepository {
  final CarouselApi carouselApi;

  CarouselRepository({@required this.carouselApi});

  Future<HttpResponse<List<CarouselItem>>> getHomeCarouselItems() =>
      carouselApi.getHomeCarouselItems();
}
