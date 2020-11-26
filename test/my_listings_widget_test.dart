import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/create_listing_bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockMyListingsBloc mockMyListingsBloc;
  Widget testableWidget;
  MockNavigatorObserver mockNavigationObserver;
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
    mockMyListingsBloc = MockMyListingsBloc();
    mockNavigationObserver = MockNavigatorObserver();

    testableWidget = TestUtil().makeTestableWidget(
      subject: MyListings(
        bloc: mockMyListingsBloc,
      ),
      dependencies: [
        Provider<MyListingsBloc>(
          create: (_) => mockMyListingsBloc,
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [mockNavigationObserver],
    );
  });

  tearDown(() {
    reset(mockMyListingsBloc);
    reset(mockNavigationObserver);
  });

  Widget makeTestableWidget({
    bool isSelecting = false,
    int groupId,
  }) =>
      testUtil.makeTestableWidget(
        subject: MyListings(
          bloc: mockMyListingsBloc,
          isSelecting: isSelecting,
          groupId: groupId,
        ),
        dependencies: [
          Provider<MyListingsBloc>(
            create: (_) => mockMyListingsBloc,
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [mockNavigationObserver],
      );

  group('ui', () {
    testWidgets('builds', (WidgetTester tester) async {
      testableWidget = makeTestableWidget();
      await tester.pumpWidget(testableWidget);

      expect(find.byType(MyListings), findsOneWidget);
    });

    testWidgets('shows "My listings" title when isSelecting is false',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget();
      await tester.pumpWidget(testableWidget);

      expect(
        find.descendant(
          of: find.byType(CustomAppBar),
          matching: testUtil.findInternationalizedText('me_listings'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('does not show "My listings" title when isSelecting is true',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isSelecting: true,
      );
      await tester.pumpWidget(testableWidget);

      expect(
        find.descendant(
          of: find.byType(CustomAppBar),
          matching: testUtil.findInternationalizedText('me_listings'),
        ),
        findsNothing,
      );
    });

    testWidgets('shows "Select items" text button when isSelecting is true',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget(
        isSelecting: true,
      );
      await tester.pumpWidget(testableWidget);

      expect(
        find.descendant(
          of: find.byType(CustomAppBar),
          matching: find.descendant(
            of: find.byType(MediumFlatPrimaryButton),
            matching:
                testUtil.findInternationalizedText('my_listings_select_items'),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows add icon button when isSelecting is false',
        (WidgetTester tester) async {
      testableWidget = makeTestableWidget();
      await tester.pumpWidget(testableWidget);

      expect(
        find.descendant(
          of: find.byType(CustomAppBar),
          matching: find.byType(IconButton),
        ),
        findsOneWidget,
      );
    });
  });

  group('loads content correctly', () {
    testWidgets('shows circular progress inidicator while loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(SharedLoadingState), findsOneWidget);
      expect(find.byType(SharedErrorState), findsNothing);
      expect(find.byType(MyListingsScrollView), findsNothing);
      expect(find.byType(MyListingsEmptyState), findsNothing);
    });

    testWidgets('loads content', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      verify(mockMyListingsBloc.fetchMyProducts()).called(1);
    });

    testWidgets('shows scroll view when a list of products is added to stream',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<List<Product>>();

      when(mockMyListingsBloc.productsStream)
          .thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(Product.fakeList());

      await tester.pump(Duration.zero);

      expect(find.byType(SharedLoadingState), findsNothing);
      expect(find.byType(SharedErrorState), findsNothing);
      expect(find.byType(MyListingsScrollView), findsOneWidget);
      expect(find.byType(MyListingsEmptyState), findsNothing);

      await publishSubject.close();
    });

    testWidgets('shows empty state when an empty list is added to stream',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<List<Product>>();

      when(mockMyListingsBloc.productsStream)
          .thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(<Product>[]);

      await tester.pump(Duration.zero);

      expect(find.byType(SharedLoadingState), findsNothing);
      expect(find.byType(SharedErrorState), findsNothing);
      expect(find.byType(MyListingsScrollView), findsNothing);
      expect(find.byType(MyListingsEmptyState), findsOneWidget);

      await publishSubject.close();
    });
  });

  group('navigation works as expexted', () {
    testWidgets('empty state button opens create listing bottom sheet',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<List<Product>>();

      when(mockMyListingsBloc.productsStream)
          .thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(<Product>[]);

      await tester.pump(Duration.zero);

      final emptyState = find.byType(MyListingsEmptyState);
      final emptySateButton =
          find.descendant(of: emptyState, matching: find.byType(PrimaryButton));
      await tester.tap(emptySateButton);

      await tester.pump(Duration.zero);

      expect(find.byType(CreateListingBottomSheet), findsOneWidget);

      await testUtil.closeBottomSheetOrDialog(tester);

      await publishSubject.close();
    });
  });
}
