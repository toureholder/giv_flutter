import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockNewListingBloc mockNewListingBloc;
  MockCategoriesBloc mockCategoriesBloc;
  MockHomeBloc mockHomeBloc;
  MockLoginBloc mockLoginBloc;
  MockNavigatorObserver mockNavigationObserver;
  Widget testableWidget;

  setUp(() {
    mockHomeBloc = MockHomeBloc();
    mockNewListingBloc = MockNewListingBloc();
    mockCategoriesBloc = MockCategoriesBloc();
    mockLoginBloc = MockLoginBloc();
    mockNavigationObserver = MockNavigatorObserver();

    testableWidget = TestUtil().makeTestableWidget(
      subject: Base(),
      dependencies: [
        Provider<NewListingBloc>(
          builder: (_) => mockNewListingBloc,
        ),
        Provider<HomeBloc>(
          builder: (_) => mockHomeBloc,
        ),
        Provider<CategoriesBloc>(
          builder: (_) => mockCategoriesBloc,
        ),
        Provider<LogInBloc>(
          builder: (_) => mockLoginBloc,
        ),
        Provider<Util>(
          builder: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [mockNavigationObserver],
    );
  });

  tearDown((){
    reset(mockNavigationObserver);
  });

  testWidgets('starts at home screen', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);
    expect(find.byType(Home), findsOneWidget);
  });

  testWidgets('navigates to create new post page when fab is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(BasePageFab));

    verify(mockNavigationObserver.didPush(any, any));

    await tester.pumpAndSettle();

    expect(find.byType(NewListing), findsOneWidget);
  });

  testWidgets('shows home and search bottom navigation items',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    expect(find.byKey(Key(Base.actionIdSearch)), findsOneWidget);
    expect(find.byKey(Key(Base.actionIdHome)), findsOneWidget);
  });

  testWidgets('switches base page when bottom bar is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byKey(Key(Base.actionIdSearch)));

    await tester.pump(Duration.zero);

    expect(find.byType(Categories), findsOneWidget);
    expect(find.byType(Home), findsNothing);

    await tester.tap(find.byKey(Key(Base.actionIdHome)));

    await tester.pump(Duration.zero);

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(Categories), findsNothing);
  });
}
