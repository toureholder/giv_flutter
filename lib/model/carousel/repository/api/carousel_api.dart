import 'package:giv_flutter/model/carousel/carousel_item.dart';

class CarouselApi {

  Future<List<CarouselItem>> getHomeCarouselItems() async {
    await Future.delayed(Duration(seconds: 4));
    return CarouselItem.mockList();
  }
}
