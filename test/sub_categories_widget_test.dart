import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/product/categories/ui/sub_categories.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
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
  }) =>
      testUtil.makeTestableWidget(
        subject: SubCategories(
          returnChoice: returnChoice,
          hideThese: hideThese,
          category: category,
        ),
        dependencies: [
          Provider<SearchResultBloc>(
            builder: (_) => MockSearchResultBloc(),
          ),
          Provider<Util>(
            builder: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  testWidgets('builds',
      (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(
        ProductCategory.fakeWithSubCategories(),
        hideThese: [987]);
    await tester.pumpWidget(testableWidget);
  });
}
