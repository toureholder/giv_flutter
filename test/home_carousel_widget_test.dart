import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/home/ui/home_carousel.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  List<CarouselItem> carouselItems;

  setUp(() {
    carouselItems = CarouselItem.fakeListWithTwoItems();

    testableWidget = TestUtil().makeTestableWidget(
      subject: HomeCarousel(
        items: carouselItems,
        pageController: PageController(),
        height: 100,
        withIndicator: true,
        autoAdvance: true,
        loop: true,
        autoAdvanceDelay: Duration(seconds: 1),
        onTap: () {},
      ),
      dependencies: [
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
      ],
    );
  });

  testWidgets('widget builds', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);
    sleep(const Duration(seconds: 3));
  });
}
