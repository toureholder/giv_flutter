import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
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

  setUp(() {
    mockMyListingsBloc = MockMyListingsBloc();
    mockNavigationObserver = MockNavigatorObserver();

    testableWidget = TestUtil().makeTestableWidget(
      subject: MyListings(
        bloc: mockMyListingsBloc,
      ),
      dependencies: [
        Provider<MyListingsBloc>(
          builder: (_) => mockMyListingsBloc,
        ),
        Provider<Util>(
          builder: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [mockNavigationObserver],
    );
  });

  tearDown(() {
    reset(mockMyListingsBloc);
    reset(mockNavigationObserver);
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
    testWidgets('empty state button navigates to new listing page',
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

      verify(mockNavigationObserver.didPush(any, any));

      await publishSubject.close();
    });
  });
}
