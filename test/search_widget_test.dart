import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/product/search/search.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/material_search.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

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

  Widget makeTestableWidget({String initialText}) =>
      testUtil.makeTestableWidget(
        subject: Search(
          bloc: mockSearchResultBloc,
          initialText: initialText,
        ),
        dependencies: [
          Provider<SearchResultBloc>(
            builder: (_) => mockSearchResultBloc,
          ),
          Provider<Util>(
            builder: (_) => mockUtil,
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  testWidgets('displays search suggestions', (WidgetTester tester) async {
    final searchQuery = 'book';
    final suggestionsQuantity = 5;

    when(mockSearchResultBloc.getSearchSuggestions(any)).thenAnswer(
        (_) async => ProductCategory.fakeList(quantity: suggestionsQuantity));

    final testableWidget = makeTestableWidget();
    await tester.pumpWidget(testableWidget);

    await tester.enterText(find.byType(TextField), searchQuery);

    await tester.pumpAndSettle();

    final materialSearchResultType = MaterialSearchResult<String>().runtimeType;

    expect(
      find.byType(materialSearchResultType),
      findsNWidgets(suggestionsQuantity),
    );
  });

  testWidgets(
    'searches by category id when suggestion is clicked',
    (WidgetTester tester) async {
      final searchQuery = 'book';
      final suggestionsQuantity = 5;

      when(mockSearchResultBloc.getSearchSuggestions(any)).thenAnswer(
          (_) async => ProductCategory.fakeList(quantity: suggestionsQuantity));

      final testableWidget = makeTestableWidget();
      await tester.pumpWidget(testableWidget);

      await tester.enterText(find.byType(TextField), searchQuery);

      await tester.pumpAndSettle();

      final materialSearchResultType =
          MaterialSearchResult<String>().runtimeType;

      await tester.tap(find.byType(materialSearchResultType).first);

      verify(mockNavigatorObserver.didPush(any, any));
    },
  );

  testWidgets(
    'searches by query on text input search action',
        (WidgetTester tester) async {
      final searchQuery = 'book';
      final suggestionsQuantity = 5;

      when(mockSearchResultBloc.getSearchSuggestions(any)).thenAnswer(
              (_) async => ProductCategory.fakeList(quantity: suggestionsQuantity));

      final testableWidget = makeTestableWidget();
      await tester.pumpWidget(testableWidget);

      await tester.enterText(find.byType(TextField), searchQuery);

      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.search);

      verify(mockNavigatorObserver.didPush(any, any));
    },
  );
}
