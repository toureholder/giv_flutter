import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/model/authenticated_user_updated_action.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
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
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
    mockHomeBloc = MockHomeBloc();
    mockNewListingBloc = MockNewListingBloc();
    mockCategoriesBloc = MockCategoriesBloc();
    mockLoginBloc = MockLoginBloc();
    mockNavigationObserver = MockNavigatorObserver();

    testableWidget = testUtil.makeTestableWidget(
      subject: Base(),
      dependencies: [
        Provider<NewListingBloc>(
          create: (_) => mockNewListingBloc,
        ),
        Provider<HomeBloc>(
          create: (_) => mockHomeBloc,
        ),
        Provider<CategoriesBloc>(
          create: (_) => mockCategoriesBloc,
        ),
        Provider<LogInBloc>(
          create: (_) => mockLoginBloc,
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
        ChangeNotifierProvider<AuthUserUpdatedAction>(
          create: (context) => AuthUserUpdatedAction(),
        ),
      ],
      navigatorObservers: [mockNavigationObserver],
    );
  });

  tearDown(() {
    reset(mockNavigationObserver);
  });

  testWidgets('starts at home screen', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);
    expect(find.byType(Home), findsOneWidget);
  });

  testWidgets('reveals buttons to create new post page when fab is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(
      find.byType(BasePageFab),
      warnIfMissed: false,
    );

    await tester.pump();

    final bottomSheet = find.byType(BottomSheet);
    final donationButton = find.descendant(
      of: bottomSheet,
      matching: find.byType(PrimaryButton),
    );
    final donationRequestButton = find.descendant(
      of: bottomSheet,
      matching: find.byType(AccentButton),
    );

    expect(bottomSheet, findsOneWidget);
    expect(donationButton, findsOneWidget);
    expect(donationRequestButton, findsOneWidget);

    await testUtil.closeBottomSheetOrDialog(tester);
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

    await tester.tap(
      find.byKey(Key(Base.actionIdSearch)),
      warnIfMissed: false,
    );

    await tester.pump(Duration.zero);

    expect(find.byType(Categories), findsOneWidget);
    expect(find.byType(Home), findsNothing);

    await tester.tap(
      find.byKey(Key(Base.actionIdHome)),
      warnIfMissed: false,
    );

    await tester.pump(Duration.zero);

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(Categories), findsNothing);
  });
}
