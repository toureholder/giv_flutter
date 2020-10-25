import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockSearchResultBloc mockSearchResultBloc;
  MockNavigatorObserver mockNavigatorObserver;
  MockUtil mockUtil;
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
    mockNavigatorObserver = MockNavigatorObserver();
    mockUtil = MockUtil();
    mockSearchResultBloc = MockSearchResultBloc();
  });

  tearDown(() {
    reset(mockNavigatorObserver);
  });

  Widget makeTestableWidget({
    ProductCategory category,
    String searchQuery,
    bool useCanonicalName = false,
  }) =>
      testUtil.makeTestableWidget(
        subject: SearchResult(
          bloc: mockSearchResultBloc,
          category: category,
          searchQuery: searchQuery,
          useCanonicalName: useCanonicalName,
        ),
        dependencies: [
          Provider<SearchResultBloc>(
            create: (_) => mockSearchResultBloc,
          ),
          Provider<Util>(
            create: (_) => mockUtil,
          ),
          Provider<LocationFilterBloc>(
            create: (_) => MockLocationFilterBloc(),
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  group('shows search teaser app bar when appropriate', () {
    testWidgets(
      'shows search teaser app bar if category is null',
      (WidgetTester tester) async {
        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);
        expect(find.byType(SearchTeaserAppBar), findsOneWidget);
        expect(find.byType(CustomAppBar), findsNothing);
      },
    );

    testWidgets(
      'shows custom app bar if category is not null',
      (WidgetTester tester) async {
        final testableWidget =
            makeTestableWidget(category: ProductCategory.fake());
        await tester.pumpWidget(testableWidget);
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(SearchTeaserAppBar), findsNothing);
      },
    );
  });

  group('loads content', () {
    testWidgets(
      'shows loading state when widget builds',
      (WidgetTester tester) async {
        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);
        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SearchResultListView), findsNothing);
      },
    );

    testWidgets(
      'shows list when data is loaded',
      (WidgetTester tester) async {
        final controller = PublishSubject<StreamEvent<ProductSearchResult>>();

        when(mockSearchResultBloc.result).thenAnswer((_) => controller.stream);

        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);

        controller.sink.add(StreamEvent<ProductSearchResult>(
            state: StreamEventState.ready, data: ProductSearchResult.fake()));

        await tester.pump();

        expect(find.byType(SharedLoadingState), findsNothing);
        expect(find.byType(SearchResultListView), findsOneWidget);

        controller.close();
      },
    );

    testWidgets(
      'shows list when data is loaded',
      (WidgetTester tester) async {
        final controller = PublishSubject<StreamEvent<ProductSearchResult>>();

        when(mockSearchResultBloc.result).thenAnswer((_) => controller.stream);

        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);

        controller.sink.add(StreamEvent<ProductSearchResult>(
            state: StreamEventState.ready, data: ProductSearchResult.fake()));

        await tester.pump();

        expect(find.byType(SharedLoadingState), findsNothing);
        expect(find.byType(SearchResultListView), findsOneWidget);

        controller.close();
      },
    );

    testWidgets(
      'shows empty state when data is loaded and empty',
      (WidgetTester tester) async {
        final controller = PublishSubject<StreamEvent<ProductSearchResult>>();

        when(mockSearchResultBloc.result).thenAnswer((_) => controller.stream);

        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);

        controller.sink.add(StreamEvent<ProductSearchResult>(
            state: StreamEventState.ready,
            data: ProductSearchResult.fakeEmpty()));

        await tester.pump();

        expect(find.byType(SharedLoadingState), findsNothing);
        expect(find.byType(SearchResultListView), findsOneWidget);
        expect(find.byType(SearchResultEmptyState), findsOneWidget);

        controller.close();
      },
    );

    testWidgets(
      'shows a progress indicator when data is loading',
      (WidgetTester tester) async {
        final controller = PublishSubject<StreamEvent<ProductSearchResult>>();

        when(mockSearchResultBloc.result).thenAnswer((_) => controller.stream);

        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);

        controller.sink.add(StreamEvent.loading());

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        controller.close();
      },
    );
  });

  group('navigates to location filter', () {
    testWidgets(
      'navigates to location filter when button is tapped',
      (WidgetTester tester) async {
        final controller = PublishSubject<StreamEvent<ProductSearchResult>>();

        when(mockSearchResultBloc.result).thenAnswer((_) => controller.stream);

        final testableWidget = makeTestableWidget(searchQuery: 'books');
        await tester.pumpWidget(testableWidget);

        controller.sink.add(StreamEvent<ProductSearchResult>(
            state: StreamEventState.ready, data: ProductSearchResult.fake()));

        await tester.pump();

        expect(find.byType(SearchFilterButton), findsOneWidget);

        await tester.tap(find.byType(SearchFilterButton));

        verify(mockNavigatorObserver.didPush(any, any));

        controller.close();
      },
    );
  });
}
