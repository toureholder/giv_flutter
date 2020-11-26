import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  TestUtil testUtil;
  MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    testUtil = TestUtil();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  tearDown(() {
    reset(mockNavigatorObserver);
  });

  Widget makeTestableWidget(
    ProductCategory category, {
    bool returnChoice = false,
    List<int> hideThese,
    ListingType listingType,
  }) =>
      testUtil.makeTestableWidget(
        subject: CategoryListTile(
          returnChoice: returnChoice,
          hideThese: hideThese,
          category: category,
          listingType: listingType,
        ),
        dependencies: [
          Provider<SearchResultBloc>(
            create: (_) => MockSearchResultBloc(),
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  testWidgets('navigates to sub categories if category has subcategories',
      (WidgetTester tester) async {
    final testableWidget =
        makeTestableWidget(ProductCategory.fakeWithSubCategories());
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(ListTile));

    verify(mockNavigatorObserver.didPush(any, any));
  });

  testWidgets('navigates to search resiult if category has no subcategories',
      (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(ProductCategory.fake());
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(ListTile));

    verify(mockNavigatorObserver.didPush(any, any));
  });

  testWidgets(
      'navigates to sub categories if category has subcategories and choice should be retuned',
      (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(
        ProductCategory.fakeWithSubCategories(),
        returnChoice: true);
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(ListTile));

    verify(mockNavigatorObserver.didPush(any, any));
  });
}
