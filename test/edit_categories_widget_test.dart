import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/listing/ui/edit_categories.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  TestUtil testUtil;
  MockNavigatorObserver mockNavigatorObserver;
  MockCategoriesBloc mockCategoriesBloc;

  setUp(() {
    testUtil = TestUtil();
    mockNavigatorObserver = MockNavigatorObserver();
    mockCategoriesBloc = MockCategoriesBloc();
  });

  tearDown(() {
    reset(mockNavigatorObserver);
  });

  Widget makeTestableWidget(List<ProductCategory> categories) =>
      testUtil.makeTestableWidget(
        subject: EditCategories(
          categories: categories,
          listingType: ListingType.donation,
        ),
        dependencies: [
          Provider<CategoriesBloc>(
            create: (_) => mockCategoriesBloc,
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  testWidgets(
    'shows add category footer of max quantaty has not been reached and does not show warning',
    (WidgetTester tester) async {
      final testableWidget =
          makeTestableWidget(ProductCategory.fakeList(quantity: 2));

      await tester.pumpWidget(testableWidget);

      expect(find.byType(AddCategoryTile), findsOneWidget);
      expect(find.byType(MaxQuantityWarningTile), findsNothing);
    },
  );

  testWidgets(
    'shows warning if max quantaty has not been reached and does not show add category footer',
    (WidgetTester tester) async {
      final testableWidget = makeTestableWidget(
          ProductCategory.fakeList(quantity: Config.maxProductImages));

      await tester.pumpWidget(testableWidget);

      expect(find.byType(MaxQuantityWarningTile), findsOneWidget);
      expect(find.byType(AddCategoryTile), findsNothing);
    },
  );

  testWidgets(
    'adds category when add category footer is tapped',
    (WidgetTester tester) async {
      final categoriesToBrowseThrough = ProductCategory.fakeListBrowsing();

      final categoriesSubject = BehaviorSubject<List<ProductCategory>>();
      categoriesSubject.sink.add(categoriesToBrowseThrough);
      when(mockCategoriesBloc.categories)
          .thenAnswer((_) => categoriesSubject.stream);

      final productCategories = ProductCategory.fakeList(quantity: 1);

      final testableWidget = makeTestableWidget(productCategories);

      await tester.pumpWidget(testableWidget);

      // Navigate to screen that should return result
      await tester.tap(
        find.byType(AddCategoryTile),
        warnIfMissed: false,
      );

      final Route pushedRoute =
          verify(mockNavigatorObserver.didPush(captureAny, any)).captured.last;

      ProductCategory popResult;
      pushedRoute.popped.then((result) => popResult = result);

      await tester.pumpAndSettle();

      expect(find.byType(Categories), findsOneWidget);

      // Interact with screen that should return result
      final selectedCategory =
          categoriesToBrowseThrough.firstWhere((it) => !it.hasSubCategories);

      final categoryListTile = find.byElementPredicate((Element element) {
        if (element.widget is CategoryListTile) {
          final CategoryListTile tile = element.widget;
          final categoryId = tile.category.id;
          return categoryId == selectedCategory.id;
        }
        return false;
      });

      await tester.tap(
        categoryListTile,
        warnIfMissed: false,
      );

      // Test how subject handled the result returned
      expect(popResult.id, selectedCategory.id);
      expect(productCategories.firstWhere((it) => it.id == selectedCategory.id),
          isNotNull);

      categoriesSubject.close();
    },
  );

  testWidgets(
    'shows an edit category tile for each category',
    (WidgetTester tester) async {
      final initialQuantity = 2;

      final testableWidget = makeTestableWidget(
          ProductCategory.fakeList(quantity: initialQuantity));

      await tester.pumpWidget(testableWidget);

      expect(find.byType(EditCategoryTile), findsNWidgets(initialQuantity));
    },
  );

  testWidgets(
    'removes category when delete icon is pressed',
    (WidgetTester tester) async {
      final initialQuantity = 2;

      final productCategories =
          ProductCategory.fakeList(quantity: initialQuantity);

      final testableWidget = makeTestableWidget(productCategories);

      await tester.pumpWidget(testableWidget);

      final tileFinder = find.byType(EditCategoryTile).first;

      final tileWidget = tester.widget<EditCategoryTile>(tileFinder);

      final deletedCategoryId = tileWidget.category.id;

      final deleteButton = find.descendant(
        of: find.byType(EditCategoryTile).first,
        matching: find.byType(DeleteButton),
      );

      await tester.tap(
        deleteButton,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      expect(productCategories.length, initialQuantity - 1);
      expect(
        productCategories.where((it) => it.id == deletedCategoryId),
        isEmpty,
      );
    },
  );

  testWidgets(
    'WIP: pops navigation stack if list is not empty',
    (WidgetTester tester) async {
      final initialQuantity = 2;

      final productCategories =
          ProductCategory.fakeList(quantity: initialQuantity);

      final testableWidget = makeTestableWidget(productCategories);

      await tester.pumpWidget(testableWidget);

      verifyNever(mockNavigatorObserver.didPop(any, any));

      await tester.tap(
        find.byType(PrimaryButton),
        warnIfMissed: false,
      );
    },
  );
}
