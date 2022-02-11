import 'package:giv_flutter/model/carousel/repository/carousel_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  CarouselRepository carouselRepository;
  MockCarouselApi mockCarouselApi;

  setUp(() {
    mockCarouselApi = MockCarouselApi();
    carouselRepository = CarouselRepository(carouselApi: mockCarouselApi);
  });

  tearDown(() {
    reset(mockCarouselApi);
  });

  test('calls appConfig api', () async {
    await carouselRepository.getHomeCarouselItems();
    verify(mockCarouselApi.getHomeCarouselItems());
  });
}
